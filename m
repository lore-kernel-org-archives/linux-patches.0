Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0216225A38;
	Mon, 13 Apr 2026 16:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097937; cv=none; b=htpob++eq5RK8tljn9v9KozFvZfjI5oFuOZBRf5j9EfVStrER+spPriYlCw507s9Ou7lqFHk9IDwuNypS0aj1pOB1NwUzepOYPXEWz/dD3eeFb+fB1OfivXn6r/qqJp+xyo1+MGq8kzaKqputDfOPnrv0dM8WOA5auOjWa1mV9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097937; c=relaxed/simple;
	bh=ugZBSYykYMKHmo9ygtGYR+kKsp3hQzcaX3ASFh32EJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqRDialsMr3nVG2dYJgJNlIdp+KK15TT5K9ehFv11H3xuIZd0Fksl/IBVtk3DyQ+aHukAEP1ZWYKrLIhsFk07ww3HvrNnAizIfmHtd3gnSzv3+JtmcbCfXqFjBaPysR/5vFWe1AABFPsSNj6zu7FMY4xH/njIxRzjTdccYLfbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBNkQ263; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBNkQ263"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3564EC2BCAF;
	Mon, 13 Apr 2026 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097937;
	bh=ugZBSYykYMKHmo9ygtGYR+kKsp3hQzcaX3ASFh32EJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBNkQ263YCbYhgsXupW7NEDIqDZdUOGBcrnUZe7TuqG4wt26t2D15vXoQIfLxqVM2
	 o0MQ6aIqBduUo14kAfwpC1ZmgxObPO/HMc3CGVkj2h3h7WsoK+56mHVhOHRhQyFo7G
	 f+IsiZAyl9LqEZUlnOEIW4tZsnFB3LfwMlpFlC7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/570] net: fix fanout UAF in packet_release() via NETDEV_UP race
Date: Mon, 13 Apr 2026 17:57:40 +0200
Message-ID: <20260413155842.819587230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit 42156f93d123436f2a27c468f18c966b7e5db796 ]

`packet_release()` has a race window where `NETDEV_UP` can re-register a
socket into a fanout group's `arr[]` array. The re-registration is not
cleaned up by `fanout_release()`, leaving a dangling pointer in the fanout
array.
`packet_release()` does NOT zero `po->num` in its `bind_lock` section.
After releasing `bind_lock`, `po->num` is still non-zero and `po->ifindex`
still matches the bound device. A concurrent `packet_notifier(NETDEV_UP)`
that already found the socket in `sklist` can re-register the hook.
For fanout sockets, this re-registration calls `__fanout_link(sk, po)`
which adds the socket back into `f->arr[]` and increments `f->num_members`,
but does NOT increment `f->sk_ref`.

The fix sets `po->num` to zero in `packet_release` while `bind_lock` is
held to prevent NETDEV_UP from linking, preventing the race window.

This bug was found following an additional audit with Claude Code based
on CVE-2025-38617.

Fixes: ce06b03e60fc ("packet: Add helpers to register/unregister ->prot_hook")
Link: https://blog.calif.io/p/a-race-within-a-race-exploiting-cve
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260319200610.25101-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 6e7c94fa02bd9..d1ad069271f8b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3147,6 +3147,7 @@ static int packet_release(struct socket *sock)
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, false);
+	WRITE_ONCE(po->num, 0);
 	packet_cached_dev_reset(po);
 
 	if (po->prot_hook.dev) {
-- 
2.51.0



