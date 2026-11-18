Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060416;
	b=mtIdVE3IdMt53D6Bglq+URadaSeiVXRBb+BAi3Aktcu4sYJPm9QO/3Hwz5Mbri429ES9
	 qiG9kikuRtYy3LQ7kH7r0LEPil6fV9a9Iv8PR++vzU8M0QKQZ6lF2rvl0IX/gw2TVdalf
	 kn5JgdBpLdws8ZBIjP/SjF4qntUj524GhnqtFZFJ0o0MrJ1qUfi/JaxIh0GGAkenP9s75
	 sNfq7DaAKtIYVngih8rBURC2KKyIy8MRY6Rjl7xeQFy5RFOt5xPZeGFIbbN7xsnKFgiGU
	 sGhuVABvrS7dgm4NVvas1u/hDOUUcsZSr3N/vU+d+KdY4cXqvgfZvQdIVqaVGiV5o2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FJbX9YpTqmdhWIkJanijFu80yAVpKzeDwrvRHF8+1fs=;
	b=G3AcFZrjrYrG0peW/Nn3BOfWwOejfXa/ES8KEDz4MeF7blFuE5zgD4NSbV+npg0Plb3l
	 vN6B+99nYzzzrbAK7QaNJ0/YNxlgJEsHnad8XoBM9f7WBcUjd4Vdkz5bHV6CDElz6uB69
	 JJmW+vosf8xCwb3rJSZl55sh+DNiZ8uD/HLicfYCF6xPd3uk/mjuF4HnxQzZH6gut69FF
	 Fk9PKdUD1r4/WcK2H1ob5k475q1wcfbxQnvZWoS14JcRiLQ/JAokaLfuLdTHW11FaRaH/
	 0P3imvkzj3sC/HbR/M/HCyQlt/+QH6nVP3TWnTxJ4WBDajaeRDwfpD3a2LSJQGItjmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkDK+V2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D35606A326;
	Thu, 19 Nov 2026 03:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkDK+V2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2891F000C4;
	Thu, 19 Nov 2026 03:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060415;
	bh=FJbX9YpTqmdhWIkJanijFu80yAVpKzeDwrvRHF8+1fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkDK+V2Nyn6Hx6pCJybJHF4Tot3AwcGX1D245PgwKEQBmvPMJv8MU9jnd332TbVmm
	 yzDfZhKu4j2ERLlqKBG4qfWZFWspPjf7JXA4KAdLHKthZsdrG+Ah/xbh51FiwHYkXo
	 AfFvARw0Jts951UiA7lqGh2yZen3PJ8PFmqVfK/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1154/1848] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150008.048683504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit db57f6517bf65523968ae29cd34a790bfa7d32af ]

cvm_oct_xmit() means to schedule the cleanup tasklet once every 1024
packets, as its comment says, to cover the pathological case of heavy
traffic on one port delaying the cleanup of another port blocked
waiting for it.

The test is inverted: total_to_clean & 0x3ff is true for 1023 of every
1024 values, and false only on the multiples of 1024. So the tasklet is
scheduled on nearly every packet, and skipped on exactly the packet the
comment wants. That costs one TASKLET softirq per transmitted packet,
each walking every port and doing an FAU fetch-and-add per non-empty
queue, and it buys nothing for this port, which already frees its
completed skbs inline from the skb_to_free value it reads out of the
FAU.

Test the mask against zero. On a CN50XX board (2 cores at 300MHz)
carrying ~6.9k transmitted packets/s, TASKLET softirqs drop from 7133/s
to 597/s with no throughput change; the freeing work is conserved, so
this removes softirq entries, not work.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260820113239.8169-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 26876cd6a9b42..8c85163f1d641 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -485,7 +485,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			cvmx_fau_fetch_and_add32(FAU_TOTAL_TX_TO_CLEAN, 1);
 	}
 
-	if (total_to_clean & 0x3ff) {
+	if ((total_to_clean & 0x3ff) == 0) {
 		/*
 		 * Schedule the cleanup tasklet every 1024 packets for
 		 * the pathological case of high traffic on one port
-- 
2.53.0



