Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F2331EAE;
	Sat, 12 Sep 2026 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231048; cv=none; b=pjGVJ0G44oLa+o5IlGWmnSYSr0L7fUYO1lQsTAd5NKwTCtfylVSd5Cf4X0gi5IEsbdQg62fVqm393E5dmxgSAFxfHTdLUq46XY+khQT3XSD32J8xDby0x0HhYONY2bFKDjQiuTwm/1znoURjIfUOfDjw48r/q1PA2hvNCJO7n5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231048; c=relaxed/simple;
	bh=88tXAfLh35P43KrL8k3eX+GN3Fj91XL5N6Q9VwW5j5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMlhA3lSjoe+ZDfJI8Tq3ffuFX2vzaTgUuOotjILuW2GqBf2AsYrCIA/PO295MF9LGsCDPXibvMnQbZJWYjOVrdS0vwdnaDykV0BZaqJDq+iBTOPtFThC+cDe9y+DKdkS3wQ4pfZ29FdXxsjKzDcmWdBBp0wyuxY0CgtdOiSP6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5stNif8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5stNif8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6F31F000FF;
	Sat, 12 Sep 2026 16:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231047;
	bh=tH5XgRLFntzW7ohEQjvAyYgRDLrDtRE+glNrPCNucR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5stNif8yqUsvBqjfnfpASlVndwbUWFgpXLcOhJmJ2XLIzEs5wli8FEtIJojgawxT
	 1b4FtXcOFbFjO1ra7Ls65kuToddykDbhnjBOcrnKPwoHf2jiBziyaGxGmpFYYK40By
	 D/EfNHMOcsZz7xMHXk+PEaA7yju1GgbpaKI5VAl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0917/1191] coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()
Date: Sat, 12 Sep 2026 09:00:45 +0200
Message-ID: <20260912065608.829760220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2c55cc45a11f..fa2fe4ff236da 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -82,7 +82,7 @@ struct etm4_init_arg {
 static inline bool etm4x_sspcicrn_present(struct etmv4_drvdata *drvdata, int n)
 {
 	return (n < drvdata->nr_ss_cmp) &&
-	       drvdata->nr_pe &&
+	       drvdata->nr_pe_cmp &&
 	       (drvdata->config.ss_status[n] & TRCSSCSRn_PC);
 }
 
-- 
2.53.0



