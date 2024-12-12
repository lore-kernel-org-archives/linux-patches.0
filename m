Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF2220967D;
	Thu, 12 Dec 2024 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020906; cv=none; b=m55gbeww4n0Mn3SDG/bvgmFe9XM9+FVFXe1p2Uz9Pe0TuAST5ZCFslasOwbyCutIEwcedQpcrg5/VMefDbbmZNJV5MgRyJxItU5EDxydcpFT0ITMOvAjRQL25dJrthe4cU4ckhKyHMZfmvtndsbNuYJXmZ+2ITPJQK+t28MHGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020906; c=relaxed/simple;
	bh=yqAfXRkUiASummIQQJ3ktqL2SdArnUnz6BuFEWLbMzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwmAltflcW4Ofm66E1k70tLmX5HL0PrLIt+DGSgQljAaB8mXCOC6nofnC9R6q7uEesTRfskih375brxASd3W2671qFH2/lyyOGr9DSaD3nq8gHnkNdj5QPsWRfdF4hkVfttXeJIYgl8ElKi/sFyhkbqQDELTWiSVoQnNSdLjFyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgYfCl9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgYfCl9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA8CC4CED0;
	Thu, 12 Dec 2024 16:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020906;
	bh=yqAfXRkUiASummIQQJ3ktqL2SdArnUnz6BuFEWLbMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgYfCl9wDgtxBWib29p3ni9KjD6Ssn2ynmeiFeRcIDDTaR740bMsferlMSecKXhI9
	 1in6h+zYF8Lbd0GPB0+kCv4TBUBbrSRBWyWB9ziCYHDP1UR8L6CdqJYVEWhg0aPUnM
	 Ztdc5xjyh/XijkStETONNcCs0xy5VL7RsMnX3+sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 594/772] drm/v3d: Enable Performance Counters before clearing them
Date: Thu, 12 Dec 2024 15:58:59 +0100
Message-ID: <20241212144414.474306352@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cb56627328bb0..101332775b6a7 100644
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



