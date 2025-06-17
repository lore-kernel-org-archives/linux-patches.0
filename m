Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03612FA627;
	Tue, 17 Jun 2025 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178721; cv=none; b=c4EDOtNHuZeDWe5O/tRrc0FfnsYrq0egveSAB9bbWPCTj3inljwRLbjBgC0D7ApZly26zjRpxSN7a85K6lU5WKCf/xKTuar1d5/trTSUVh6LYH7xrXkudyS41dj/LmJAVh71gC5D5YyuXKXmZdiQhlOYvYpVCOiSf/YI3o2k0Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178721; c=relaxed/simple;
	bh=CyJIVFiPLIy4Y7xRP1suTtIccAzPSUjU/tuIZl3tMDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl7rSkGzNLrcFZZ3Gdp8UbjQI0cya6oMEEuzW8TfKTzmSVoYWIjVf7+s+aLQi8Gzg09xHIDaEHOn9my9dkvR6Y9bcj+yYJT6biT+NZNkWY9k3j+R8fzHyKs/v4I5CZU3L6rohd3qqW3ouaGMc0A/rtHRVcYVT7nvR09UJer3F84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T4Wy0ts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T4Wy0ts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AFCC4CEE7;
	Tue, 17 Jun 2025 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178721;
	bh=CyJIVFiPLIy4Y7xRP1suTtIccAzPSUjU/tuIZl3tMDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T4Wy0tsQXPYdQMDkX/Eo3U42JflvLTgdCVGbIiC0FQm2S7uSBcYI9xMDjIIJVjJH
	 QqWS7/vmNSzU2cNGbu3uUl+OGZsYp2Ule4Do8RMn/Y2GWulXjYHAicTHxjfFzP8z00
	 OjPM5JG6bvaolfz7gEoPnVrUSJ4G3r/vMVgmcx3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Zsoldos <tamas.zsoldos@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 533/780] coresight: etm4x: Fix timestamp bit field handling
Date: Tue, 17 Jun 2025 17:24:01 +0200
Message-ID: <20250617152513.217361689@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit ee811bc733be5c57a2bfecdf2f6f5d4db466200a ]

Timestamps in the trace data appear as all zeros on recent kernels,
although the feature works correctly on old kernels (e.g., v6.12).

Since commit c382ee674c8b ("arm64/sysreg/tools: Move TRFCR definitions
to sysreg"), the TRFCR_ELx_TS_{VIRTUAL|GUEST_PHYSICAL|PHYSICAL} macros
were updated to remove the bit shift. As a result, the driver no longer
shifts bits when operates the timestamp field.

Fix this by using the FIELD_PREP() and FIELD_GET() helpers.

Reported-by: Tamas Zsoldos <tamas.zsoldos@arm.com>
Fixes: c382ee674c8b ("arm64/sysreg/tools: Move TRFCR definitions to sysreg")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250519174945.2245271-2-leo.yan@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c  | 2 +-
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 2b8f104638402..b42b03dba516d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1176,7 +1176,7 @@ static void cpu_detect_trace_filtering(struct etmv4_drvdata *drvdata)
 	 * tracing at the kernel EL and EL0, forcing to use the
 	 * virtual time as the timestamp.
 	 */
-	trfcr = (TRFCR_EL1_TS_VIRTUAL |
+	trfcr = (FIELD_PREP(TRFCR_EL1_TS_MASK, TRFCR_EL1_TS_VIRTUAL) |
 		 TRFCR_EL1_ExTRE |
 		 TRFCR_EL1_E0TRE);
 
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
index fdd0956fecb36..c3ca904de584d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -2320,11 +2320,11 @@ static ssize_t ts_source_show(struct device *dev,
 		goto out;
 	}
 
-	switch (drvdata->trfcr & TRFCR_EL1_TS_MASK) {
+	val = FIELD_GET(TRFCR_EL1_TS_MASK, drvdata->trfcr);
+	switch (val) {
 	case TRFCR_EL1_TS_VIRTUAL:
 	case TRFCR_EL1_TS_GUEST_PHYSICAL:
 	case TRFCR_EL1_TS_PHYSICAL:
-		val = FIELD_GET(TRFCR_EL1_TS_MASK, drvdata->trfcr);
 		break;
 	default:
 		val = -1;
-- 
2.39.5



