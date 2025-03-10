Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3936226D0B;
	Mon, 10 Mar 2025 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627961; cv=none; b=nPY94L7XB5NlZBZbkoQW86jFyw9kCnzXDcET0Yfk7vE5FvQJlezMKxftNen9y0BqnaM72EOlSpb/OpS0ZphV0B4owK1MUtJZ+V6rjPyQmF27e6N2te+LrkIP23VnvzgxUwlG+CvIUr2/Qm1SePYEHcVQP5rn5pKsMwKaUSRKHsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627961; c=relaxed/simple;
	bh=tfAqNmU0xtvtfLlHYX9ItvXVu3vurtc+nGeeiq7s+e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoWZJ5/mMqsRckZiO/jtlfzNWkCsbjci05yo1GzD4SZ1jPxbJNLuGJUILUat9l0UEQlIJg7vP8HJSvfsEQqfzUvSJqYXiD9ouju7TI2vcAojqYiK62VAU9mLtZpTNMDlsd/cRPqAH0F+6c8CJ0R692T0bcQAqo70M8DgetcMEl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQ/AT1DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQ/AT1DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF91C4CEED;
	Mon, 10 Mar 2025 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627961;
	bh=tfAqNmU0xtvtfLlHYX9ItvXVu3vurtc+nGeeiq7s+e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQ/AT1DQgZ1P7kv1NDgFSYvkmRBgSsvFEPptj7NhY+6UqzOX896/EuYLSmJvgMPOF
	 jUSMJedzmnax3D1DSv2hVgHQ+4Jo+7Ezet+qJzOXeKoBpq6J8+w6sTs25JZhf/lLwT
	 iutg1uzF+WzuJSsZGV2LXtzeW82JtfIitMp35Gg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 040/145] drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params
Date: Mon, 10 Mar 2025 18:05:34 +0100
Message-ID: <20250310170436.352411857@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1394,7 +1394,8 @@ bool resource_build_scaling_params(struc
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
 
 	/* Invalid input */
-	if (!plane_state->dst_rect.width ||
+	if (!plane_state ||
+			!plane_state->dst_rect.width ||
 			!plane_state->dst_rect.height ||
 			!plane_state->src_rect.width ||
 			!plane_state->src_rect.height) {


