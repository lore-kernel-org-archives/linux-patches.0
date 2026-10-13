Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9914B95C0;
	Tue, 13 Oct 2026 11:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891960; cv=none; b=Uq/NsudwbTgystfLwvbDrG1rmzVYQo3eLP9b3CX2mUBAJDKvxn2D3mmDZpxkTi1picaRzQVfC6EhkAUj39VJlUerYSWzzRV8aXZ9hN/OZmRlsluJCI/VKZRviG9m+8M7URfUWKUs1EuJfG1Ob6Pjpp/LrUb75qi2emr3aEBOk8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891960; c=relaxed/simple;
	bh=WB6ijJEvSFGHJtlaf9/GW+9ri+rMONXFbQS+aTZFlvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttxfgFx0bE7GDB8HYwGQjZPBpmKwzdIXdWEzCF3K2TPkUGbT94DSlNNcrXddgvlwJ6wk/texIT4gJPHAEHp4hy+0Lzz6UDBedOj+vfYevmkQF0OT3dUrbE17abJtTXO8blZufOvEREg366uN4eV+gRs2YJq7w3i8OqAIaQCuAlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6k/7+Hu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6k/7+Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A9A1F00893;
	Tue, 13 Oct 2026 11:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891958;
	bh=QKwwIdw3R/qvwYMyOlDdN6Yxc5hfLyS2Y6ynBNsGv0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6k/7+HuGIvprE2s3fjRs7nZI0zu8GpHKYbXQvOpbz3UGzmtN2CHryDfrno6phSyO
	 T4RkPTemRWsW1v8ikzo8GApbJQjQQb2XzteQuJ11iCctel6QHRL7byYxeyEkOHy4eE
	 SAvPG2qZTrp93s0g6gJ2h5wCHBneKb/Nbvghs+nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 014/281] ipv6: do not warn on route notification size race
Date: Tue, 13 Oct 2026 13:35:30 +0200
Message-ID: <20261013112855.395241390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit c97426ec649d99596d8969e1a052c16b14b7b485 upstream.

fib6_info_hw_flags_set() sizes the skb with rt6_nlmsg_size() and later
fills it with rt6_fill_node().  With nexthop compatibility mode enabled,
a concurrent replacement can grow the group between these independent
snapshots.  rt6_fill_node() can then legitimately return -EMSGSIZE, so
the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261007114003.GA1011260@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/4012604727e5ba80b69ccd4d08796511397ddaef.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6474,8 +6474,6 @@ void fib6_info_hw_flags_set(struct net *
 	err = rt6_fill_node(net, skb, f6i, NULL, NULL, NULL, 0, RTM_NEWROUTE, 0,
 			    0, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


