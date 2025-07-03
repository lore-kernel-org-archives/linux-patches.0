Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE412ED168;
	Thu,  3 Jul 2025 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555489; cv=none; b=Fqu8jZS/q+DabrWPiTqCu/KqINfm9eavRdug+EWhCT8VCIFsMp+8e2FiIUGBIdUZQkaS4WjjswW41LdgMbsIB2plAWS51mVNwxV0+5pC1nQGNS0GfdlEREqdAs6uTHhPFEo1vewFP7MFKpLqMOBRon1yKZotIAHREr583L2TzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555489; c=relaxed/simple;
	bh=IeAWCSk8rDEbbk9zJJAOu6+rYFtjz0LDzinz/b7+6ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCNZKoeMmZMJgDrDe5syUFiMEYjA+97VDx0HmrI1vvJvx3sKcY4m7FZwlYO914NOwWSUO6j1TTjJzc3L4BUMzJOsYnNAje4xw/njMUwLvpqKUUIkpqniiIKrFIFRh9PZZZ1rrHo1b+uQYBR8P4DeX1cEKIxlTc10cVH2bYbubB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjQlWv+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjQlWv+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD75BC4CEF3;
	Thu,  3 Jul 2025 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555489;
	bh=IeAWCSk8rDEbbk9zJJAOu6+rYFtjz0LDzinz/b7+6ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjQlWv+yexltl5B/YR9Nc4UMjTWLp3FMN6l/md1SIkh7yBwRNvK+jhWlFcEC/jBZm
	 GYEeSu4apRaY9Wl++huLc3z1l8343o9KWfw4dPbdyaMLzN54KLOw+cfwMnfXhPLcIl
	 UpxNxastDD+Tj4zeNQXg34ANNT3fY+mD5IgmFiSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/139] coresight: Only check bottom two claim bits
Date: Thu,  3 Jul 2025 16:41:32 +0200
Message-ID: <20250703143942.326397736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 783e259c37612..3b57851869eaa 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -135,7 +135,8 @@ coresight_find_out_connection(struct coresight_device *src_dev,
 
 static inline u32 coresight_read_claim_tags(struct coresight_device *csdev)
 {
-	return csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR);
+	return FIELD_GET(CORESIGHT_CLAIM_MASK,
+			 csdev_access_relaxed_read32(&csdev->access, CORESIGHT_CLAIMCLR));
 }
 
 static inline bool coresight_is_claimed_self_hosted(struct coresight_device *csdev)
diff --git a/drivers/hwtracing/coresight/coresight-priv.h b/drivers/hwtracing/coresight/coresight-priv.h
index 30c051055e54b..b758a42ed8c73 100644
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



