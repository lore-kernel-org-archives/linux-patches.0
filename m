Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43582871;
	Wed, 19 Jun 2024 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802287; cv=none; b=Ta8YL4kt0aTsBs4ih/J6dQokH/zDr3sSqzRdlEvaF5KQzISsaQBTnOwQC0zqru1C2lAlfTJb69fvwapmrDBG4aAUziBXtfPqd38bKIbbdAX3vfcroGMy/ogRcKXpptsoT0vAOCR6VWAcjZCM/lCaVDAptuL3NmSt2DagcrGsOcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802287; c=relaxed/simple;
	bh=U5X6RXFCQCsfE0dBYSOEvcaIGx7BGbIlj1FskMuDMG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sigLl4tpUr7Mf0pw+5Yvt+3EQHg6NN4MGzE40l1Muq3HvEka7dzCDjgu8Vp9Z2jvOBu7en18R4ZsRtnjhIDztlpYEfnIwdIEWACROuNPNDFJEbqv9j5GXwTGIHC5aRQQcMorJijKuF9cSrcpHfkl582tLUTBJoj/ksM/LnAimPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhLwqexn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhLwqexn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B825C2BBFC;
	Wed, 19 Jun 2024 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802287;
	bh=U5X6RXFCQCsfE0dBYSOEvcaIGx7BGbIlj1FskMuDMG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhLwqexnoOtC1Hu2m2RQgzJW13VOf7jJkj2OlsaB7wSp7KILVSDU/CoDDpaxwYZ3N
	 KemLYtoMq598bkCXZdJU6m+faK9GF5uyZJutOmVOnhwh/8EYKiGrjz0449RoRtBVLA
	 qr4d5ir1+hJSX3jXB4F328JjGjtJMv7oOpwG7aTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/267] liquidio: Adjust a NULL pointer handling path in lio_vf_rep_copy_packet
Date: Wed, 19 Jun 2024 14:54:56 +0200
Message-ID: <20240619125611.913599958@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit c44711b78608c98a3e6b49ce91678cd0917d5349 ]

In lio_vf_rep_copy_packet() pg_info->page is compared to a NULL value,
but then it is unconditionally passed to skb_add_rx_frag() which looks
strange and could lead to null pointer dereference.

lio_vf_rep_copy_packet() call trace looks like:
	octeon_droq_process_packets
	 octeon_droq_fast_process_packets
	  octeon_droq_dispatch_pkt
	   octeon_create_recv_info
	    ...search in the dispatch_list...
	     ->disp_fn(rdisp->rinfo, ...)
	      lio_vf_rep_pkt_recv(struct octeon_recv_info *recv_info, ...)
In this path there is no code which sets pg_info->page to NULL.
So this check looks unneeded and doesn't solve potential problem.
But I guess the author had reason to add a check and I have no such card
and can't do real test.
In addition, the code in the function liquidio_push_packet() in
liquidio/lio_core.c does exactly the same.

Based on this, I consider the most acceptable compromise solution to
adjust this issue by moving skb_add_rx_frag() into conditional scope.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f233f327913 ("liquidio: switchdev support for LiquidIO NIC")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index 600de587d7a98..e70b9ccca380e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -272,13 +272,12 @@ lio_vf_rep_copy_packet(struct octeon_device *oct,
 				pg_info->page_offset;
 			memcpy(skb->data, va, MIN_SKB_SIZE);
 			skb_put(skb, MIN_SKB_SIZE);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					pg_info->page,
+					pg_info->page_offset + MIN_SKB_SIZE,
+					len - MIN_SKB_SIZE,
+					LIO_RXBUFFER_SZ);
 		}
-
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-				pg_info->page,
-				pg_info->page_offset + MIN_SKB_SIZE,
-				len - MIN_SKB_SIZE,
-				LIO_RXBUFFER_SZ);
 	} else {
 		struct octeon_skb_page_info *pg_info =
 			((struct octeon_skb_page_info *)(skb->cb));
-- 
2.43.0



