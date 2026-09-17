Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C843F4EDCAA;
	Thu, 17 Sep 2026 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665559; cv=none; b=bMe6NU3iA6anfF16QFr26kUANuoH+o521YW57BGuCTTXHmAm97FdK7/RIfoRDjSOvywRm3whCD1Ckq5hvoz2zTywrtA9zjtaszZPDY+Jq48EyKhFbfiKFiv//qKN6HSQO4s35mOV5m1jBWYrn0i0KgLMzd3tSSufdOSKiQyV3cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665559; c=relaxed/simple;
	bh=ivkg5tZnIrq2c0h3g+rryzBLnGKWTcaYixIpXkpQGQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF+ryQArlHQVnLQpsE2H/RQuxJQ/4f7o+UVMcMrOs/hjea9FvvfRDl23+awv/Ba3WERQ5hGZF1vfjYj9CjtcJY/Jweh9eMs8rd5kSWDMqXViDHe5DQxdMgcqNsKKYAq4ohlFJx+wCWF1S6d0PWlU+BzEvY0coUWEvJ76u8ppYPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUNe8tfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUNe8tfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BB01F000FF;
	Thu, 17 Sep 2026 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665557;
	bh=K/hb7/PG33cRXidn72//24wiimNfFf3P5Sv+DzhYlbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUNe8tfkbw4WKhIMR8/nHBV6g/mFPeB+ML1QZGUL4URgdOJCPUewS2rgw7hO1UX5t
	 MK10V8zxOPhHGs/GyfIV0OvswFhxNPI8NxDfJiGBPIGeUtFanwzaWYgpjCF7Immi/d
	 e/usWIxeKPdQURUPyz86YZB1fkvi/hzV0ZeXkkl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0745/1250] net: airoha: enable RX_DONE interrupt for RX queue 31
Date: Thu, 17 Sep 2026 16:09:00 +0100
Message-ID: <20260917151612.077332254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 216273595115d..ee0899104c3ba 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -502,7 +502,7 @@ struct airoha_wdma_info {
 
 /* RX queue to IRQ mapping: BIT(q) in IRQ(n) */
 #define RX_IRQ0_BANK_PIN_MASK			0x839f
-#define RX_IRQ1_BANK_PIN_MASK			0x7fe00000
+#define RX_IRQ1_BANK_PIN_MASK			0xffe00000
 #define RX_IRQ2_BANK_PIN_MASK			0x20
 #define RX_IRQ3_BANK_PIN_MASK			0x40
 #define RX_IRQ_BANK_PIN_MASK(_n)		\
-- 
2.53.0



