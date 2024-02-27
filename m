Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000A13B78A;
	Tue, 27 Feb 2024 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041129; cv=none; b=oihxDx3sOLdq0lBGYgqfqEjUtuGf0dYR3nYXdTrDL6xLGcunAURi9QiWXIpw+Ju3MUMfBJkI6/KiTRuG5rGIo/0FHFZA1qqheJvj9r38Up3OAf12un9Dh8H2w98gtSAgJTlZX8jkfCfcMqQqgqaReCVcJXQkMhb5Fsnuby1EbTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041129; c=relaxed/simple;
	bh=E8RnJSKONpJ9gD9MKHJHWgpdp6Lp090Tp2pZreHaFc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhsVPXF/GrbkE0IlvZbkoN364lgI8hHBO7UO7KiRR7BDxeSNis3pAy5c8MZHHQvFR/Yke9OOxJIsGgvWo1qSc49wIx9IKuIOn/gkwXNK/5kwEQpzAebpnTFNczlO+DR1tDlMDb2nsYUWi4X99umzFdyAMQWLscN9LE7Yk1wB3w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb/68iND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb/68iND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47578C433C7;
	Tue, 27 Feb 2024 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041129;
	bh=E8RnJSKONpJ9gD9MKHJHWgpdp6Lp090Tp2pZreHaFc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb/68iNDjhvzHAIaV6g6B7hll/wSk/SFUtH3lwqCXpcjAfM6p16khEcbUYAz25C54
	 5cwpIe1xRFzDw01HXhz3a/rBP9kcephrNKBCSDyfKgIGKgDYYiYuO1I4VY3/4OGOZ5
	 ASHmCuWgRHw60Q4++exugHo7irS40eLrUF2CoYMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	PeiChen Huang <peichen.huang@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 230/334] drm/amd/display: Fix buffer overflow in get_host_router_total_dp_tunnel_bw()
Date: Tue, 27 Feb 2024 14:21:28 +0100
Message-ID: <20240227131638.225042961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 97cba232549b9fe7e491fb60a69cf93075015f29 upstream.

The error message buffer overflow 'dc->links' 12 <= 12 suggests that the
code is trying to access an element of the dc->links array that is
beyond its bounds. In C, arrays are zero-indexed, so an array with 12
elements has valid indices from 0 to 11. Trying to access dc->links[12]
would be an attempt to access the 13th element of a 12-element array,
which is a buffer overflow.

To fix this, ensure that the loop does not go beyond the last valid
index when accessing dc->links[i + 1] by subtracting 1 from the loop
condition.

This would ensure that i + 1 is always a valid index in the array.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_dpia_bw.c:208 get_host_router_total_dp_tunnel_bw() error: buffer overflow 'dc->links' 12 <= 12

Fixes: 59f1622a5f05 ("drm/amd/display: Add dpia display mode validation logic")
Cc: PeiChen Huang <peichen.huang@amd.com>
Cc: Aric Cyr <aric.cyr@amd.com>
Cc: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_dpia_bw.c
@@ -196,7 +196,7 @@ static int get_host_router_total_dp_tunn
 	struct dc_link *link_dpia_primary, *link_dpia_secondary;
 	int total_bw = 0;
 
-	for (uint8_t i = 0; i < MAX_PIPES * 2; ++i) {
+	for (uint8_t i = 0; i < (MAX_PIPES * 2) - 1; ++i) {
 
 		if (!dc->links[i] || dc->links[i]->ep_type != DISPLAY_ENDPOINT_USB4_DPIA)
 			continue;


