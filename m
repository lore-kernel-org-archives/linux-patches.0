Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622952;
	b=ugGpgtfo02rOt5iBlx6OX7iQ3X/QDZAfVkYsLISwkh6vmRkPCJ2leR5mQQXbJDoeajzg
	 4lThAL2Pe2L+YSt0j83H2Qpz+vg6tqKrtnunHjk9xzYnwgcCsgpvC7Ta0uruOLFbXVxaP
	 RD/BbU+alk86gFv0k1JjUW0JRNygO55bu9Y1THITg1TbZdzPtpMBKh/QSbkfbO6SukPJZ
	 qr/zBDrSW8JzJvUDlFOG4ruEQjn2aQvGMo25mSk2ZOOg/hQqF8CNnv+2f5x0DRgeWy8Z+
	 90W8V4I7aZNlRCSxKvoS3b+CC7e+pyXGMVWgcpHdkrvr1zOZRnO+cKDPO0VYQ1a+x0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8UisHrJbuRQMDB8mGfCW5BbcBBZAJckzp/VJbijTuTk=;
	b=qIU8Hvb8vF2vTF6RDYfw1r1Rnffl1IoTUXcgyTDeWT+iAJFWycmYtjHQB6DKOIMWQUFT
	 pL+sGLIZx32RBVFeBzWe9qjT1KzOkNciwubU30Ma/WTRYGzbERRmJ0JWsPAK2RN163m2z
	 Meo20UV0pdqCYgqi7cbfIvfN7MjoIqI0CbcZ4rEVIzmAFSE0fKLYSUlJazqB90iSyujmS
	 8NVL21dGS34bVPZrHuvbju97Duw5g/5uAtmTThLMnXb9TcaK1AhTNZhOjhjaq4u3SzzKE
	 JAOLKYZZinwuCPrj1NHfmZfwgofzEFKKUiLkq67aEQ+k1v/Zy+W+E36VNBqaq9G8iyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDOpg3v1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E36B606A31E;
	Wed, 25 Nov 2026 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JDOpg3v1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310B71F000C6;
	Wed, 25 Nov 2026 16:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622951;
	bh=8UisHrJbuRQMDB8mGfCW5BbcBBZAJckzp/VJbijTuTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JDOpg3v1vkhlKfwWeTVof6G29FsxQdAie1lMhg1A82h3c/H2NhxpUzYuPSP2L1TQf
	 1Okf9TDIqrwSQQI29rv0pYqPMaEgo6howjjmejNWrVq/+tIcCFYEZNfCE3qowA2uGo
	 t0jap/MSYGMifzPhA6npuanipZuct5JUVtU+cX+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Rongzheng Wang <testwrzwrz@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 703/990] xsk: defer software checksum until the skb is complete
Date: Wed, 25 Nov 2026 15:34:30 +0100
Message-ID: <20261125143838.549944234@linuxfoundation.org>
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

From: Rongzheng Wang <testwrzwrz@gmail.com>

commit f2eddafbfcc004098425fee7c5664adbe29152d7 upstream.

When XDP_UMEM_TX_SW_CSUM is used with multi-buffer TX, xsk_skb_metadata()
calls skb_checksum_help() while only the first descriptor has been added to
the skb. The checksum therefore covers just the first fragment, and
skb_checksum_help() sets ip_summed to CHECKSUM_NONE, so the remaining
fragments are never included in the checksum.

Move the software checksum calculation to the point where the last
descriptor has been added to the skb.

On a checksum failure the packet is now dropped instead of being returned
to the application for a retry. This path is not reachable with the
existing metadata validation, but the behavior change is intentional.

Fixes: 11614723af26 ("xsk: Add option to calculate TX checksum in SW")
Cc: stable@vger.kernel.org
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Signed-off-by: Rongzheng Wang <testwrzwrz@gmail.com>
Link: https://patch.msgid.link/20261104034809.24545-2-testwrzwrz@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -902,14 +902,6 @@ static int xsk_skb_metadata(struct sk_bu
 		skb->csum_start = hr + csum_start;
 		skb->csum_offset = csum_offset;
 		skb->ip_summed = CHECKSUM_PARTIAL;
-
-		if (unlikely(pool->tx_sw_csum)) {
-			int err;
-
-			err = skb_checksum_help(skb);
-			if (err)
-				return err;
-		}
 	}
 
 	if (flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
@@ -921,6 +913,15 @@ static int xsk_skb_metadata(struct sk_bu
 	return 0;
 }
 
+static int xsk_skb_sw_csum(struct sk_buff *skb, struct xsk_buff_pool *pool)
+{
+	if (unlikely(pool->tx_sw_csum &&
+		     skb->ip_summed == CHECKSUM_PARTIAL))
+		return skb_checksum_help(skb);
+
+	return 0;
+}
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 					      struct xdp_desc *desc)
 {
@@ -1174,6 +1175,12 @@ static int __xsk_generic_xmit(struct soc
 			continue;
 		}
 
+		err = xsk_skb_sw_csum(skb, xs->pool);
+		if (unlikely(err)) {
+			xsk_drop_skb(skb);
+			goto out;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */


