Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC343190063;
	Mon, 24 Feb 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408668; cv=none; b=UdSKt2c5eAZUltrAaGVk5BKi656LvpQkvsBKug+tglC1EDhxq0Iel8wItHBcP5cwfD+MPlNBuZ7jdbEJreutSFsT0jsV0eV08pG92LJ7oMLkcy2N7W1WXp2kXqyGM7/go/Elkfvp4yrBansm6ShedjqmqN4E6gyZNQMRi93ic1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408668; c=relaxed/simple;
	bh=M/5cKXVjQUao2IXF2+B6QvfrL5LMzT2og+IEXME0FGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/xiBScAp6d70kszCtTmKNAa5YhIWCzeWTgZPm4SuKV1x2Hry/lX4ntBPqG1D4RUSxPZEK7SE3PiGPHIC6s5+av/5Ux+obKJAgAQ6rtzh4mMztvHPbnW6qb2kY/4CDxA8GET7pkpY0pf6bRiERrOnRFpFFD5kYO6p673ZDBttDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3b1ycRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3b1ycRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76ADCC4CED6;
	Mon, 24 Feb 2025 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408667;
	bh=M/5cKXVjQUao2IXF2+B6QvfrL5LMzT2og+IEXME0FGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3b1ycRYRXURfvMxwMaUuj58XJau4T5hKzFZbkHkHyeNjHHIGFB6bqQDOEZrmc/vZ
	 Q2Y4xLXEf3kWO/KdxVQDbv6NGsslbnA9Q26rmv7TgRK54GcpMSCJrvU/lvIfvVysdZ
	 jCfCGD8iWb1z+9ZriVwYcZFynOgm4/8qraADYeyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/154] drm/msm: Avoid rounding up to one jiffy
Date: Mon, 24 Feb 2025 15:34:52 +0100
Message-ID: <20250224142610.708851150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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
index 2e28a13446366..9526b22038ab8 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -543,15 +543,12 @@ static inline int align_pitch(int width, int bpp)
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



