Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DBA4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16901C433D6;
	Mon, 14 Nov 2022 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430379;
	bh=awSEsI8bDSCSimBzEQg43Dfk/2uO7s/S0eCrGQZpQM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/a2X1TYqrS2o6Zg7ebsgw84DxjM2t4zN6ee1G/y83etFBGQ7A/TflwR0udlRADZq
	 CREsKvMRXf0/58f+CR9QH3UIFe6WX2EoISgK3NZZaJb1d1eM4BGfpDs7CfHDlCUmU9
	 FKx/kIRt+qVLE0aTzXIQBI3OJHbgquMKeBPILUOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/131] soundwire: qcom: check for outanding writes before doing a read
Date: Mon, 14 Nov 2022 13:44:41 +0100
Message-Id: <20221114124449.253810050@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 49a467310dc4fae591a3547860ee04d8730780f4 ]

Reading will increase the fifo count, so check for outstanding cmd wrt.
write fifo depth to avoid overflow as read will also increase
write fifo cnt.

Fixes: a661308c34de ("soundwire: qcom: wait for fifo space to be available before read/write")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221026110210.6575-3-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index bbc8a9b1e87a..f88c5d451f09 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -351,6 +351,12 @@ static int qcom_swrm_cmd_fifo_rd_cmd(struct qcom_swrm_ctrl *swrm,
 
 	val = swrm_get_packed_reg_val(&swrm->rcmd_id, len, dev_addr, reg_addr);
 
+	/*
+	 * Check for outstanding cmd wrt. write fifo depth to avoid
+	 * overflow as read will also increase write fifo cnt.
+	 */
+	swrm_wait_for_wr_fifo_avail(swrm);
+
 	/* wait for FIFO RD to complete to avoid overflow */
 	usleep_range(100, 105);
 	swrm->reg_write(swrm, SWRM_CMD_FIFO_RD_CMD, val);
-- 
2.35.1



