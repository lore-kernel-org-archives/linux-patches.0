Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14419148316;
	Thu, 11 Apr 2024 10:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831598; cv=none; b=nCNE7SA3eapV+5oGsww98k4SPUUMrTZlejWeSldjoJ1+Wqss81de9+voeH34vyzpiEgd8a+ACbPYa5YYrQcrQ5z5DvF0Jz6TOZfAa478a/Fe7w+q9a3p84NS/LGHUj6XSD8WYhHTU+87fbwUCTLu67Q+fkE2peqPg4kghRqjXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831598; c=relaxed/simple;
	bh=D+R8elbo3TBH+31KxsxPwn27iw6zxBWEzDRlXG/9HHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Pd1dd07PmtQnUPow9Ihe/wrkW1qMQX6lC6vN3WvX+EZng51cgF2nQtb7oSsggwz1oy08BUqGfQTrRmdZnlecK2i2qVj34NASdEY+qC/mcaDb5DMLwoCW2YiwbFun7gMSGsek8oB1Vbd63xZDdBt2RjYMBxWDBDrkmHuhlPRYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8TCMyTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8TCMyTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8789DC433C7;
	Thu, 11 Apr 2024 10:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831597;
	bh=D+R8elbo3TBH+31KxsxPwn27iw6zxBWEzDRlXG/9HHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8TCMyTDofxAEglfR4o5NJvVirX4lpYMTu6VDKyxsLs1tGNt6rKHXt/OWpIjlfl0B
	 pdK2cnGgYyavEqKxdmZfzyskzHomoTTUWPMbbfXtNqfDPiXj4sC/PK+xBhFjJK475P
	 NRKjWZmMs0FEQAon0olO6a17Jd7eCCbn+NhNN19Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/294] crypto: qat - fix double free during reset
Date: Thu, 11 Apr 2024 11:53:06 +0200
Message-ID: <20240411095436.329651184@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

[ Upstream commit 01aed663e6c421aeafc9c330bda630976b50a764 ]

There is no need to free the reset_data structure if the recovery is
unsuccessful and the reset is synchronous. The function
adf_dev_aer_schedule_reset() handles the cleanup properly. Only
asynchronous resets require such structure to be freed inside the reset
worker.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 7d42e097607c ("crypto: qat - resolve race condition during AER recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index d2ae293d0df6a..d1a7809c51c0a 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -95,7 +95,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-		kfree(reset_data);
+		if (reset_data->mode == ADF_DEV_RESET_ASYNC)
+			kfree(reset_data);
 		WARN(1, "QAT: device restart failed. Device is unusable\n");
 		return;
 	}
-- 
2.43.0



