Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E29E2E091E;
	Tue,  8 Jul 2025 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993858; cv=none; b=j1pb2mkzG3mjwMedzxQ1xjc8rDT5SP0JK8xBvZ+1qhj4RPNhN9iGd8AnSnWOOpnmL3zhPPL7JHuc+RaBRhaFhplUc4Opn/lCxaox5bp2bk6OIhlgBtqdkkUrshOTwIfHT976qAE9Jn0CEeV+dS7iHRMEXXPfouRsLtqIWLd1UaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993858; c=relaxed/simple;
	bh=8FspT2VIhYhdVf3jdvJNBhHmVoOCRo2+MEhucrpFD7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKSmTxmJJST5AblH6hdBx/vjTHBn0oufBxPLyGace+hYuoSI9qRA4ws3/qlfPNHqZSni/KWDno5Bw8dilXCb53KG79RERuV1wyA2S6D8/MHMp9+j9iHff9uKTKZW8Wq5HbE/v3Jm4JnfgeFNn0kVC9buU43UTisFtzToPi8EFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlbTqBwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlbTqBwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67EFC4CEED;
	Tue,  8 Jul 2025 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993858;
	bh=8FspT2VIhYhdVf3jdvJNBhHmVoOCRo2+MEhucrpFD7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlbTqBwj1TfthiZcfsECx5BZTczaJdkseP/Xw9lQxfDkwTiyZnfqDgymGGgsqINW1
	 zFvOQ1Gx0FkxiQxoLpYGfZTda8dG+yoIzzt3M1CAteRhgSDOe/am6r6suVllhdhZ3a
	 OG7F4DmdX2/UAfFLhcBSMNAGTnX5+0Z+lSixncns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/160] coresight: Only check bottom two claim bits
Date: Tue,  8 Jul 2025 18:20:51 +0200
Message-ID: <20250708162231.902877233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit a4e65842e1142aa18ef36113fbd81d614eaefe5a ]

The use of the whole register and == could break the claim mechanism if
any of the other bits are used in the future. The referenced doc "PSCI -
ARM DEN 0022D" also says to only read and clear the bottom two bits.

Use FIELD_GET() to extract only the relevant part.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250325-james-coresight-claim-tags-v4-2-dfbd3822b2e5@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 3 ++-
 drivers/hwtracing/coresight/coresight-priv.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index 3ea6900542223..f6989a74fec94 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -161,7 +161,8 @@ static int coresight_find_link_outport(struct coresight_device *csdev,
 
 static inline u32 coresight_read_claim_tags(struct coresight_device *csdev)
 {
-	return csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR);
+	return FIELD_GET(CORESIGHT_CLAIM_MASK,
+			 csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR));
 }
 
 static inline bool coresight_is_claimed_self_hosted(struct coresight_device *csdev)
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index ff1dd2092ac5b..b416edcdf797d 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -32,6 +32,7 @@
  * Coresight device CLAIM protocol.
  * See PSCI - ARM DEN 0022D, Section: 6.8.1 Debug and Trace save and restore.
  */
+#define CORESIGHT_CLAIM_MASK		GENMASK(1, 0)
 #define CORESIGHT_CLAIM_SELF_HOSTED	BIT(1)
 
 #define TIMEOUT_US		100
-- 
2.39.5



