Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677422144C4;
	Thu, 12 Dec 2024 17:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023155; cv=none; b=k13cmtl/CLBH+bqiZgJ7MoMVK5RuXzLwrJSU3U2Jd7hyMd9dGTVM1R2L4G3WVSBsYC+Y88fbZ6H5SHG4hQaU8q/K/lEugdpqBto6A2S0KvgvOTQ78oNY73i7YnWQu3YqFaBZuXZEVQCm5vCjanyEkV3sdrKoSheeFHR+xxpXSCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023155; c=relaxed/simple;
	bh=7BPw0P9PDJyXbBPWT7DJcIJw8fNc9SuD3s2XC9tQ2s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZmK8Ctyzt7LmX7CDtXeTZBevFXbBC3VSZU/jFsSQt2d1445XTRRnhLy8WcDDLUsAipqPQ7bsATW7E/TgoUdH0T6ceqS9C7m4zCc5Q6mWsCR5obSSGjWbWycRbIVgGO7W45depSQaIIYxNm6436y7N3Cfh+anglNkiPbJLKxEHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5E1p3fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5E1p3fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C97C4CECE;
	Thu, 12 Dec 2024 17:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023155;
	bh=7BPw0P9PDJyXbBPWT7DJcIJw8fNc9SuD3s2XC9tQ2s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5E1p3fJXthOXsppodZ6tAxsRucG001XJh8APzZCK1WGxmGItgBdzMNY+GqTOra4e
	 +sFiDVbcSLB70hnLASC99JqyNurfMTEXYEVPtgT+OcMnM+rWwZfQKomSKSa2Ocy/qM
	 YY0Bhiz0iYPLOncHWex2eKDDcxi9WLmgs8YmN6VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/565] drm/v3d: Enable Performance Counters before clearing them
Date: Thu, 12 Dec 2024 16:00:36 +0100
Message-ID: <20241212144329.125574745@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit c98b10496b2f3c4f576af3482c71aadcfcbf765e ]

On the Raspberry Pi 5, performance counters are not being cleared
when `v3d_perfmon_start()` is called, even though we write to the
CLR register. As a result, their values accumulate until they
overflow.

The expected behavior is for performance counters to reset to zero
at the start of a job. When the job finishes and the perfmon is
stopped, the counters should accurately reflect the values for that
specific job.

To ensure this behavior, the performance counters are now enabled
before being cleared. This allows the CLR register to function as
intended, zeroing the counter values when the job begins.

Fixes: 26a4dc29b74a ("drm/v3d: Expose performance counters to userspace")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204122831.17015-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_perfmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_perfmon.c b/drivers/gpu/drm/v3d/v3d_perfmon.c
index b74b537e620fc..3de4cc692f44d 100644
--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -49,9 +49,9 @@ void v3d_perfmon_start(struct v3d_dev *v3d, struct v3d_perfmon *perfmon)
 		V3D_CORE_WRITE(0, V3D_V4_PCTR_0_SRC_X(source), channel);
 	}
 
+	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_EN, mask);
 	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_CLR, mask);
 	V3D_CORE_WRITE(0, V3D_PCTR_0_OVERFLOW, mask);
-	V3D_CORE_WRITE(0, V3D_V4_PCTR_0_EN, mask);
 
 	v3d->active_perfmon = perfmon;
 }
-- 
2.43.0



