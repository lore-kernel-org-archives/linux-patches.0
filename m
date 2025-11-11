Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE91347FF4;
	Tue, 11 Nov 2025 01:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823759; cv=none; b=gND+Vh3f6H6jbgRCj8PGMqh65VVJ1hrsSitY6xyCL4tPJU+9JfDSGR5sfNdLBTbg07xap8TM8njDSU9m1hor8iOVSZ7UmfnYJu7CqINkY8ifvWviQqBPE1iz0v1xpb3qVneOvzNb8NU88qKrrvNiSt/ol93ZY9u+wypnFIOPk1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823759; c=relaxed/simple;
	bh=87EEJDoyIlfHKCTZxq2OoEN1CuSwrpuzBFmfF+SAMGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULcbkhnDSbAbC+7o3k9maeaHS14GUjYUw1UP6MbAnz54csJ2XPMSinD2heLeNUvziIrIiiRDCaoyXRDicu6xPi4YbMGbx1KK6MLSrr/113d5SIt3PPguqkGTqXikcg7UgbkIjGFk0cz+fj0tCxiBXhAY6d+Tpppskdu9CkPIf/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCEd2YQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCEd2YQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ED6C116B1;
	Tue, 11 Nov 2025 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823758;
	bh=87EEJDoyIlfHKCTZxq2OoEN1CuSwrpuzBFmfF+SAMGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCEd2YQI74Dw/UF5eEHJgpayeyd+Iz/YuczA915M5C9Ybomo8Qx02CvHeyUbcZWlT
	 gephA3Ljxcb76yF4LBO8TVw5AlCQhJ+RJLiqosKnhCQqOkhWYUG6L4T+eJHu+rJJVZ
	 GLAXQqMIGk1/SDyTuzGbJZ+AltmE5Wc35f7M9L7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonino Maniscalco <antomani103@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/565] drm/msm: make sure to not queue up recovery more than once
Date: Tue, 11 Nov 2025 09:42:50 +0900
Message-ID: <20251111004533.950131601@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Antonino Maniscalco <antomani103@gmail.com>

[ Upstream commit 10fb1b2fcaee5545a5e54db1ed4d7b15c2db50c8 ]

If two fault IRQs arrive in short succession recovery work will be
queued up twice.

When recovery runs a second time it may end up killing an unrelated
context.

Prevent this by masking off interrupts when triggering recovery.

Signed-off-by: Antonino Maniscalco <antomani103@gmail.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/670023/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 80c78aff96433..29d39b2bd86e0 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1522,6 +1522,9 @@ static void a6xx_fault_detect_irq(struct msm_gpu *gpu)
 	/* Turn off the hangcheck timer to keep it from bothering us */
 	del_timer(&gpu->hangcheck_timer);
 
+	/* Turn off interrupts to avoid triggering recovery again */
+	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, 0);
+
 	kthread_queue_work(gpu->worker, &gpu->recover_work);
 }
 
-- 
2.51.0



