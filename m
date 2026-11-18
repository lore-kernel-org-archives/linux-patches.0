Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022428;
	b=yQaHF5k0gbJ6ALimn/k8iIGmNHI52qdm5yrvC/ZbFYcWyKftWkZSBVzbV4OROof16ykt
	 5bGkzHF5/UrCXAV1vzZTEP2riFr67jad+8TxVCgB481JME05f1qFZAhzuL/KAb2aGMsoD
	 brvTik+4mmfdK/1ixHdZ1zK/eA7vHdfhVnHs9+KaPQT5kkNwjtyG6n8iUIz+djZSPZP+s
	 ewjpILuQKQr67oWe8Z5w+bI7DQcYrU/YWZDyUTcav2GUQ2NpTmUg6Si0ql7CBB9kkWTJJ
	 WGmItG6+2Y5OsEy7z1yG6eUKOxPXFi+T0so47URZSJzWhdh3YVGePoSshPrcOt6gNNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMP+adGaFg+dJ628ERl/zv9dJxQCQDrA8QV2aPJruRQ=;
	b=VfKsQa+eIkXijclhHdcQbAX2fbxu5r9UUSoCbXL2LMdAtXeT1CegW9GgtP0JOD/ObNub
	 4RCVkHVkcHHPm2H5PX6SH/T4+8YzLXuH4NtSgMQBUzpBVOimFw11zl2wTm9iXhq8ka2Gk
	 RCiaM9NK5uqACfijhHyCPWkuO4lnWAdWyWffBXPi2ru1sBgWDmJIqzHzLr2etDST23mZa
	 beoyMuWTGIzpSfJ2zLocDpatRbq/ahW/ZNMVxBE8gMNhFwVyWD/qG47onsxZbA1rIGhxU
	 NDXu9gZ7P7VRQEmj3MAW7kmHbzr+FoiNaxgtRctyAlKemnE5HCLTj6NkPq7mqPW5q/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUKJgCxd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076ED606A31C;
	Wed, 18 Nov 2026 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUKJgCxd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5941F1F000C5;
	Wed, 18 Nov 2026 17:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022427;
	bh=aMP+adGaFg+dJ628ERl/zv9dJxQCQDrA8QV2aPJruRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUKJgCxdoZv1DcuqO2fRSYXLnwC9QnQMIEOtadB5FoWdBkAwBE15QWDXFSsNdOskl
	 A3aTZ052kjXGMUVPRO9Y+Uxwksy/KFBsQhhU7uibgP650X5D2niX8N35PI+nHzcVab
	 UYz4q3obI0wzfdpAlkRKZvbD6+vd8VwSHFWvQgcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2630/2651] tun: drop batched packets while the device is down
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150418.853371041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 8f44631ba02afe9fff2f0a0fb66560ab19df87fd ]

tun_sendmsg() handles TUN_MSG_PTR batches from vhost-net by calling
tun_xdp_one() instead of tun_get_user(). But this path does not check
IFF_UP, allowing packets from a guest to be injected into the host
receive path while the device is administratively down.

Check IFF_UP in tun_xdp_one() before running XDP or building an skb.
Drop the packet when the device is down, matching tun_get_user().

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261027101830.85327-1-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8503184826977..2ed348b953159 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2553,6 +2553,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		return -EINVAL;
 	}
 
+	if (unlikely(!(READ_ONCE(tun->dev->flags) & IFF_UP))) {
+		put_page(virt_to_head_page(xdp->data));
+		dev_core_stats_rx_dropped_inc(tun->dev);
+		return -EIO;
+	}
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
 		if (gso->gso_type) {
-- 
2.53.0



