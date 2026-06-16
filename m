Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76139477E57;
	Tue, 16 Jun 2026 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627783; cv=none; b=AVki1Lu73a+J6h9iOt/sVM0ill6iX3MrMRgaBcQFQVE5hAqI+ojJzaNSDBf6cxlQ9zJl7vNiucXRpCXzuvkJhAfJOhfuh1TZv5krSvkpIxx9wxrJ5nCGOZePxR9/eciHbJYW0VCacbNzjGkO9RCNmBJPdDwsstracPzf5s5bxWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627783; c=relaxed/simple;
	bh=y0H9PTjc077YxTYeZ3OEzgv+P6Q1WPg1Q1DMeuGle3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGbnjCfz8q91t+QvXn+5TAMnvBOBzwFB9fBEpYS9LuUTZABqpevXdHHc2WJnYNYuGEhsALJDdFldbBZ7FI3p2CF+oKdx1Ur1CRsnJt79cJlDNBlnkLY3VVqaMR700aeNcKEmUr2/7/mtXHVg5GSIRn9NG7Vduw4+3sl/o8WNr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyPYIXXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyPYIXXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9011F000E9;
	Tue, 16 Jun 2026 16:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627782;
	bh=I/tIPMfJvKbN/eaLppRebFT24gQU7h5MGruL4FCuOeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyPYIXXOe83T+8WvanhljIjSvpMUbaQX37j7AeibuPZmeU2u6SLhwoP3JpTrtU3PP
	 pVTTbkKTpkkcvRKtLzInR7HCb0q6t/nkhQKQnJQgyZQwEC5cbdQZf76wS+MrinseRV
	 BbRHdvTIgi9B5yFNNWLPpFdFRxmqovATZPkMKGdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 227/261] drm/amd/display: Fix NULL deref and buffer over-read in SDP debugfs
Date: Tue, 16 Jun 2026 20:31:05 +0530
Message-ID: <20260616145055.549337962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
@@ -1314,8 +1314,13 @@ static ssize_t dp_sdp_message_debugfs_wr
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


