Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566D54086A;
	Tue, 11 Nov 2025 00:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822435; cv=none; b=GXNoGYUvT7Lz49/EJfARHLtsnR9JqYH3GlApsQze3WQZjjMMuUDMorI/DD4TJNSg0bgZ211EfIuvjtgrurAMWKCm7woblX01A0jIumgweuwwDkWSVGwg+A9xaCukJoauAuAzqn3L0szVepu+h3nwdzB4BV6vL2opeIU3irKigCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822435; c=relaxed/simple;
	bh=Tg9xpaxD7PXvwxF2A3WEZYNFdSJp2LOdxqk0OwUh+gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj3/PBeF0+xYE9i/foze8Rs5JwZbMrAMVmq6patlFh1ymY5LEfghhYdX/+RW0SXnOMBBQ33YA6Z1djvG8Faixg+v0FA982OZsYv5xZx9sd9HhBdrkuFHOO7/7P8JL25arGQwqUfNgh/U6KTzO8c4ur36y6HNeGrc4M7NMI0yB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo/k2Hw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo/k2Hw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A99C116B1;
	Tue, 11 Nov 2025 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822435;
	bh=Tg9xpaxD7PXvwxF2A3WEZYNFdSJp2LOdxqk0OwUh+gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo/k2Hw3O++vrw7RLVtPGN/KjTZC18ff0dzdddkjFBBcw1txq6URJPUCI71M0x7Ux
	 vIABEY2fpG6RGf3nMkrxiqZKT6V6N5ut+xHPRZHT7ngPyMJE9mIhiTe2J8qiw/uU0v
	 AB1Z/QfH5BMmbb5ucyP6ZAQHn0VZ1rwso76aVzZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 107/849] drm/amd/display: Fix incorrect return of vblank enable on unconfigured crtc
Date: Tue, 11 Nov 2025 09:34:37 +0900
Message-ID: <20251111004538.986158673@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

commit b3656b355b5522cef1b52a7469010009c98156db upstream.

[Why&How]
Return -EINVAL when userspace asks us to enable vblank on a crtc that is
not yet enabled.

Suggested-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1856
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cb57b8cdb072dc37723b6906da1c37ff9cbc2da4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c
@@ -293,8 +293,12 @@ static inline int amdgpu_dm_crtc_set_vbl
 	int irq_type;
 	int rc = 0;
 
-	if (acrtc->otg_inst == -1)
-		goto skip;
+	if (enable && !acrtc->base.enabled) {
+		drm_dbg_vbl(crtc->dev,
+				"Reject vblank enable on unconfigured CRTC %d (enabled=%d)\n",
+				acrtc->crtc_id, acrtc->base.enabled);
+		return -EINVAL;
+	}
 
 	irq_type = amdgpu_display_crtc_idx_to_irq_type(adev, acrtc->crtc_id);
 
@@ -375,7 +379,7 @@ static inline int amdgpu_dm_crtc_set_vbl
 			return rc;
 	}
 #endif
-skip:
+
 	if (amdgpu_in_reset(adev))
 		return 0;
 


