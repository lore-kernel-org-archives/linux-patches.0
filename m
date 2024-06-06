Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F83196C7D;
	Thu,  6 Jun 2024 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682940; cv=none; b=MyP/9nQg97aOQWV3JnbVe3+sAy6Sq/pNaRH+n2D+PMQhqznz1q7d3wfgXqtthCsPJtdotMJcCWmh4VDv9n4W/gTUUAvMuj5keNYBz/gofdsIoYBr2OwGAfIax+IfHDX0K5ZVH4VzrLyp3RxAoL1fuNel9FHYXEFKc4gpsjN4iaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682940; c=relaxed/simple;
	bh=maW7uI93kl6Q4dySsm7fY6Kny7bsA/eLC01EX3BgEYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/RdgIwU9y4SpZhiZ0/98Dn4s6y9R9W7CGspsdS7LWgvF+CUa4jIq4NbmViUD6UCx77/mfU98pe5Qjk4gOl88wLG0hR7Mr+7qU0D+xUJ9luRW9jqIcU+Bqae9OcQk4qbAev+lUukYbGiLgjDUOlZJoU/rYZUMyUyZDOyzjf3U9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+J+BD+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+J+BD+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005B7C2BD10;
	Thu,  6 Jun 2024 14:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682940;
	bh=maW7uI93kl6Q4dySsm7fY6Kny7bsA/eLC01EX3BgEYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+J+BD+9auG1Kt+oXKa1gteqimbsMl/Ya47NEFIymGGAzNy1UCXXY/4BmCG+w8vvU
	 BJfcEXX2eqWLMLxWrgRzBaYc32F8hmMyu8s8YVH7zZDXcHZ+UUV50Dg72QiroNzLyd
	 XwshXecnyUuu3Ae8ghSqHU7joXn89/tcr/IkSyAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/374] coresight: etm4x: Do not hardcode IOMEM access for register restore
Date: Thu,  6 Jun 2024 16:00:34 +0200
Message-ID: <20240606131653.677925267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 06a9b94b8c13e..b9c6c544d7597 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1843,8 +1843,10 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
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



