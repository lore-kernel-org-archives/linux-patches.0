Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9562E20ED;
	Thu, 13 Jun 2024 12:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282223; cv=none; b=KXmdc6cj+zl1YCV3QBKhp3OxOAYCcQKe/H9g/fXZhYQqz7zvghcnIQAGJy8IIIiibCE9HYdwdqMDDdqN1Ep2cHrveKVsI0CtA8L4TAWVKQD8m0AbxWIV9j8unOW/NWuMSwzjZ6dVW7Y0cGpa1rD4YztPfQJayKpfGiZqrr9/ShQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282223; c=relaxed/simple;
	bh=VQXKN1H3oNnZdshvUe4yFUf4EGsnUr4k/wFV3W9g7Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ/A0WLA8KRQmEEZGQAyQWVKc/QKC44QvamUg80BA1schJsnNdO4WVISk4kGm8qYW1q/xDQ/HSDzpQ4N2QqnqgYSB4Puqb0kL5AtNYapHnf4iS685Ds5mNYCA1zloQS8Fj/BJGtneTJpihRAXRbKKqJuePHdJN9YCtSkrLkbW8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgxE1jKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgxE1jKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199D3C2BBFC;
	Thu, 13 Jun 2024 12:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282223;
	bh=VQXKN1H3oNnZdshvUe4yFUf4EGsnUr4k/wFV3W9g7Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgxE1jKWdGxnw+DQDR6sxfO47vyFH1XmxjCUpVuBpJUf+ZGuZJ7zHxg1ow5IKtYwl
	 BC0/aEB8Cc4unJ4UNruW4q1OtR2i2Gay+pTgnW7cCdVYCD+b/U0Dpm//WfQq4ZGWS/
	 Rr3Yo1dbx4TViw+v0paqfg3PtFezxdlUcaxO6FSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/402] coresight: etm4x: Do not hardcode IOMEM access for register restore
Date: Thu, 13 Jun 2024 13:32:41 +0200
Message-ID: <20240613113310.104297229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3f5e9400222e7..07f1c0ff89961 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1697,8 +1697,10 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
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



