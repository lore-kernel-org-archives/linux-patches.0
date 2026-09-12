Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F152D0C94;
	Sat, 12 Sep 2026 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210366; cv=none; b=MZ5ic93v5byY1BJ8LK7G5Q8hkh0Z0KMvKOFKPFXrwSpPdxzCp6ITAsOcbvP765AxGH77meRKXv3qfHSSpsZOjTx1rIGY57A8iaO+sw0dwnuDctcUtaSaJ63EO0Xm3Q/Q5LUsDtCCCvHtglzEDTKypfA3bFR3IjMYtYb8C/w0rBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210366; c=relaxed/simple;
	bh=GGFo/rLMoH7sj/Oxb/I2Iz3OTkvRMcFmXAk+T91exR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAQPEUmTdrx7kf0D01sjrTi0CoOQ5Nn8y1UJahl+fZZ20Yp6L/UGREFq5EQXPcDFaJrYVuhe8Z9ZRyT5ynUtIcbv18KeWNdLp8paatok6A9XNtQRnlDoCwTEiYzDHtUKVyFrR0v7tr2RBUYrgamDJYU5biIbblgry4PA5RkyRUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRkR4wwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRkR4wwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D7E1F000FF;
	Sat, 12 Sep 2026 10:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210365;
	bh=Ersmsw5YIqeBVHO952b5k6RY9gTVorZ8tA0hDEbyopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRkR4wwh92nRDxn1P+gRl+uwwayjs+y00tDoFVT6jS3nl1lWoan0i2gNX3UJddaAh
	 M6V3btVcfuiyPCgF7YAfbol7QztXFSCueqKrfbcVmBRGJDu+MfKYE1F4g43O7wQNf5
	 TQ/ceUgjx6s8rdIrZo80d2KSwMWXp1IbCDLPgChk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0968/1518] coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()
Date: Sat, 12 Sep 2026 08:52:17 +0200
Message-ID: <20260912065645.358249941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0e1cd4270b42a257c139165622091e1e8c7104a7 ]

According to Embedded Trace Macrocell Architecture Specification
ETMv4.0 to ETM4.6 [0], TRCSSPCICR<n> is present only if all of
the following are true:

  - TRCIDR4.NUMSSCC > n.
  - TRCIDR4.NUMPC > 0b0000.
  - TRCSSCSR<n>.PC == 0b1.

Comment for etm4x_sspcicrn_present() is align with the specification.
However, the check should use drvdata->nr_pe_cmp to check TRCIDR4.NUMPC
not nr_pe.

Link: https://developer.arm.com/documentation/ihi0064/latest/ [0]
Fixes: f6a18f354c58 ("coresight: etm4x: Handle access to TRCSSPCICRn")
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-2-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 2271f5ea81214..318846e4dda3a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -92,7 +92,7 @@ static int etm4_probe_cpu(unsigned int cpu);
 static bool etm4x_sspcicrn_present(struct etmv4_drvdata *drvdata, int n)
 {
 	return (n < drvdata->nr_ss_cmp) &&
-	       drvdata->nr_pe &&
+	       drvdata->nr_pe_cmp &&
 	       (drvdata->config.ss_status[n] & TRCSSCSRn_PC);
 }
 
-- 
2.53.0



