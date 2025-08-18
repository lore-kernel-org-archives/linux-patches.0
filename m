Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282062727E2;
	Mon, 18 Aug 2025 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522849; cv=none; b=DqDHBRY22GOQqLrUtkbY3zeIazIQoiIXxF2+XzPcZVXfGtVEVHEC6he1tf1LR1m7mi/6isP6N4iOazHpOpewUGgxU13pasZOw/POxFvtSiFonawSfuiQmHwt9jMQCHux5DMSrzlr5Am5CROIPur/0Mj5iclFGctEX/qtfreY3Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522849; c=relaxed/simple;
	bh=E4YwzDfbuF9o6OIpjlBhvlR7qGr/L0hoa4wjqTzQZ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLHVycif55aJ6t5vFdjohtdvZl9rE8ftasPLziDtzXG58qI/IDuHTQbpIXJ7bcRxJcjgEuyG4QThltSo6vlBB4fCR3R/40qLVI7e4taTKyE0sm/nJJ9LbFMnjR+OVStEKFGbGHIZsm/0d0hbepdWK1SO/mcdrvyH0WU2ZyWn8N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aj39rzZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aj39rzZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871D8C4CEEB;
	Mon, 18 Aug 2025 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522849;
	bh=E4YwzDfbuF9o6OIpjlBhvlR7qGr/L0hoa4wjqTzQZ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj39rzZPEgM/nu6qr0nxcJDNEqBPhVZ12wRwqG+r4sFcZhDvLrHtMAbPtt0IZt9Vl
	 aA5js9cBp/VpcfntBxUdpkfGnPnZRz/u2k08yanUE2Ww6MxE2RdKzZec/CKxlCYjJl
	 Au3WTAVYhtdEuU+HZoQhJkbLQ8QsYC7LM8KcfWV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 440/444] drm/amd/display: Allow DCN301 to clear update flags
Date: Mon, 18 Aug 2025 14:47:46 +0200
Message-ID: <20250818124505.461267397@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5121,7 +5121,8 @@ bool dc_update_planes_and_stream(struct
 	else
 		ret = update_planes_and_stream_v2(dc, srf_updates,
 			surface_count, stream, stream_update);
-	if (ret && dc->ctx->dce_version >= DCN_VERSION_3_2)
+	if (ret && (dc->ctx->dce_version >= DCN_VERSION_3_2 ||
+		dc->ctx->dce_version == DCN_VERSION_3_01))
 		clear_update_flags(srf_updates, surface_count, stream);
 
 	return ret;


