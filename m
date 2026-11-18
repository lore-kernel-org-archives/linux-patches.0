Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054706;
	b=DAnUB6CDgvc+h167J/cnYHufpVt3pz7W4s0F355yKsCQejpPvyBEmraYpueKSfXw96SV
	 /F4/Yl6eRwwCi5LIK2tmqK84cSBg+jZ/IdEh70BK2KBarBRq1pUo0b8/p32QkfwTg/mxO
	 AXnbZ5BhcL2RD/gEmvhrctyxajFMDlIP0nO+70KipwR5gdpKnAVGu/ag0LEK0dcOuICGw
	 AERTSwjuh9Sjoo9NALS4AA3W6s6E22TjuKOzx0j5srtyKSUL6YCsJkY+DQRkae6A55zup
	 x4tawQRFg5ff7ZANk0J3ETuoKMk5/VrhCbp9/cFQ++9y/83rgrfjbaA6OKDIdM/499Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGexNJAeh55t+egackHPdK9SpNnNU6g376RmN7ys/nE=;
	b=RJxFLwutYRpyJhwvANoFwNsxhb0+579tjxjOEKkrOVPqMwG3j4x9+Kv+JqPAY6/5PEma
	 8pfaBTgD1uTJIn5Emy04FDmvGMWoiEMnvVdhPkY/tMf3WSwVAMytqe1JoTKATcbTWvs2r
	 F/ScME3rh4Kw5dzIo0u421ktG7a+QhDqO+BAuuEpuGgrUQ6uVHsQ1ug9dMr+rkF0YIJPI
	 E0gtpLlHVFuh2AFfXyvnDz5IHDF3n8zOoORoW6gjeAoBP6oh35OMbTStx0FStSUZzdRJS
	 jzW6lqUjzfZ+kCDzhZmz/2Wxe2/AMrLvDEHIj+900uVxXBqfVL6FcFUSZ4Jpvz++DQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cmN/u9JO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEABD606A325;
	Thu, 19 Nov 2026 02:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmN/u9JO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B1E1F000C4;
	Thu, 19 Nov 2026 02:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054706;
	bh=YGexNJAeh55t+egackHPdK9SpNnNU6g376RmN7ys/nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmN/u9JOjzN2lt9ZQsLRvNOe2J6VTe5NORoUhNhPYDqGI/NXNVUx+2SlEiO7nRMKe
	 eLFi5aLT8nRRUOwjehsUHAOghZQUISsGOlYJH++x7TV3vACDiB6k53ynl9Fzw1hYuk
	 1UKP1h+y9RGwhdNguVwjJRSUAag+MlM8oe0MoUCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1369/2214] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150106.198440311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11ed0787c83ee..16ed0d6c32048 100644
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



