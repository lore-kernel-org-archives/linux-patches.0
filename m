Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F02DECDE;
	Tue, 31 Mar 2026 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976479; cv=none; b=dZ8CnCy4F2gAlXhBsHt+Lkdb49qPlbHI45scFnHJpbFoMdM5pKmx5kxV2Eova2NU/ZBlQ2xrwzEdEcFTT227Q9Tg6sRhVNb3JYuioUr5KU8N62Vwz4urCKVm/siF18D5/dZe9u2SJI47LgmvnsENjrXtiHcIx18AvWDx8mPhKRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976479; c=relaxed/simple;
	bh=zD5OrftLh5YM8enw2ROeNXU96hd6NrJvm5VaNTGyMe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFFXXLCgo05PB0BiW3P+xZv2ANrgLIVKUIaSNU1Yefm/20F3329D+X/tmUwFlmNRCpdzbIYg1p39zzPhjY+l0ZbQ72xgmK55QidkRpbEYN1x3wE0pvcTeSYqUL6rOp5roYi14RbtZZO6mKQYvDf1UUoD2YUcTjBJgP4qn17zWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpovHph6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpovHph6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B11C19423;
	Tue, 31 Mar 2026 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976479;
	bh=zD5OrftLh5YM8enw2ROeNXU96hd6NrJvm5VaNTGyMe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpovHph6Jf03G6+b1kg2jleEL8+0xOd/pxcXTh1/8SmtSbhfZf3DGdQ+j3vNxwX26
	 XRvTpYXv8/A25ga9NCcAhHCqBWxr1J3Wq3Q3sQQyeLFpd/G5X6A7KP/Ve3DH1U7yf3
	 5OUxTesWnGf5Ha2MBxPTKMAJzjetDx1udVMnMJmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/309] net: fix fanout UAF in packet_release() via NETDEV_UP race
Date: Tue, 31 Mar 2026 18:20:12 +0200
Message-ID: <20260331161757.498569713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 173e6edda08f8..5c08e0da0dff4 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3135,6 +3135,7 @@ static int packet_release(struct socket *sock)
 
 	spin_lock(&po->bind_lock);
 	unregister_prot_hook(sk, false);
+	WRITE_ONCE(po->num, 0);
 	packet_cached_dev_reset(po);
 
 	if (po->prot_hook.dev) {
-- 
2.51.0



