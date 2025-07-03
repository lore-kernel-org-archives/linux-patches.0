Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F362EAB95;
	Thu,  3 Jul 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553960; cv=none; b=PncdoKmUMCr5bM/L6d/c7tU0rnzH6/2hfejBH9oMwb5KtuNLLK9AYwbzVKrM/HLWoI+uKJ62atuUHCH/pkmFao2FK0TG1Rluoq54Qyi+HFvmgMhPXMdVK5Mm9GABKj0tDsKfdzS36qpWIbC0OfJj8MZ9przwYrGUuWZznlZ8pxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553960; c=relaxed/simple;
	bh=gkF0yz8HWNTb+fjk4SeQWqdXUWGRq9lCNd9B2Pdv6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPryQL7wvitOG/ZTAIIG95w6maDu8XRpNQV4RsZ+wTw66CPBhCt4VF6EeF7L7kZh6k5nMUkvh67ue4TC7s9x8pixvRv3OSWM8ZFkXGoQlY1g138VnqXJgR8PUeimrNSHsx8EJ4lMGCQXah9vOdiMmgIlkpipw891auyTiX0x+8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDZSRAqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDZSRAqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5327C4CEE3;
	Thu,  3 Jul 2025 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553960;
	bh=gkF0yz8HWNTb+fjk4SeQWqdXUWGRq9lCNd9B2Pdv6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDZSRAqfjQOu/9RBvf6kJpGHEZCuB+Tx5faOCy+EGqRI3LbR8SPbgjw9wETCGbmtm
	 KJ2lppcy2NsyblmnRJfSGjXCrXrpQAqOMCn9WZ7JMkil+AzF/QBiI6QiOBgP2gAX/I
	 tk6xA0H23fEqh13EofZkwTt7CDgo8iTcsz4REDWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/218] coresight: Only check bottom two claim bits
Date: Thu,  3 Jul 2025 16:39:45 +0200
Message-ID: <20250703143957.432091154@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c7e35a431ab00..b7941d8abbfe7 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -97,7 +97,8 @@ coresight_find_out_connection(struct coresight_device *src_dev,
 
 static inline u32 coresight_read_claim_tags(struct coresight_device *csdev)
 {
-	return csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR);
+	return FIELD_GET(CORESIGHT_CLAIM_MASK,
+			 csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR));
 }
 
 static inline bool coresight_is_claimed_self_hosted(struct coresight_device *csdev)
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index 05f891ca6b5c9..cc7ff1e36ef42 100644
--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -35,6 +35,7 @@ extern const struct device_type coresight_dev_type[];
  * Coresight device CLAIM protocol.
  * See PSCI - ARM DEN 0022D, Section: 6.8.1 Debug and Trace save and restore.
  */
+#define CORESIGHT_CLAIM_MASK		GENMASK(1, 0)
 #define CORESIGHT_CLAIM_SELF_HOSTED	BIT(1)
 
 #define TIMEOUT_US		100
-- 
2.39.5



