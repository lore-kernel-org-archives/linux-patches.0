Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF139CD06;
	Thu, 17 Sep 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659321; cv=none; b=X1rq9XPDh4D7GtjgRBVWl1EgyoXjhDU3bC2RY0u9GLbM9MLTzDsAPoczyOQuWgrU4D91TtuIUnEbWenSoXHiD8FilPDZ546hul59t1IlX8d75NyGxTkqX6t1c5vXEea6Gv++bNEI1AgBoyZOCKuzfqI/jK0lVnPITtvDBd+D0Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659321; c=relaxed/simple;
	bh=YlwJkAtiP5svyXKRXD3L4WAX645xUbDFRe0umgKwHRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNsKMUjqTuwQeyjYKzDiUFpHL+ilsYN54YEwC48BoLLcuIq/Vns4i6XeB2Vi8/qW8Ztfbcd2S7JeKBS4yEUQmYgvvRJ/WSooPm0up2M+Sqbjx4lLFdCOVaXpbNvCifprZYc2mCAfvZSd1KdPx0Ax0ocFiLQFtjC31eO3Y/59RnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yonG2wVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yonG2wVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7091F000FF;
	Thu, 17 Sep 2026 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659318;
	bh=nASVvjUO2Ot8tcr5ZuYdjsl96JTI4Z824ZkYya6WBvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yonG2wVydcX3O/yjfhaIgdJXZ9JV4xR7GxjPnMIlt2vabXyuY7GUtidvNzZNigTH8
	 wpj9zBK5QYpmttiRT4luOmlPuiL/Ah2FQf59EQ4ixDXyDdEACHTaHcBUyK4HlTpEKE
	 EXjExo/zm3CAt0wMExmibC6HBSFnM6H70VDO4XcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 217/733] net: airoha: enable RX_DONE interrupt for RX queue 31
Date: Thu, 17 Sep 2026 16:08:45 +0100
Message-ID: <20260917151356.608924765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7db28abbea0f7dc1ec4fdfdc149db5fbd9e4c994 ]

RX queue 31 has always been allocated and filled by airoha_qdma_init_rx()
since RX_DONE_INT_MASK spans queues 0-31, but none of the RX_IRQ*
_BANK_PIN_MASK values covered BIT(31). As a consequence the RX_DONE
interrupt for queue 31 was never enabled, airoha_qdma_rx_process() never
ran on that queue and its buffers were never reaped.

Route RX queue 31's RX_DONE interrupt to IRQ bank 1 so that the queue
is drained and its buffers returned to the page pool.

Fixes: f252493e1835 ("net: airoha: Enable multiple IRQ lines support in airoha_eth driver.")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260830-airoha-rxdone-rxq31-v1-1-830a91503f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index b894828b13752..70f16189b2582 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -538,7 +538,7 @@ struct airoha_wdma_info {
 
 /* RX queue to IRQ mapping: BIT(q) in IRQ(n) */
 #define RX_IRQ0_BANK_PIN_MASK			0x839f
-#define RX_IRQ1_BANK_PIN_MASK			0x7fe00000
+#define RX_IRQ1_BANK_PIN_MASK			0xffe00000
 #define RX_IRQ2_BANK_PIN_MASK			0x20
 #define RX_IRQ3_BANK_PIN_MASK			0x40
 #define RX_IRQ_BANK_PIN_MASK(_n)		\
-- 
2.53.0



