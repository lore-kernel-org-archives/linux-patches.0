Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A91DE89C;
	Mon, 10 Mar 2025 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626564; cv=none; b=Tsuu2w7irb+EQSiAaqRHsBsYZD71mIDxwcczVGbmZNWVO5LRwQq0HALB74c9ZUvfT0iampwxI2rThlxUa60N+Dx23epXcHCLY3RK7YgwwpKRTk0HtN0ptGaK7KVrErxdPmhkd7a8S7GANyoSUBgkOO0yl3dpBInWp6gCnglUCjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626564; c=relaxed/simple;
	bh=OPcjNHLrqulAk3rYpGpbL7X8+36cCXHW5l54ungb0PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4uU8Sg/zjbDRd7p3rY8ao/6p7/aMZUr1nXudVo/Ugjf29y6LtE2slOmiZ0uaxyb0U3HHvPrV68kU1HITglBi6D64NhAGNFLr6+OYe+2EdWSM/xvMsVWOpR9k5yDtcqLde6TIpjs+cmQJdaoqc/GWtZxsmeACGvOWno44UrG+8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGrIZn6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGrIZn6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D863C4CEE5;
	Mon, 10 Mar 2025 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626564;
	bh=OPcjNHLrqulAk3rYpGpbL7X8+36cCXHW5l54ungb0PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGrIZn6dFBgAYviC2g46p3L03y7R8Uk7W9KmR4My+OH66UV2iUz9r7W4ZPBDZo4Vy
	 /0+al7Mylz/Dejy7D6KLaRJLOXMRh0EqKQABV70qdFJZ1IIgjwqNCOupbA/r0+Fmf0
	 xloL9ghaGkCmzYf9gp8uUWVZaF6V1Xb8EF84Ffe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 034/207] drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params
Date: Mon, 10 Mar 2025 18:03:47 +0100
Message-ID: <20250310170449.131087208@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 374c9faac5a763a05bc3f68ad9f73dab3c6aec90 upstream.

Null pointer dereference issue could occur when pipe_ctx->plane_state
is null. The fix adds a check to ensure 'pipe_ctx->plane_state' is not
null before accessing. This prevents a null pointer dereference.

Found by code review.

Fixes: 3be5262e353b ("drm/amd/display: Rename more dc_surface stuff to plane_state")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63e6a77ccf239337baa9b1e7787cde9fa0462092)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1455,7 +1455,8 @@ bool resource_build_scaling_params(struc
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
 
 	/* Invalid input */
-	if (!plane_state->dst_rect.width ||
+	if (!plane_state ||
+			!plane_state->dst_rect.width ||
 			!plane_state->dst_rect.height ||
 			!plane_state->src_rect.width ||
 			!plane_state->src_rect.height) {


