Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624402;
	b=seeGG/umQnJ5Kgf2iwUykuq6nhbwY4QH0OyD5bo4AY6sCo9PkdnqsH3MRy0Y4xOHtNId
	 SjDxmRZxjxwrq+pCVhQ9bDrBn7E7al6XgqD9fwDjvv4+F9fu91r6bbKdyetOMgMwFyKIe
	 jKXSmbcqWXJ5iBzHFIMox1o1WxCkZkSqapNwFtNq4p0xmRhcHM2Brgar/wm6VGLs+dy6t
	 KOjs8GDrVSZWoINHWcxl9UuFIxGtMu0pdk2WivTM9+dYRqOa6ngLWWIE2SCQgclG83Bne
	 tnbtLtBBWrCjUCx1uGdetfdynnCQqsXIZQpWmo/unsP9wE+jngxBKfjHhoHALJZW9sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LQJf6Kxl05RDwAvLFcekqjZpacXAgW0/63UY4s/V8jM=;
	b=MzIPKg4RCWWaXGMafKYk6u0bNS9+u5Nv1f8UCPSURV8M4bac+ioUVE/lftKqPCgfJl5p
	 L+sgPDz34SxLBK2UUxb+4dHpMa4gEBZhBgGWf+flAX4jkBlY9nYasLk6/1pDNqJ4wcPLM
	 iondL6qcFCMlerQ9xxtEOVFMaMoC+zEFFwPapzn0wsdQ5pUAkQr9zvhjF30KjD4j6s331
	 vBt7AK/KR/xBhuIrDuPO/wwfMPfWemJD84aBioffUocKx2mgQ8KCIH/wlUfRW/dykTPNc
	 yJIBC4WCb7puaGBSciqETmJtETuesG2CGLoODopo1fCW5lqG92Kz0DEpOPNv3I2fL/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvGXrA8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8EF606A69B;
	Wed, 25 Nov 2026 16:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IvGXrA8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC31F000D8;
	Wed, 25 Nov 2026 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624402;
	bh=LQJf6Kxl05RDwAvLFcekqjZpacXAgW0/63UY4s/V8jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvGXrA8lUUXaT+mfPsr+nENTsWnwWGbU4SCdimsQXaON5spaJPhryExRH6w6LiGmF
	 juI+LUMH+vKwsQ4gU310MDwXsiiDQYC+cOG+2F+jwqxgSKzPlfjwLrLAGPobksobgU
	 rQZ7r5WrkxEhPBaSDGaGAI3rhzexjSd2mSEfZNrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6dcbccedc9ec6452@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paul Moses <p@1g4.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/816] vdpa: fix double free of the reply skb in vdpa_nl_cmd_dev_config_get_doit()
Date: Wed, 25 Nov 2026 15:28:04 +0100
Message-ID: <20261125143852.350357852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1f8824fe7f6eaaf2355404db08d3cd05a28aa576 ]

genlmsg_reply() consumes the reply skb on every outcome: netlink_unicast()
frees it whether it queues it, drops it, or bails out early.
vdpa_nl_cmd_dev_config_get_doit() lets its return value fall through to the
shared error label, which calls nlmsg_free(msg) again and double-frees the
sk_buff on any reply failure. The failure is reachable unprivileged:
VDPA_CMD_DEV_CONFIG_GET carries no GENL_ADMIN_PERM, so batching several
requests into one sendto() on a socket with a shrunken SO_RCVBUF fills the
receive queue, and netlink_attachskb() then takes its MSG_DONTWAIT path,
freeing the skb and returning -EAGAIN.

Set msg to NULL once genlmsg_reply() has consumed it so the shared exit
path frees the skb only on the early error gotos that still own it;
nlmsg_free(NULL) is a no-op.

  BUG: KASAN: slab-use-after-free in sk_skb_reason_drop (net/core/skbuff.c:1220)
  Read of size 4 at addr ffff88800d99d49c by task exploit/147
  Call Trace:
   sk_skb_reason_drop (net/core/skbuff.c:1220)
   vdpa_nl_cmd_dev_config_get_doit (drivers/vdpa/vdpa.c:1324)
   genl_family_rcv_msg_doit (net/netlink/genetlink.c:1114)
   genl_rcv_msg (net/netlink/genetlink.c:1194)
   netlink_rcv_skb (net/netlink/af_netlink.c:2556)
   genl_rcv (net/netlink/genetlink.c:1218)
   netlink_unicast (net/netlink/af_netlink.c:1345)
   netlink_sendmsg (net/netlink/af_netlink.c:1900)
   __sys_sendto (net/socket.c:2281)
   __x64_sys_sendto (net/socket.c:2284)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  The buggy address belongs to the object at ffff88800d99d3c0
   which belongs to the cache skbuff_head_cache of size 232
  The buggy address is located 220 bytes inside of
   freed 232-byte region [ffff88800d99d3c0, ffff88800d99d4a8)

Fixes: ad69dd0bf26b ("vdpa: Introduce query of device config layout")
Reported-by: co+6dcbccedc9ec6452@bugs.sh
Closes: https://lore.kernel.org/all/ILTHcT8oe1HP47sY25JVxssvKmkCTjYlX9Hs%40bugs.sh/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Paul Moses <p@1g4.org>
Message-ID: <20260912215401.126194-1-xmei5@asu.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 0fb00c8bde5e3..c37c1fc940582 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1311,15 +1311,16 @@ static int vdpa_nl_cmd_dev_config_get_doit(struct sk_buff *skb, struct genl_info
 	}
 	err = vdpa_dev_config_fill(vdev, msg, info->snd_portid, info->snd_seq,
 				   0, info->extack);
-	if (!err)
+	if (!err) {
 		err = genlmsg_reply(msg, info);
+		msg = NULL;
+	}
 
 mdev_err:
 	put_device(dev);
 dev_err:
 	up_read(&vdpa_dev_lock);
-	if (err)
-		nlmsg_free(msg);
+	nlmsg_free(msg);
 	return err;
 }
 
-- 
2.53.0



