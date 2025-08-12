Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BDF2FFDC4;
	Tue, 12 Aug 2025 18:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024128; cv=none; b=BDvfOVaWZYD/BJgwd/LRStMZEbL1yLJCq+yqfjgeh23eK3FM17zWCa/fveH4JN/7UQMRjXHFJoTJdC9wkAG7DzA2B6fMR5M2FnQrqgSS3zfI53ealE0oVH7XwiT3jhPyKPCQoOiRFMfHHCsYkxUhhqjjl+gQ3bIByGfuO4uTriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024128; c=relaxed/simple;
	bh=cKgxaqmX4GQJuJoXMdxTVA7bvSvWWm7EjnV2l1heMHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJJetzSf3p6UC2SNVJh06et5AKy/PXeNQqFVskBpV5Wn407UaX6/upi1D7BuEoRsqa5ZWpVQqDvZZxwHOamB5KQ1fyGEQlwWk4sf4QkKyfYOiZNeju197dFBEG2HiAWXUKkGsAE+jA4VuvHn+S3tKQrJ1m8wt4VmUImIvs7uNHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eB85Tlxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eB85Tlxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16460C4CEF0;
	Tue, 12 Aug 2025 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024128;
	bh=cKgxaqmX4GQJuJoXMdxTVA7bvSvWWm7EjnV2l1heMHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eB85Tlxk5qD81vaFLecxE6Es5Ca5lbyc86U+OuZsslr9OlVadgNNtKxlASws13Mxe
	 MXkUKrPxRUbEKAGospZXAW+Ddv3KVrbnEF79BiK1OASve8s+QylOEe+U+DpjGU6Dhh
	 BzrzI/V/rZUpX0sc2rTG+RN7RcRMHlrsg/oQBUbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 283/627] igb: xsk: solve negative overflow of nb_pkts in zerocopy mode
Date: Tue, 12 Aug 2025 19:29:38 +0200
Message-ID: <20250812173430.082383238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 3b7c13dfdcc26a78756cc17a23cdf4310c5a24a9 ]

There is no break time in the while() loop, so every time at the end of
igb_xmit_zc(), negative overflow of nb_pkts will occur, which renders
the return value always false. But theoretically, the result should be
set after calling xsk_tx_peek_release_desc_batch(). We can take
i40e_xmit_zc() as a good example.

Returning false means we're not done with transmission and we need one
more poll, which is exactly what igb_xmit_zc() always did before this
patch. After this patch, the return value depends on the nb_pkts value.
Two cases might happen then:
1. if (nb_pkts < budget), it means we process all the possible data, so
   return true and no more necessary poll will be triggered because of
   this.
2. if (nb_pkts == budget), it means we might have more data, so return
   false to let another poll run again.

Fixes: f8e284a02afc ("igb: Add AF_XDP zero-copy Tx support")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20250723142327.85187-3-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_xsk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_xsk.c b/drivers/net/ethernet/intel/igb/igb_xsk.c
index 5cf67ba29269..30ce5fbb5b77 100644
--- a/drivers/net/ethernet/intel/igb/igb_xsk.c
+++ b/drivers/net/ethernet/intel/igb/igb_xsk.c
@@ -482,7 +482,7 @@ bool igb_xmit_zc(struct igb_ring *tx_ring, struct xsk_buff_pool *xsk_pool)
 	if (!nb_pkts)
 		return true;
 
-	while (nb_pkts-- > 0) {
+	for (; i < nb_pkts; i++) {
 		dma = xsk_buff_raw_get_dma(xsk_pool, descs[i].addr);
 		xsk_buff_raw_dma_sync_for_device(xsk_pool, dma, descs[i].len);
 
@@ -512,7 +512,6 @@ bool igb_xmit_zc(struct igb_ring *tx_ring, struct xsk_buff_pool *xsk_pool)
 
 		total_bytes += descs[i].len;
 
-		i++;
 		tx_ring->next_to_use++;
 		tx_buffer_info->next_to_watch = tx_desc;
 		if (tx_ring->next_to_use == tx_ring->count)
-- 
2.39.5



