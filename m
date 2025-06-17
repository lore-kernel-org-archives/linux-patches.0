Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1EB2FA624;
	Tue, 17 Jun 2025 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178721; cv=none; b=rmrcmN5Re64zoRSJxq/GMqWGahHdidSBd3nLQQ84OZwhEnHZmoLhd9jlMGrccBXUiiz83sa6Nctm3wfmAFvPL9toVFekCdsA/B1IeALmqLKgOD2vQJPg9BK6y6pODIpdXee8U7pjZuL38cBCu5zuqF4UCpdSUvjdOoynikabYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178721; c=relaxed/simple;
	bh=C7Uy/BuWG16g9r8xG1QybcdYSttB3UJ5FjnRkQWh1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUL1z9332ch/vYrYVqxst0bltnSNyRo5cPw10oU7dwJiC1HrAGBTqJgYdtjPl8xi7HfCzSuRepOmvX7BoeZVK1JQ9CMCgrtk3im0zDoSreGvAUQXTcydI2Tn+bJ58YspnwL/mgzIrrO4shn6QZFUIUCjY79bIUC91lUxPmCx1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OY3ymHdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OY3ymHdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1804C4CEE3;
	Tue, 17 Jun 2025 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178718;
	bh=C7Uy/BuWG16g9r8xG1QybcdYSttB3UJ5FjnRkQWh1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OY3ymHdlsl2mPh7jt18JjyA5TV+QhOt3PzXmtdeWnuG/cympj+94ns+Z/aqTbA0ww
	 Y+efa/6grmAIS32npterNIaWDBbxYhL7lmTWdhVBxJ2Zn9vEDlx11xHFLpQt1cMNJ4
	 yRCZxbISgDwuH3BOma8copcBwJxkZQF/k83lPvt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfang Zhang <quic_yuanfang@quicinc.com>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 532/780] coresight: tmc: fix failure to disable/enable ETF after reading
Date: Tue, 17 Jun 2025 17:24:00 +0200
Message-ID: <20250617152513.176502555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mao Jinlong <quic_jinlmao@quicinc.com>

[ Upstream commit d23bc38e8aa4efbd617bf660bb1a25fee9f6c177 ]

ETF may fail to re-enable after reading, and driver->reading will
not be set to false, this will cause failure to enable/disable to ETF.
This change set driver->reading to false even if re-enabling fail.

Fixes: 669c4614236a ("coresight: tmc: Don't enable TMC when it's not ready.")
Co-developed-by: Yuanfang Zhang <quic_yuanfang@quicinc.com>
Signed-off-by: Yuanfang Zhang <quic_yuanfang@quicinc.com>
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
[ Added a comment to explain why we ignore the error ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250507063716.1945213-1-quic_jinlmao@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index d858740001c27..a922e3b709638 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -747,7 +747,6 @@ int tmc_read_unprepare_etb(struct tmc_drvdata *drvdata)
 	char *buf = NULL;
 	enum tmc_mode mode;
 	unsigned long flags;
-	int rc = 0;
 
 	/* config types are set a boot time and never change */
 	if (WARN_ON_ONCE(drvdata->config_type != TMC_CONFIG_TYPE_ETB &&
@@ -773,11 +772,11 @@ int tmc_read_unprepare_etb(struct tmc_drvdata *drvdata)
 		 * can't be NULL.
 		 */
 		memset(drvdata->buf, 0, drvdata->size);
-		rc = __tmc_etb_enable_hw(drvdata);
-		if (rc) {
-			raw_spin_unlock_irqrestore(&drvdata->spinlock, flags);
-			return rc;
-		}
+		/*
+		 * Ignore failures to enable the TMC to make sure, we don't
+		 * leave the TMC in a "reading" state.
+		 */
+		__tmc_etb_enable_hw(drvdata);
 	} else {
 		/*
 		 * The ETB/ETF is not tracing and the buffer was just read.
-- 
2.39.5



