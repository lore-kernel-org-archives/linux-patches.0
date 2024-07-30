Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891111A76A9;
	Tue, 30 Jul 2024 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359927; cv=none; b=U0XUg26+HVV8HcFLYNnKDGP1w4a9bHhDZrhpI1HL4+hdlhuvGEYev6BSF6VBhu76LpB4obi2XBcfR8SY2Uzak298xR9gEY9rhbfpZUoUfpATJwvnWf2tYDm/Uc6q2bQ6b1eHXSGM2tzA+uucfR9v+ajqnvEgaWOHzdynObYcS0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359927; c=relaxed/simple;
	bh=wPhm8N4ek2/cEdKv1hiw0kFq8SMjOIANbBPAxDzVqm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOi6u3E1qYH3UWdT4deeUtrVau3RRu6DiPgEum0Y+CHQS11mY2Qo1l4rMfXuqvFvpGp5g/SVPay1GsoekNgC97bNNqepEgWrgl2DGTcUulLp0oBdxIGM7S/NjniCs8xlcdF8mKglfjsvOShm8jFWgHrpGggzHIODqcdpvBXD288=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/7mtcac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/7mtcac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F7DC32782;
	Tue, 30 Jul 2024 17:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359927;
	bh=wPhm8N4ek2/cEdKv1hiw0kFq8SMjOIANbBPAxDzVqm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/7mtcacxWQ8BF0iYbJJtU4lv/AVrfv6HG/jD93cIo/UJmzymO7sqdVwsphk2wDC9
	 21JQdBOZvK6GmopW/LEINs5dYkfoeUExZQ6Bw7OVaWftf/Ot1a/G6y5WlV2hDwmamZ
	 j/4y6iQBIBJwGpPXdGA7gpnuUUh1CiZeC6aZU09g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 555/809] ipv4: fix source address selection with route leak
Date: Tue, 30 Jul 2024 17:47:11 +0200
Message-ID: <20240730151746.678294840@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 6807352353561187a718e87204458999dbcbba1b upstream.

By default, an address assigned to the output interface is selected when
the source address is not specified. This is problematic when a route,
configured in a vrf, uses an interface from another vrf (aka route leak).
The original vrf does not own the selected source address.

Let's add a check against the output interface and call the appropriate
function to select the source address.

CC: stable@vger.kernel.org
Fixes: 8cbb512c923d ("net: Add source address lookup op for VRF")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-2-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2270,6 +2270,15 @@ void fib_select_path(struct net *net, st
 		fib_select_default(fl4, res);
 
 check_saddr:
-	if (!fl4->saddr)
-		fl4->saddr = fib_result_prefsrc(net, res);
+	if (!fl4->saddr) {
+		struct net_device *l3mdev;
+
+		l3mdev = dev_get_by_index_rcu(net, fl4->flowi4_l3mdev);
+
+		if (!l3mdev ||
+		    l3mdev_master_dev_rcu(FIB_RES_DEV(*res)) == l3mdev)
+			fl4->saddr = fib_result_prefsrc(net, res);
+		else
+			fl4->saddr = inet_select_addr(l3mdev, 0, RT_SCOPE_LINK);
+	}
 }


