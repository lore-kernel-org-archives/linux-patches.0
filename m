Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510D91922F6;
	Tue, 10 Sep 2024 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963896; cv=none; b=bmDcwbVRe07k4R0VxMEYbwmHDQVEX8Iujmx/0d0PJTqTKPVZW7WkcJnGmIhFeWILAQsHo6l/RHkbSxy5nlLa2PPHyv3IEPSPkh1u8RBDAX6PcXmyBkNsWJf5YUXxRUxE7CgA6NPpufLpsraILmX9JVvIvoE2Qkw4fSmmyOdTw0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963896; c=relaxed/simple;
	bh=3w7z3t1Cvk3CqkwsRax9ypu/RVaX7MjzkDzJouP3HX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBUq6lyHUFxBhpUbG7ZJKk8cQEFUquCrIbSFel2MyxrL1eysDFqlUrrdS0EV87pEsZVtFfmaSY9DSYOCOlWxdCt/Bn2A3C/6A4XjGAjnS2ThFWl2vWhyIO1EyUGD7IZfPLN7n3Wm1eglAYg+JRpSbMShVfPs4lSEouFocRi1iKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/UvmXGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/UvmXGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0B7C4CEC3;
	Tue, 10 Sep 2024 10:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963896;
	bh=3w7z3t1Cvk3CqkwsRax9ypu/RVaX7MjzkDzJouP3HX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/UvmXGLrv2QtaJB2ObDD+VY4DNY4LbMmeAhm0jinytS1JFf3+oTNJzVjK3G3A1XW
	 sWnrvIzesSpV25DerE2RTQGiL2H9rAZx7zQ+yCL5MCI/cb1CiRmhJQMBspkn3ENxCm
	 LfOegx4aRWk8anmL7/Pou6Tx29mvMV9xjlkah2tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 214/214] udp: fix receiving fraglist GSO packets
Date: Tue, 10 Sep 2024 11:33:56 +0200
Message-ID: <20240910092607.239593880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

commit b128ed5ab27330deeeaf51ea8bb69f1442a96f7f upstream.

When assembling fraglist GSO packets, udp4_gro_complete does not set
skb->csum_start, which makes the extra validation in __udp_gso_segment fail.

Fixes: 89add40066f9 ("net: drop bad gso csum_start and offset in virtio_net_hdr")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240819150621.59833-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -277,7 +277,8 @@ struct sk_buff *__udp_gso_segment(struct
 		return ERR_PTR(-EINVAL);
 
 	if (unlikely(skb_checksum_start(gso_skb) !=
-		     skb_transport_header(gso_skb)))
+		     skb_transport_header(gso_skb) &&
+		     !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)))
 		return ERR_PTR(-EINVAL);
 
 	if (skb_gso_ok(gso_skb, features | NETIF_F_GSO_ROBUST)) {


