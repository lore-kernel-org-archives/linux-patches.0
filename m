Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8035A280;
	Mon, 18 Aug 2025 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526466; cv=none; b=StvcquGbaMQsnVFFQZtHIpUXY6RHdOgqxAUZDcnJgqkXNw6KdPGHlkO4b2R+kSdZlqf1cCKYP8iBUwJooW7DLD041s4rCWHYGy8JBwXKuoHm6UnXTbcyuQxI5sPyp3/v2nQN2klA2R0kU3c08F0j1jJ6YGR0nm9hVCN9XPd/MKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526466; c=relaxed/simple;
	bh=V/hVRA33cHfcLT57Ll2QFLnGo3OOktdIyJbeDP86Ki8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrHVeS00yO0aKSbdPFIGkGNssCaN8iL0b6zLJSzoxGOR5No6mqUOGY+YjUNehgbZkzNJkqad9mt+9sZBOs1Y8gF3ZLs17Nm7GTJpVkq45e+lAQKoV0qrfERQRZ3hGIR40HNEZQBfOnpw8Sh37BPU8Gy4ZylmezS7nUQs+MvuK1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFJVLaOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFJVLaOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B1BC4CEEB;
	Mon, 18 Aug 2025 14:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526466;
	bh=V/hVRA33cHfcLT57Ll2QFLnGo3OOktdIyJbeDP86Ki8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFJVLaOtT1+VlOLnbHhShwinyXKnaQorZcRxCzYtZt97vQpBLTGsmUjzx4U0dnXDr
	 mGWCojZfbh7Oo40BgArZSzIJDv8bRUGj9yNhJqYRZazq1B9FYWHXh6BysZW1lqgJ86
	 tbFOmIodDcBOpEK4Ff6kSspxuDUtsWnL177hvc2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 564/570] drm/amd/display: Allow DCN301 to clear update flags
Date: Mon, 18 Aug 2025 14:49:11 +0200
Message-ID: <20250818124527.605045293@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

commit 2d418e4fd9f1eca7dfce80de86dd702d36a06a25 upstream.

[Why & How]
Not letting DCN301 to clear after surface/stream update results
in artifacts when switching between active overlay planes. The issue
is known and has been solved initially. See below:
(https://gitlab.freedesktop.org/drm/amd/-/issues/3441)

Fixes: f354556e29f4 ("drm/amd/display: limit clear_update_flags t dcn32 and above")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -5439,7 +5439,8 @@ bool dc_update_planes_and_stream(struct
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
+	if (ret && (dc->ctx->dce_version >= DCN_VERSION_3_2 ||
+		dc->ctx->dce_version == DCN_VERSION_3_01))
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;


