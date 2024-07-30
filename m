Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658131A619B;
	Tue, 30 Jul 2024 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357479; cv=none; b=eUnGIxxWwclzwksRCEH6kwbklcJYjl9kpp9iLeFwVsZJjy8w5XaImzw6lPLPJ1KGv/rfMSwsKwhA4+a+F+btr8l6Jau9j8YR0pz/vzcTeTcDz5vuMu+D2MgokoJT/VtmG5hNCrsI0v2wH+oNE79q23N3Z/8z/SGn/ZPNfgZFsqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357479; c=relaxed/simple;
	bh=IIugkNTzB83k9bPlnrIDN2yYTPSY/s+GfPkBX5gsieg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaQLKEsZrdV+BiR3KqHGoCH5SOit2CBkkdYvjQFgZavNrCBtJ1oNwtVODyZZeAO3FUS6K20waSXh2d39NtFNkuObcEHK2hr/6ru3tb73bg/I+aHwY52OkZF6kOsFkWJ/pwzywoaRyXCwY/3YfoBFXLk0ZbJMtYsvwYNJwcm6Cps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6lnMQRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6lnMQRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3470C4AF0C;
	Tue, 30 Jul 2024 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357479;
	bh=IIugkNTzB83k9bPlnrIDN2yYTPSY/s+GfPkBX5gsieg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6lnMQRXynytY+T8S8sCZ3+NT1Kf/nmNCf5Vm48JtRo5g5KtRoeG7/ryc5AOnh5ss
	 +VEsHvZvmntVwu/jymAmsd9xplEAtL/acPNeG1wPfe1XridgBAvUV6YzV9icW/h6rf
	 HGbFs2zX9stHeBkWs06QxnlP2Mh0xOOaO4LV5KaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 281/440] ipv4: fix source address selection with route leak
Date: Tue, 30 Jul 2024 17:48:34 +0200
Message-ID: <20240730151626.805844724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


