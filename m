Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2623A1534E8;
	Tue, 20 Feb 2024 21:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463038; cv=none; b=kTED4yzV8A82FsdA8EBwRbHbXV+9X/qM0tkLdOVYlLJJvtyh+Xd22pFw9oQ2EJa71BNA097fgGTrkVbbvlK17ef9oy+UWwo/yZqmL6wPyYQazWQDzKh41BxqOrSWyS5mmIVcG6j8VlE+XYOv5rErClNZU9GcsRE4+cbFXHtk8H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463038; c=relaxed/simple;
	bh=uLV712bOuFzjYCFfy9HNNq5H6JGq2k7QgAPFKIC3klo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQQycOXsZN247yvzRmkNNxIqeDOy8MfIwWoyRtbFpllMgysq9dEyNu5qLjIqXk7KDsp8c645QGWVgnsvVlB29hkqPt1z7tR7/f5WwrKHfNzf2ZRNeilzqPUkYEY5Uf2M5C2ouwFPGuSwd7GAGTP5KYv+f4tIZJsIhYBH/2RXdy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAWOVr9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAWOVr9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9FC433C7;
	Tue, 20 Feb 2024 21:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463038;
	bh=uLV712bOuFzjYCFfy9HNNq5H6JGq2k7QgAPFKIC3klo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAWOVr9KsK4iQQtaViZm3vs/sHAaFxTvHnx4h+6rd5Pk3JjV9dHJ9nkti2rCaIYwE
	 IwdSmoCRI7EJtKwIA76qQtvNholdGwgE8d94Fjbu4sS0nR5uv7OdkJYUuvC9ZR01rr
	 HjKCDlbGa7A2A5vp5R8+2iJFf6/nD/onNGy5aBGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 116/197] drm/amd/display: Preserve original aspect ratio in create stream
Date: Tue, 20 Feb 2024 21:51:15 +0100
Message-ID: <20240220204844.546614856@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

commit deb110292180cd501f6fde2a0178d65fcbcabb0c upstream.

[Why]
The original picture aspect ratio in mode struct may have chance be
overwritten with wrong aspect ratio data in create_stream_for_sink().
It will create a different VIC output and cause HDMI compliance test
failed.

[How]
Preserve the original picture aspect ratio data during create the
stream.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6001,7 +6001,9 @@ create_stream_for_sink(struct amdgpu_dm_
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
 			drm_mode_copy(&saved_mode, &mode);
+			saved_mode.picture_aspect_ratio = mode.picture_aspect_ratio;
 			drm_mode_copy(&mode, freesync_mode);
+			mode.picture_aspect_ratio = saved_mode.picture_aspect_ratio;
 		} else {
 			decide_crtc_timing_for_drm_display_mode(
 					&mode, preferred_mode, scale);


