Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4014C97;
	Tue, 11 Nov 2025 00:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822548; cv=none; b=AazXgKx1H50Vjjs6MWXfHp6e8w/5jTdY+FshW359NRMYuUk0Fl2wE9kLvsKsjf5vZKd8sHsa5zW4vNvYasG02A1QFBwzxmFZ75Tcrxi+FygKO7LVO5CcTOLpiD2oIRxJB2I0ac7caKQwWUEn8uPNDUZSi5vqyyR8FH9tjYf0gjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822548; c=relaxed/simple;
	bh=IvwAjSB/M0aE4ZxE2iEHYWPLGHIKB3hNo1SCt/08fhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0AISqikjQKCrcNub+DlIFJU3UBCuqit4E39DtlNUIsIS4G2scJlCTgU5dB9sXu79MpWtYGwoyQ6YtVQKpb+YN+5xXTCpavSZnAY1YEnwS9FvR1Yu6/u3jfygZb16mYJehc6GsZmQYHushcnzoJJOE2ORdW0M7G1XiTWsIwFtB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFs2v1ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFs2v1ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A31C113D0;
	Tue, 11 Nov 2025 00:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822548;
	bh=IvwAjSB/M0aE4ZxE2iEHYWPLGHIKB3hNo1SCt/08fhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFs2v1ovVZ5lVoI7hGmWy8HGMRvqcRV0Ib1j6UgUteakHrx4nzKGMS6cISz0pdBhm
	 h2yqjJCKyegrMO2jvl5lLKNp+7AGtLFSCDK8zHXyzxhKHeRh3X/LsEb1/vEpvTS7Jp
	 NWLpGAnORWowQMNp4P1pylWUBMIY13UfFSTLgnKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 072/565] drm/amd/display: Fix incorrect return of vblank enable on unconfigured crtc
Date: Tue, 11 Nov 2025 09:38:48 +0900
Message-ID: <20251111004528.572630949@linuxfoundation.org>
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
@@ -296,8 +296,12 @@ static inline int amdgpu_dm_crtc_set_vbl
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
 
@@ -378,7 +382,7 @@ static inline int amdgpu_dm_crtc_set_vbl
 			return rc;
 	}
 #endif
-skip:
+
 	if (amdgpu_in_reset(adev))
 		return 0;
 


