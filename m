Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1367199394;
	Thu,  6 Jun 2024 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682998; cv=none; b=ZDGNUKpQR9InaZKQeuxyoJg4yTH9hnLOCWa0hes2fl8ThGtwtVXDqLmngTQcJlIVlD6fTpNZls5geABBixHXR5bPALOQPLqRSJKo098G1QsyNRqfFcEtqQQttA5U/pW0xJWSMz9Fcg0kDrjVrg2+k2IaSsfnz6NugrR3bhGHTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682998; c=relaxed/simple;
	bh=8qmeu6WslHJQAhzWdx4riY5b9cvq0cPvtzGQ+BiRPPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/NLbIh0xfPL8rqwa4uihUyBr74ATDBKz5NlXimWVelLDMgM6nx2sLqWurpGkzx9rTUdUMDyu+7BYWYWbY+iNTMffDB6ZhdW0l66NrFru1jNPWf+AEnMs9x9zXc7kBCs5byoQjE3i8avtX1EXLFaLxpFIu0VdZoNF33McrQLAxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1dcS3pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1dcS3pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932F6C2BD10;
	Thu,  6 Jun 2024 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682998;
	bh=8qmeu6WslHJQAhzWdx4riY5b9cvq0cPvtzGQ+BiRPPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1dcS3pphhCHMh9Hc0Ad1SNYJtfQ3+7n15pD/7CFL7tb3W1yF5VtzxKfRgikzH/7K
	 ZMA5KAtpsoEhuTLknknF+4hAskSU7DtdF7GT4iU5y4dQsEfndwNgyfLvUq6tTZud/I
	 IeJ9vk892wD9Sn083rqBCxaIQuSx5ngDNZUmjHDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Yang, Chenyuan" <cy54@illinois.edu>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Yang
Subject: [PATCH 6.9 200/374] media: cec: core: avoid recursive cec_claim_log_addrs
Date: Thu,  6 Jun 2024 16:02:59 +0200
Message-ID: <20240606131658.536394338@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 47c82aac10a6954d68f29f10d9758d016e8e5af1 ]

Keep track if cec_claim_log_addrs() is running, and return -EBUSY
if it is when calling CEC_ADAP_S_LOG_ADDRS.

This prevents a case where cec_claim_log_addrs() could be called
while it was still in progress.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yang, Chenyuan <cy54@illinois.edu>
Closes: https://lore.kernel.org/linux-media/PH7PR11MB57688E64ADE4FE82E658D86DA09EA@PH7PR11MB5768.namprd11.prod.outlook.com/
Fixes: ca684386e6e2 ("[media] cec: add HDMI CEC framework (api)")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/core/cec-adap.c | 6 +++++-
 drivers/media/cec/core/cec-api.c  | 2 +-
 include/media/cec.h               | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 6fc7de744ee9a..a493cbce24567 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1574,9 +1574,12 @@ static int cec_config_thread_func(void *arg)
  */
 static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
 {
-	if (WARN_ON(adap->is_configuring || adap->is_configured))
+	if (WARN_ON(adap->is_claiming_log_addrs ||
+		    adap->is_configuring || adap->is_configured))
 		return;
 
+	adap->is_claiming_log_addrs = true;
+
 	init_completion(&adap->config_completion);
 
 	/* Ready to kick off the thread */
@@ -1591,6 +1594,7 @@ static void cec_claim_log_addrs(struct cec_adapter *adap, bool block)
 		wait_for_completion(&adap->config_completion);
 		mutex_lock(&adap->lock);
 	}
+	adap->is_claiming_log_addrs = false;
 }
 
 /*
diff --git a/drivers/media/cec/core/cec-api.c b/drivers/media/cec/core/cec-api.c
index d64bb716f9c68..3ef9153443044 100644
--- a/drivers/media/cec/core/cec-api.c
+++ b/drivers/media/cec/core/cec-api.c
@@ -178,7 +178,7 @@ static long cec_adap_s_log_addrs(struct cec_adapter *adap, struct cec_fh *fh,
 			   CEC_LOG_ADDRS_FL_ALLOW_RC_PASSTHRU |
 			   CEC_LOG_ADDRS_FL_CDC_ONLY;
 	mutex_lock(&adap->lock);
-	if (!adap->is_configuring &&
+	if (!adap->is_claiming_log_addrs && !adap->is_configuring &&
 	    (!log_addrs.num_log_addrs || !adap->is_configured) &&
 	    !cec_is_busy(adap, fh)) {
 		err = __cec_s_log_addrs(adap, &log_addrs, block);
diff --git a/include/media/cec.h b/include/media/cec.h
index 10c9cf6058b7e..cc3fcd0496c36 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -258,6 +258,7 @@ struct cec_adapter {
 	u16 phys_addr;
 	bool needs_hpd;
 	bool is_enabled;
+	bool is_claiming_log_addrs;
 	bool is_configuring;
 	bool must_reconfigure;
 	bool is_configured;
-- 
2.43.0



