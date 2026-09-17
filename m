Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E145187FE;
	Thu, 17 Sep 2026 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667013; cv=none; b=pPg5Z+UypyCS3EkIYxdb2HL0KAtPOhg7Nm+hNX5ovaIRMWD10OghyUHsdwjiwL+edtQ5zpBZwYhlfq2L6tgyLwgGPvmyzVzLQCFlNrYHYQvFU2nNhBIDUaKaJZUJ9c/m4EZNw4j5X52lR1kyZCpT1NFj7fpA6l6lahP5JxviVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667013; c=relaxed/simple;
	bh=ky+WCmNNu+5PXQAkqK7vJf2kz3FFLLYfqbQKP5OZnrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR/APnW1ppW++3dUFp3+5eGzJ774k91bUpGA3b/vmSbodYwWZrAG7oZ1ZeZvmyWtzD9dEiUHuRjwmm3CIijvkq0m1RwGjhSe8AK5iWIvoEjnGYXWOE3CED2rJ2sw9JjZ1wZJAEDt5O0k3TOhI6jM23pm+TphSxPaRvAYsIq8aKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=io68WT/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="io68WT/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B3A1F000FF;
	Thu, 17 Sep 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667011;
	bh=YoLAurvhidX0dus7gYgOSkj4SSDJdw25tdDzPN5r5/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io68WT/jw14EpgN6lWOK4EozJfmTavNoClBCIm8lSyvmkh7ia6qnpt+2WXKx2nkkN
	 r5ei+e2t+Uv6/zQgac7mJXyiVOBVnNb+TNsuGk7LTV8bccaMsQsVrK0XkkDjNEv4ls
	 sgO2QH9xHSbC5wXjWGeiVk6tgaFCS+yKiuXXlsCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1200/1250] drm/amd/display: Rebuild InfoFrames on output color space changes
Date: Thu, 17 Sep 2026 16:16:35 +0100
Message-ID: <20260917151624.807693181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyajit Roy <sroy14@alum.utk.edu>

[ Upstream commit 8cfd9e22eb5c04b15b82985ff913944f84673d4f ]

resource_build_info_frame() derives colorimetry and RGB quantization from
stream->output_color_space. A Broadcast RGB-only atomic commit updates
that field and reprograms the output CSC, but none of the InfoFrame update
predicates include output_color_space. The sink can therefore retain the
previous AVI InfoFrame range while the source starts transmitting a
different pixel range.

Treat an output color space change as an InfoFrame change in update
classification and in both stream programming paths.

Hardware testing on an HDMI 2.1 television confirmed that its automatic
black-level selection follows Full to Limited and Limited to Full
transitions in SDR, HDR, and HDR with VRR active, without a modeset or
visible link blank.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d6faca79f5720893843e649e70aeb19147ee0578)
Cc: stable@vger.kernel.org
[ Omitted hunks requiring the missing info_frame flag and commit_planes_do_stream_update_sequence() function. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3602,6 +3602,7 @@ static void commit_planes_do_stream_upda
 				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
+					stream_update->output_color_space ||
 					stream_update->vrr_infopacket ||
 					stream_update->vsc_infopacket ||
 					stream_update->vsp_infopacket ||


