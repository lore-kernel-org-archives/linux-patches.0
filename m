Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176832AF07;
	Mon, 28 Oct 2024 06:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098133; cv=none; b=PvyMz3njd6b+e5M26uIYppBCJUoSPOn87Y5CNc0ZYwJ09ooO+8km5SVQHOUMk5faJ6IJcGxlZwR1TtCw06HkGF4XZwQwFojMmG+1BnSNLf/O5fvh+hGJUti1I2AUcOE4PSOGoJ9UiJ1+4jkUbIiv64ZjceEr7kVeP1bHVP+9qUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098133; c=relaxed/simple;
	bh=N9p8s2qRS4zBj8ZI7pd+P0QTHMKtGssCFQhSvcU+/Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIcMx5T+Exag6uvvdGWMxrM2UidGx9y64U9IfyD9iqIg+mSAP/Knl2sp1ajtr0PTBDvSqya4F1UIm3XWMXZBdXdayLlZFD90aidSZUt2BgHpkusMxB46xcMKaqwUlkaKm0qYDjN5Lo9zMGToZwDCyPWIQlbYl7ZhLfzdYnTTdac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOKobcsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOKobcsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD51C4CEC3;
	Mon, 28 Oct 2024 06:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098133;
	bh=N9p8s2qRS4zBj8ZI7pd+P0QTHMKtGssCFQhSvcU+/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOKobcswk/7sHKTT2+Q13l46alGI6lDw6Ghnqs7R5LfzGPmEbutzl9xT9MEo0LPIl
	 sPX/3piGARTVsmm3EC+YCLe4ykdgdvM8Q2wTk/MZ8wT8Kzv3cKQb43O3zDGnYuQZKP
	 p2nIYicQCY8MjHsfpv0eGfaXynp7McUF38fdkwBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 090/261] drm/xe: fix unbalanced rpm put() with declare_wedged()
Date: Mon, 28 Oct 2024 07:23:52 +0100
Message-ID: <20241028062314.288490569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 761f916af44279a99db4e78c5f5ee839b31107ea ]

Technically the or_reset() means we call the action on failure, however
that would lead to unbalanced rpm put(). Move the get() earlier to fix
this. It should be extremely unlikely to ever trigger this in practice.

Fixes: 90936a0a4c54 ("drm/xe: Don't suspend device upon wedge")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241009084808.204432-4-matthew.auld@intel.com
(cherry picked from commit a187c1b0a800565a4db6372268692aff99df7f53)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 8a44a2b6dcbb6..fb394189d9e23 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -960,13 +960,13 @@ void xe_device_declare_wedged(struct xe_device *xe)
 		return;
 	}
 
+	xe_pm_runtime_get_noresume(xe);
+
 	if (drmm_add_action_or_reset(&xe->drm, xe_device_wedged_fini, xe)) {
 		drm_err(&xe->drm, "Failed to register xe_device_wedged_fini clean-up. Although device is wedged.\n");
 		return;
 	}
 
-	xe_pm_runtime_get_noresume(xe);
-
 	if (!atomic_xchg(&xe->wedged.flag, 1)) {
 		xe->needs_flr_on_fini = true;
 		drm_err(&xe->drm,
-- 
2.43.0



