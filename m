Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623034;
	b=oztrapEZWK1Nn821NnjHMQzKWjNCgA501A2zGEsqV7PFUfx1NFMYjOgF+NU2weiKBnWa
	 dxBu9+9vh+r3XJSf4Sb23POJQoaLwCJqSpY7DiDUzoGDvNGvX/VvZmMknxATjig2eiLdb
	 W1owPFPMW/TrzoF9CgR8VRNo/YGp3Hork7OHPEa6mkxc0Pif4JS0O5z9/07IEHzwAYOWD
	 Yb8sF+109P8wR327ycvNOthIP0YHaEXgwb1DjbrFsFNNmRsPqgRZZjUIMoTqsmsmbLRCs
	 PlHxGofbczHRghWKQnrXH12vcddYko7ENT7zfR0j+Q3AZQ0577e0UQGZEnrQhyg/TGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v2DNbMfKhbLV3gG6ALLDao8+E7FBMYdCsu3ZjlIPKiw=;
	b=oVYhpx5lhpzZKr4kewrDlP3cNiHwmWj1J1IvWMLpQb8VHCu3zwI8bTifXzYfRqPtpPEi
	 WcddDLQJsrepaveD3mdAq43aFRjOdJXHiWCvyGKcZaHhDvuDfdrazNv07GUGyldWO+lvT
	 3rITKsT6qz74PbKi1Atpr+cI2iHpliE0zsaT5lfwxZZtxq8jUrVxxhBkEZK2EIA9R1bbQ
	 yBHvIboI0d3EzqYzwa5YKBG2AadtZg1xEmowkT4faSgS3oSCFKnpKYWQYL1251nAKi9EC
	 op+jxPVun500c6thFJybd69MVwWklIvl+RAkRZO5O0ETtlIOUjeXQTCs6sjM8ZnOJOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V43uzaqM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27487606A31E;
	Wed, 25 Nov 2026 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V43uzaqM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7840A1F000C6;
	Wed, 25 Nov 2026 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623034;
	bh=v2DNbMfKhbLV3gG6ALLDao8+E7FBMYdCsu3ZjlIPKiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V43uzaqMGyoOAWHylxmqXMVRCROWdaNOrAatZQglUwnMM+fELAYt8WdtMn8VK3mvJ
	 4h/Km7i56iXsbT0xoMP/8i9uCw+3rZl3TbfqChgXFs2Ft0Spei3ngKy/1bTP48cYzF
	 xqW++it+6SJy3yL1mCwME54JiTtgj3fGl+nQBVsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 691/990] mctp: accept MSG_CMSG_COMPAT in recvmsg
Date: Wed, 25 Nov 2026 15:34:18 +0100
Message-ID: <20261125143838.273802699@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

commit 350e1d0d3b386fcc0cff2d37aa920fab4800bf72 upstream.

32-bit userspace running on a 64-bit kernel is unable to receive MCTP
messages on an AF_MCTP socket, even though sending succeeds. There is
nothing for MCTP to do with it beyond not rejecting it, as af_packet,
af_key and can/isotp already do, for example.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://patch.msgid.link/20261105160704.2546031-1-dave@stgolabs.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -291,7 +291,7 @@ static int mctp_recvmsg(struct socket *s
 	u8 type;
 	int rc;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK | MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
 	skb = skb_recv_datagram(sk, flags, &rc);


