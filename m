Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621221;
	b=HzKwE442c704W/y+Wb/Mn3/HCPL0Yn7zfu76YETv9Fw8y6MD04Kn6XpBQryL91cn4a5P
	 jbHV7yfXkoXvZmDlHgofNST0Jf+B3zn/ymEs7nowdB6MVDWOP7GpbVn8ZHea8Lntsun3o
	 BHleJHKm37f5wx1f+IxfHjuYkJdRkt1DqyRPRb3IJ8iCGz8eJar18+zrKJhSy6CRwOgay
	 7ZC257r/nzzTLQjJvGE84WpSbJ8A0ps0lfRXF8OQAsFtZG6Z0L807Lf1mfBOZp+5bhOW/
	 DQL8Yjxd7HPwhbQjTwBLzguKKGw9mFWRwR909jZ6rzVb0Siy1OI15zJPNgSETG6Tftw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PULGO/mx0qhUxDnpsugwAzRrshF9hoOs+fMXXRQO+mk=;
	b=1mFJ+JyMuVnMPcqGB4MB3Fz05tWenXCXzDVQTHtd9sOkobjIF8c5011EtBeCtyk1LdGU
	 SabXzIlRQFw6gn5HqbPPyWT1zkkV1qZ0En26JFMXOT7e1VuYjyzC2bGAryiZqHfjgy9x0
	 zl21KL6FCx/GwO59UImUTu4Lz/VbmNT1ysQbvljKQrRDaHFIZEGbwpi2RZxWuDEoDO6vV
	 p4hxEb6Sh74qztHzzzSGgv73Df0ksVvNOuvjds4o6AWNOk+w3FDq0tjFRS6fqZTHTVJsd
	 KrZAokzX9kxxeNvofhGCnX9vfvLQoEmH4zaqPCFe49CLViWIQ+N9XoQI81tX4rlh4nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DFrcvpE/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BE4607DE85;
	Wed, 25 Nov 2026 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DFrcvpE/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C581F000EB;
	Wed, 25 Nov 2026 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621221;
	bh=PULGO/mx0qhUxDnpsugwAzRrshF9hoOs+fMXXRQO+mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFrcvpE/HquUFmZADPd5NvmINkm2pcU++X4I99b5Eh4yFaIHep9b9BpGXY7Hs8mEP
	 MzEt4E/MY/Uyz3WxG6mu2J6oePWWNZvmgjX7Hko/ZRJszYwYOr2rbwDnZxCxy6h55i
	 RYP91FLWAGU0i29105cF3YQg3744f8L4n8fatd84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+6dcbccedc9ec6452@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paul Moses <p@1g4.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/990] vdpa: fix double free of the reply skb in vdpa_nl_cmd_dev_config_get_doit()
Date: Wed, 25 Nov 2026 15:25:24 +0100
Message-ID: <20261125143825.770872753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index caf0ee5d6856c..3d25238873afb 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -1314,15 +1314,16 @@ static int vdpa_nl_cmd_dev_config_get_doit(struct sk_buff *skb, struct genl_info
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



