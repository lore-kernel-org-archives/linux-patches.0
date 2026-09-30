Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E186A355819;
	Wed, 30 Sep 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789455; cv=none; b=HxYeYSxG2MYkxbnEnSueZQK6dlOvHPrw+lPVJWo4XmMbDJt0rI4lS8uYYqPAARE5NIdEDxDO6UROOqkANSVCoj9JR2/JIM1YxwAP54MhmJNOzNj2I2P1VNQ57qB2amVaT4RA9wxdGXbgg6JHSFYrVb/wKrfoFwiwFgrfJPmT7s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789455; c=relaxed/simple;
	bh=D+l875MfKWmCXT4AnLSNR+kOIIhkwu2BMo61qEptW/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9mlERar0/VQLVdAE6f9bq7O4mA9p1ww4WmNlsalib9lg/80w4MfK6AAkQ1Ydwi9S+dgWv3n+S69XiHU7SZHYPaTaZeLFkljLtAdRmVBVgn/OVkt78vcCb6oBwUOo+6mFUwhYkQDkr8Vm4jUr//KkqDw1ksxhRkhHXvukwMcMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUDu+UFT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUDu+UFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4990A1F000FF;
	Wed, 30 Sep 2026 17:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789453;
	bh=a3wholTsqixNKv1DlCxht0mycXnKnjmFpn4IWcPRAqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUDu+UFTvtwCfuRX68bVZ+9BlteelAP/12MCIyi+2NcThvmdJgjIjhDukIxCV9p5q
	 RHOiGQ6vvkU968rcKGxSmVoin3nurPlh15pyuxQ3eLLY6IiIWzxjDoXaDjZH1JwhWs
	 tyGK6ahUvgi5KxB3jzJkiADahHRxdkuaNJOmDcy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 482/877] drm/amd/display: Fix dc stream excess put in dm_update_crtc_state()
Date: Wed, 30 Sep 2026 17:23:13 +0200
Message-ID: <20260930152425.067792199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit c5fd4eaad50d620c7e09ac2082b2fb55ee54170e upstream.

In dm_update_crtc_state(), when a modeset is required the newly created
stream is stored in dm_new_crtc_state->stream and an extra reference is
taken with dc_stream_retain().  The reference returned by
create_validate_stream_for_sink() is released as an extra reference at
the skip_modeset label, leaving the stream owned by the new CRTC state.

If amdgpu_dm_check_crtc_color_mgmt() fails afterwards, the code jumps
to the fail label which releases new_stream again.  Since the extra
reference was already released at skip_modeset, this drops the
reference owned by dm_new_crtc_state->stream and the stream is
released while the atomic state still points to it, leading to a
premature free of the dc stream.

Set new_stream to NULL after releasing the extra reference at the
skip_modeset label so that a later goto fail cannot release the
reference owned by the new CRTC state.

Fixes: 7cd4b70091a5 ("drm/amd/display: Rework CRTC color management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 102a47065a62dc8f6bbbb47cf082a2934282eb08)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10834,8 +10834,10 @@ static int dm_update_crtc_state(struct a
 
 skip_modeset:
 	/* Release extra reference */
-	if (new_stream)
+	if (new_stream) {
 		dc_stream_release(new_stream);
+		new_stream = NULL;
+	}
 	new_stream = NULL;
 
 	/*


