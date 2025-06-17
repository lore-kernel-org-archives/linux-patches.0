Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEEA2FA622;
	Tue, 17 Jun 2025 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178725; cv=none; b=bsSzID//qJPjeLPhr2wpt8R6ml5p1jA1UYdsaoV0GAG9PNO10IdhxvxUjnjnRDAowO3f0s5hTEJ8zpw2JXc6O7Aoqy+jC1zJQQyKyolWzzZOmje3yZADxT5QJihmRpFxH2ahM4r1+w11cxfq/PZPfrmLiOJeQUc//V4DXQ8C6V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178725; c=relaxed/simple;
	bh=O+Z3YJfqkFZBKG2bPBRFf/g3NcQPC+vp8pu5T2d1vFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5Mkfs0dA8UN/aoktqTUl/rxHvviQ/HyYPsd1zZzuPsxRLaeZw7mLukxLnJi4fdLdAIqgHgDv9d3o17qIPSlfiFo3BbOSbf8R8bgCnJrL63ji8gxaOYeNoAm+r5+W46naWM4ZahJtOxp0xczQuDpW7xZf7KRzYzcTz6ELlQrorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPuuyoFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPuuyoFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84250C4CEE3;
	Tue, 17 Jun 2025 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178725;
	bh=O+Z3YJfqkFZBKG2bPBRFf/g3NcQPC+vp8pu5T2d1vFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPuuyoFRz0C8aQxx7VGH6w/Gg3is1A7GmoN13MgVQLwA2jkiDtBvULTeaL5UebyQF
	 I+euEXtrWs9dRvS1xEXydidnWmnn20Zt5IntYM1to2a5AgLyiFaEVovNvbvSQHvFEL
	 b6L7UmdWSxJ+RvHIjmB/AUc53k6GJux9tz+5GGi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 534/780] coresight/etm4: fix missing disable active config
Date: Tue, 17 Jun 2025 17:24:02 +0200
Message-ID: <20250617152513.256323496@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 895b12b7d7b8c651f73f57a1ea040d35aa7048cb ]

When etm4 device is disabled via sysfs, it should disable its active
count.

Fixes: 7ebd0ec6cf94 ("coresight: configfs: Allow configfs to activate configuration")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250514161951.3427590-2-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index b42b03dba516d..88ef381ee6dd9 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1020,6 +1020,9 @@ static void etm4_disable_sysfs(struct coresight_device *csdev)
 	smp_call_function_single(drvdata->cpu, etm4_disable_hw, drvdata, 1);
 
 	raw_spin_unlock(&drvdata->spinlock);
+
+	cscfg_csdev_disable_active_config(csdev);
+
 	cpus_read_unlock();
 
 	/*
-- 
2.39.5



