Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D822571CE;
	Mon, 24 Feb 2025 14:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408223; cv=none; b=kD4QQNAoIy4IFLnmHyMM9+s04ilyZzzE892ynJsHEb7Sbykd3+LtRTwthFoRb8KSbTYhgbqtbIp7zzLEYiFNWd7Qo2tY+Mz1HML9PskvSJg+pGzAels8fmraJ8q0fAbkAaK3EukzDB6dRs6DKBijCgC+UE1P2r7BiN/ueScr6xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408223; c=relaxed/simple;
	bh=liwpKNtLHb/2xnHgeQx+9W+J+NSo3UrkXsUOm3eASI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHkAOggCNFT3iiTzm7ZzGtlYHud6lR0JnJS+TxUi6KpIZ1CNOCEmJccJtGzhFIC/OJbC6YqOiVNwKTfFMgtCCfkB1Tqke3iekJdVE36Y/+C9SCQ5GyAxaTRSX2yqohnUuGO1tiFWE50KA9VTgY+jvU+XQQxVP2oJ3vM+7XQP77w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d226HAyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d226HAyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1C4C4CED6;
	Mon, 24 Feb 2025 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408223;
	bh=liwpKNtLHb/2xnHgeQx+9W+J+NSo3UrkXsUOm3eASI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d226HAyVURLcb0xFGjINdw12ZzW76zJQLBkyb2nDnwGyZc7xpBE6O+ybTA4deGIFu
	 UgHQft3KGXFccZfeyPLFperUngo58Qun61WbWvQ5pAtHZnXEFv09IkJn/x38IhcIE9
	 M4wTDasLXYKM32MG8BwjKGvINzSyH9AbiRvcUvs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/140] drm/msm: Avoid rounding up to one jiffy
Date: Mon, 24 Feb 2025 15:35:02 +0100
Message-ID: <20250224142607.062334065@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 669c285620231786fffe9d87ab432e08a6ed922b ]

If userspace is trying to achieve a timeout of zero, let 'em have it.
Only round up if the timeout is greater than zero.

Fixes: 4969bccd5f4e ("drm/msm: Avoid rounding down to zero jiffies")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/632264/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 48e1a8c6942c9..223bf904235a8 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -533,15 +533,12 @@ static inline int align_pitch(int width, int bpp)
 static inline unsigned long timeout_to_jiffies(const ktime_t *timeout)
 {
 	ktime_t now = ktime_get();
-	s64 remaining_jiffies;
 
-	if (ktime_compare(*timeout, now) < 0) {
-		remaining_jiffies = 0;
-	} else {
-		ktime_t rem = ktime_sub(*timeout, now);
-		remaining_jiffies = ktime_divns(rem, NSEC_PER_SEC / HZ);
-	}
+	if (ktime_compare(*timeout, now) <= 0)
+		return 0;
 
+	ktime_t rem = ktime_sub(*timeout, now);
+	s64 remaining_jiffies = ktime_divns(rem, NSEC_PER_SEC / HZ);
 	return clamp(remaining_jiffies, 1LL, (s64)INT_MAX);
 }
 
-- 
2.39.5



