Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192C46AF2A;
	Tue, 16 Jun 2026 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624547; cv=none; b=NBtY1lQOSptq+d+jHCAxkm3LDdvLI5lAjLWeDRmVUJ1I0fsW/h+0tfvXqyyK7XdkEclH4EJuBaY1vxgEwQn0emFMebyMnhUPen5XJ/W8sFAcsSKmqv7OjdLQQ1WyG+kYuCyDdAaspak6MI1u5AEjLD/nT1w8Q1bjRGUKlYlfh/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624547; c=relaxed/simple;
	bh=ptCXmQsSDrGErHt9fG83/ZcHki4hWSttXlW2YT9Z72s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2UnpuaUelqy5eZTHYCOLRv/WRKMfZb0TS9WR/1ow5hIujis2sBP1E+79c5zmUAf9KbGcHZqusxcLGJsnZ88Rh90dWxVZXyv+JZVR7XL5KrrwJsFLHbYSO+rCc8UDUTDPkpcMcucj5k0nx1uJto5MSs30Sx8NnHYKwfPhjFqiWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHcjBpde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHcjBpde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476081F000E9;
	Tue, 16 Jun 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624545;
	bh=lI+a0hvmJQYOJ/leyUcaCCZocA5rXkYRK1xf/B4QSHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHcjBpdeu+BhttZNL49QDk3sncnEj4k4fsVnVOI4L0+PyMh8OQYzVkTG5gBA1E/EN
	 Hc5p2iZLniCh5xbKtPLmk2uleXUg8BDdBpqS4txRMUh3QoZ0xftmIGO0nAnEAd7KIB
	 wkqbiuK9F4NJmfs+A8DYaPO/ICtsR/SfnP8tsoQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 356/378] drm/amd/display: Fix NULL deref and buffer over-read in SDP debugfs
Date: Tue, 16 Jun 2026 20:29:47 +0530
Message-ID: <20260616145128.884984458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit adf67034b1f61f7119295208085bfd43f85f56af upstream.

[Why & How]
dp_sdp_message_debugfs_write() dereferences connector->base.state->crtc
without checking for NULL. A connector can be connected but not bound to
any CRTC (e.g. after hot-plug before the next atomic commit), causing a
kernel crash when writing to the sdp_message debugfs node.

The function also ignores the user-provided size argument and always
passes 36 bytes to copy_from_user(), reading past the user buffer when
size < 36.

Fix both issues by:
- Returning -ENODEV when connector->base.state or state->crtc is NULL
- Clamping write_size to min(size, sizeof(data))

Fixes: c7ba3653e977 ("drm/amd/display: Generic SDP message access in amdgpu")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6ab4c36a522842ff70474a1c0af2e40e50fc8300)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -1344,8 +1344,13 @@ static ssize_t dp_sdp_message_debugfs_wr
 	if (size == 0)
 		return 0;
 
+	if (!connector->base.state || !connector->base.state->crtc)
+		return -ENODEV;
+
 	acrtc_state = to_dm_crtc_state(connector->base.state->crtc->state);
 
+	write_size = min_t(size_t, size, sizeof(data));
+
 	r = copy_from_user(data, buf, write_size);
 
 	write_size -= r;


