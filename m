Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DEB14E2F4;
	Tue,  9 Jul 2024 11:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524267; cv=none; b=H2PpSw0aNfB/Y10vPsymhYyEorNtDWGzMu0xgiMP8evetmschK/yWvKfgO4/ZWgL2oFduwColCe/01Paj/NeQlelt1vx7uAQDtktE/N+ENDr5qhYe9u4hs7rkDUd8Zbf45xxhTOfsbKtuv0PBQCOObd8olqUWIUi9dtXRcjqMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524267; c=relaxed/simple;
	bh=HDAXvwvp+VQmFE3MsT3duyaqkI4zZ12OVuriT0UzbRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=br0Q17DMY03TknWboQmwXS3l6o0rQNJdt2Zdtesh8LbmGLpb6r3JuFJqr1elet4UvX4mNERqeHCkNQqdlxTr2TOjdhME/HQZRx2kw957zJ1GpxD8P+zosXtDw3nSsGpYAHcSMwO9tX9I8IYj7mWMNvKccRcPHXcmhbkZfAhgEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRu/mHw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRu/mHw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F92CC3277B;
	Tue,  9 Jul 2024 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524266;
	bh=HDAXvwvp+VQmFE3MsT3duyaqkI4zZ12OVuriT0UzbRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRu/mHw1Z9c3vG5QFAQj5wlQf9UuR3VbyDdrfpMvdMFZDnDIJhQ5PLblyYUDodXjX
	 603dOlAD66fImrIAFGSD1vdi6YqJBn7AJQbfk50KGfNPh+GrwNaWBYDZ/il0f9WhPw
	 QHq9GgbaHSVeQrNIjOsg8VKVe14emfwjP9c6wHTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 125/197] drm/xe/mcr: Avoid clobbering DSS steering
Date: Tue,  9 Jul 2024 13:09:39 +0200
Message-ID: <20240709110713.791617760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 1f006470284598060ca1307355352934400b37ca ]

A couple copy/paste mistakes in the code that selects steering targets
for OADDRM and INSTANCE0 unintentionally clobbered the steering target
for DSS ranges in some cases.

The OADDRM/INSTANCE0 values were also not assigned as intended, although
that mistake wound up being harmless since the desired values for those
specific ranges were '0' which the kzalloc of the GT structure should
have already taken care of implicitly.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240626210536.1620176-2-matthew.d.roper@intel.com
(cherry picked from commit 4f82ac6102788112e599a6074d2c1f2afce923df)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_mcr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_mcr.c b/drivers/gpu/drm/xe/xe_gt_mcr.c
index a7ab9ba645f99..c78fbb9bc5fc7 100644
--- a/drivers/gpu/drm/xe/xe_gt_mcr.c
+++ b/drivers/gpu/drm/xe/xe_gt_mcr.c
@@ -315,7 +315,7 @@ static void init_steering_oaddrm(struct xe_gt *gt)
 	else
 		gt->steering[OADDRM].group_target = 1;
 
-	gt->steering[DSS].instance_target = 0;		/* unused */
+	gt->steering[OADDRM].instance_target = 0;	/* unused */
 }
 
 static void init_steering_sqidi_psmi(struct xe_gt *gt)
@@ -330,8 +330,8 @@ static void init_steering_sqidi_psmi(struct xe_gt *gt)
 
 static void init_steering_inst0(struct xe_gt *gt)
 {
-	gt->steering[DSS].group_target = 0;		/* unused */
-	gt->steering[DSS].instance_target = 0;		/* unused */
+	gt->steering[INSTANCE0].group_target = 0;	/* unused */
+	gt->steering[INSTANCE0].instance_target = 0;	/* unused */
 }
 
 static const struct {
-- 
2.43.0



