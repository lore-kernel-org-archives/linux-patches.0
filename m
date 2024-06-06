Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519519CCFE;
	Thu,  6 Jun 2024 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683431; cv=none; b=qGcG/YkPhTDiMaKXAQpB+16h5JXgHRkQAWT6+WLT/rgpe4V4g56WaNOoaX34qFH2iyH6bqiU/TiQtlOwiW0Ep9FAYB1zDlWMDfWoj/O3GSXIDk8fCConL0mQuHXDJzEeCsIEROdx7WD2xfTXVwPJEqnyaMQmaYsH0/ic8UtCKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683431; c=relaxed/simple;
	bh=DzVyl7yQn9O96yNjg8NAucprGFbd/cZcRZDG4QURU3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZCiQ1uvrFf5GuG4KskZ/pUpjzNlJMQrjgAxpeLAXwfz7q/qI16IxN0+d6G7waMh703RkZN+fLihCT6tha3VzYD7xF8xTaBPoJFSiDTkYm+BJFxP2qDr+pxZLxX67iO0oLbHaS2mbNTFuPw6Ogn2R6sC9Rks7r82v5P31eoIamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXIHthD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXIHthD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E3FC4AF0A;
	Thu,  6 Jun 2024 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683430;
	bh=DzVyl7yQn9O96yNjg8NAucprGFbd/cZcRZDG4QURU3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXIHthD2wykHVUgF516BAa066LmBtQLduvMfOMdrBDYtHtc2TFCyf7lyWIyxhWkJA
	 a14BkIQjaU/Vn/9gmjXAPar6SwTtoUC0b+DRNlYsI7RM/oLy4AA/Y8+Ht3hbDcNx5K
	 aI3Fjvzp7taCaSNW8jXM4qi00ZDAymcdjOmbEuwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 316/473] coresight: etm4x: Do not hardcode IOMEM access for register restore
Date: Thu,  6 Jun 2024 16:04:05 +0200
Message-ID: <20240606131710.380942883@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 1e7ba33fa591de1cf60afffcabb45600b3607025 ]

When we restore the register state for ETM4x, while coming back
from CPU idle, we hardcode IOMEM access. This is wrong and could
blow up for an ETM with system instructions access (and for ETE).

Fixes: f5bd523690d2 ("coresight: etm4x: Convert all register accesses")
Reported-by: Yabin Cui <yabinc@google.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Yabin Cui <yabinc@google.com>
Link: https://lore.kernel.org/r/20240412142702.2882478-2-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 63fe506a60314..e8adee6017714 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1726,8 +1726,10 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
 	int i;
 	struct etmv4_save_state *state = drvdata->save_state;
-	struct csdev_access tmp_csa = CSDEV_ACCESS_IOMEM(drvdata->base);
-	struct csdev_access *csa = &tmp_csa;
+	struct csdev_access *csa = &drvdata->csdev->access;
+
+	if (WARN_ON(!drvdata->csdev))
+		return;
 
 	etm4_cs_unlock(drvdata, csa);
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
-- 
2.43.0



