Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8189446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC020C433C7;
	Sun, 13 Aug 2023 21:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962486;
	bh=LoAkQCEsObX3eIqSG4H5AcG6u/HVoWXYVJtmh8gh088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08bLf3nYgYHR1NMrTnuALM3iEtwJ+ee7kAGBJVtP5R09hsUAKzR1aYnhqkUgPByoA
	 OCb3I0dharxLsuY4PlUnuCPVRPrPkHeo1kdz7whg5o7HvB1UOT+8MmP1L7Qj4Bxrrv
	 zAcuFmDul0Pxhsy8m25n4CcJrH+HNDIjHuWrJ6lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 046/149] drm/amd/display: Use update plane and stream routine for DCN32x
Date: Sun, 13 Aug 2023 23:18:11 +0200
Message-ID: <20230813211720.194738150@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit dddde627807c22d6f15f4417eb395b13a1ca88f9 upstream

Sub-viewport (Subvp) feature is used for changing MCLK without causing
any display artifact, requiring special treatment from the plane and
stream perspective since DC needs to read data from the cache when using
subvp. However, the function dc_commit_updates_for_stream does not
provide all the support needed by this feature which will make this
function legacy at some point. For this reason, this commit enables
dc_update_planes_and_stream for ASICs that support this feature but
preserves the old behavior for other ASICs. However,
dc_update_planes_and_stream should replace dc_commit_updates_for_stream
for all ASICs since it does most of the tasks executed by
dc_commit_updates_for_stream with other extra operations, but we need to
run tests before making this change.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Co-developed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4002,6 +4002,18 @@ void dc_commit_updates_for_stream(struct
 	struct dc_context *dc_ctx = dc->ctx;
 	int i, j;
 
+	/* TODO: Since change commit sequence can have a huge impact,
+	 * we decided to only enable it for DCN3x. However, as soon as
+	 * we get more confident about this change we'll need to enable
+	 * the new sequence for all ASICs.
+	 */
+	if (dc->ctx->dce_version >= DCN_VERSION_3_2) {
+		dc_update_planes_and_stream(dc, srf_updates,
+					    surface_count, stream,
+					    stream_update);
+		return;
+	}
+
 	stream_status = dc_stream_get_status(stream);
 	context = dc->current_state;
 


