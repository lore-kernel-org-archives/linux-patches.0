Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF11BC9E3;
	Tue, 27 Aug 2024 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771409; cv=none; b=u6qeKxvtzua6r/CcamZZFX2IEHXWKvr1E0FAEN1j4FEySly+vXiEhhRZy8AEm6XxrqKiUh6uwU2B6xTXAJa7ZP2UdkrQqO4wWqsIyRMdvBAaf8JvnAo+2VWKLwX2NG8rDBpzrXtTi3vBofhA4+CX9bNipHnkUPivsv29B1UUoKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771409; c=relaxed/simple;
	bh=NT4QdPYqCz+WusQB/+ZQYA4ilQMtZE00pcIwkrLk3Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2wybHV/CrNMTaIsrBOK2hOMV/l1cp6xCOQGBgXsdwdni2jpt868GXD02dLAPMPsmuUeknE3Ro6Xqpia48Tv4cQAmCj82ZJ65z9ZnPLhOGSB6ebz2x27JqR6OVJU2CHDrdCEzn5bIcZIL+mcqUFVZHXb+9tTVUFXWmiXyFSBdOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kujlh2aJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kujlh2aJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681DBC4AF52;
	Tue, 27 Aug 2024 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771408;
	bh=NT4QdPYqCz+WusQB/+ZQYA4ilQMtZE00pcIwkrLk3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kujlh2aJEHj1+EEj4BsfGrEI7J2/9NTdsbaVY1sFGCXxcUW1074LN7onzq+MEntbj
	 s5q1tIfwfaSDHrTnRUp8zqbFfEVj7MbyPidn8e3LrmyosWbxjmDrVTr65aJcbY2zfG
	 h/C0FvXl6RWmQA5BwiVZDqdCMe40TT+VJojsy75U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 180/273] udp: fix receiving fraglist GSO packets
Date: Tue, 27 Aug 2024 16:38:24 +0200
Message-ID: <20240827143840.261409658@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit b128ed5ab27330deeeaf51ea8bb69f1442a96f7f ]

When assembling fraglist GSO packets, udp4_gro_complete does not set
skb->csum_start, which makes the extra validation in __udp_gso_segment fail.

Fixes: 89add40066f9 ("net: drop bad gso csum_start and offset in virtio_net_hdr")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240819150621.59833-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ee9af921556a7..5b54f4f32b1cd 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -279,7 +279,8 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 		return ERR_PTR(-EINVAL);
 
 	if (unlikely(skb_checksum_start(gso_skb) !=
-		     skb_transport_header(gso_skb)))
+		     skb_transport_header(gso_skb) &&
+		     !(skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)))
 		return ERR_PTR(-EINVAL);
 
 	if (skb_gso_ok(gso_skb, features | NETIF_F_GSO_ROBUST)) {
-- 
2.43.0



