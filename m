Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44119E7CA;
	Thu,  6 Jun 2024 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683513; cv=none; b=DHFpFFojIHn3DoJnb2o5ZX2yWUkLVIpvT/3GG+IB+RA9gBD+CsNNwszWgjpPVB3rLLB4GHusp78507eYH6sLze5w4Ugv6XZLMpq9RvbbS/QEkVd9QrYMrFwtLdgdt2KqlekdYwGU2/Z/4Co7Kn/6EMHJGpAlvA0cUIMaPR+F3bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683513; c=relaxed/simple;
	bh=UtT0Y2WHexqHM6m6z2EIaMQ9mmwUmIv9DO7OfWPScf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9L6roHZzMxwl+65eRz6S2M8H/XDfhhf+rjLGtS5TdbvI6iur2xjVy5UXoCMiL+aSqgIM7ve27vWtB66WYA35e3m/XsvkLRuxb+kXYihSmZRsCWLNnWgclUr+ZXOlkaTQB0TJBzvxHAvjKdsKIMCTB3+kYCcme9i3SGmD/LsMw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGcEG+qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGcEG+qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42841C32781;
	Thu,  6 Jun 2024 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683513;
	bh=UtT0Y2WHexqHM6m6z2EIaMQ9mmwUmIv9DO7OfWPScf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGcEG+qeh7Rak3fA5336aVZuuamXSHLTiVSBd08NNJkDkgXDuK9b3/F7pQu2fX6Fr
	 eg8TvWw4abGueRFR85cphIilNBoMX33vuKEPadQ/wE235jFaHbRe6ut6/A+j7UVceP
	 Py30OuWkmd8oEJp4vQu1T0Xdc5yPGRp2GnaYoEsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 454/744] coresight: etm4x: Do not hardcode IOMEM access for register restore
Date: Thu,  6 Jun 2024 16:02:06 +0200
Message-ID: <20240606131747.041872171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 003245a791a23..ad866e29020e3 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1805,8 +1805,10 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
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



