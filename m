Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206E41D1748;
	Wed,  2 Oct 2024 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878470; cv=none; b=qZsDAtaUbKJmPddJ4TVUNr/76gUeEXpX2uicr+odc7UkfBBMr9W3kChfsWiSj0bR4f67Ofgq50BIzhAAr/1j7o4ZrD2JCy00ZHV6Ut88P5XQ76Lgp1eO5DzhfowiO4/7aBkfZ7FT7tz1i6WJxuFAQ2WXTBANPHDOw4ihJq39q8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878470; c=relaxed/simple;
	bh=MUu6VNSNd9UUwUE3EVaz7Cax03S5NRYtBKp5hybwNx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVGlVb19PKQTIxq4CNzXl32UvGrR6xj8J5klPVxu5Anq2PVhwjJ8p3s4LlbNR3pxUQ6PmyAnf3qzr0NR6tpCMdMDLQv7JTgsSaRe5VaaBQ5O9rBI+qDZV0Y9P6g8NY+u7KDQIyN4MDu6o7jpsSX6Op6yGHZ1DbaujrjMDWChfKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FB6dRFFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FB6dRFFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5EBC4CEC5;
	Wed,  2 Oct 2024 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878470;
	bh=MUu6VNSNd9UUwUE3EVaz7Cax03S5NRYtBKp5hybwNx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FB6dRFFgyl3vfiAGNkKu9CdJ6z4kUvEJI1/wHx17779Dth0Ea0Jrxfuaih2wfIfWu
	 BKfE2Zf3AKtXZSMY4LAPxerqtOi1geuBdEd0OtIyXF7VYkufCe+Hki7viAPgJSMsdw
	 7iz0z3RoouBT84OB3CbcLvrxEVctdVIwJLoPYfKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <quic_jiegan@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 424/634] Coresight: Set correct cs_mode for TPDM to fix disable issue
Date: Wed,  2 Oct 2024 14:58:44 +0200
Message-ID: <20241002125827.839380732@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <quic_jiegan@quicinc.com>

[ Upstream commit 14f5fa9b5fcbe2b3d5098893aba6ad62254d2ef6 ]

The coresight_disable_source_sysfs function should verify the
mode of the coresight device before disabling the source.

However, the mode for the TPDM device is always set to
CS_MODE_DISABLED, resulting in the check consistently failing.
As a result, TPDM cannot be properly disabled.

Configure CS_MODE_SYSFS/CS_MODE_PERF during the enablement.
Configure CS_MODE_DISABLED during the disablement.

Fixes: b3c71626a933 ("Coresight: Add coresight TPDM source driver")
Signed-off-by: Jie Gan <quic_jiegan@quicinc.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20240812043043.2890694-1-quic_jiegan@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tpdm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-tpdm.c b/drivers/hwtracing/coresight/coresight-tpdm.c
index 0726f8842552c..5c5a4b3fe6871 100644
--- a/drivers/hwtracing/coresight/coresight-tpdm.c
+++ b/drivers/hwtracing/coresight/coresight-tpdm.c
@@ -449,6 +449,11 @@ static int tpdm_enable(struct coresight_device *csdev, struct perf_event *event,
 		return -EBUSY;
 	}
 
+	if (!coresight_take_mode(csdev, mode)) {
+		spin_unlock(&drvdata->spinlock);
+		return -EBUSY;
+	}
+
 	__tpdm_enable(drvdata);
 	drvdata->enable = true;
 	spin_unlock(&drvdata->spinlock);
@@ -506,6 +511,7 @@ static void tpdm_disable(struct coresight_device *csdev,
 	}
 
 	__tpdm_disable(drvdata);
+	coresight_set_mode(csdev, CS_MODE_DISABLED);
 	drvdata->enable = false;
 	spin_unlock(&drvdata->spinlock);
 
-- 
2.43.0



