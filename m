Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185863B3885;
	Mon, 23 Mar 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279162; cv=none; b=LpE2ZwE714UHzOCqoCu5GLKeVSf3QqprFlavyZoC4XGIHthS0KbSuXiBRaElb3ZYhBPcort9WFSh+DYvVwlOWAKF05XjLefnjoXfDeK4rRUQVZbdVu+EKyv4jxGAA8Jf7Fyc5v+md2L94+8nP2jh7hczESlsZpc1NUISADN0dsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279162; c=relaxed/simple;
	bh=OOTP3VRfdf84FyBb6FaF3qj11jRgB0r6y9/4o2joDJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNR2gEjKKCXc/r4KOD/KHT3Wud1wqU/fKZCbEjXUYh3OH2ss8SZcf2yTt18SpiF+6TI3Ur1NF2KV4V1aODiHQJBhKhtVxBBdKw0GBT0XEQj5EaBoyLlll+ksI70kIvReDF/vi9MCBQHAUkUQwA5SmlslLieD0+hWHHo2Lpm5REA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyyeTsFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyyeTsFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928BEC4CEF7;
	Mon, 23 Mar 2026 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279162;
	bh=OOTP3VRfdf84FyBb6FaF3qj11jRgB0r6y9/4o2joDJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyyeTsFIubZuu+DZVfkfzjgVDLmBScMzPJw+skgvElo0c8iVloqbHdnEJoDWnPgFz
	 Yy9gQ9Rp1KQM50JgaR6tE7dXqp4Ku+vOeSGX9YWeRIbDmHZLzhh1yOIz8fnWBbwnyn
	 /KHJVcQmI8yx13sRHWcdb4YGoaxpUAClwYQseEkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiarOnce <liaronce@hotmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 495/567] drm/amd/display: Wrap dcn32_override_min_req_memclk() in DC_FP_{START, END}
Date: Mon, 23 Mar 2026 14:46:55 +0100
Message-ID: <20260323134546.277477343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit ebe82c6e75cfc547154d0fd843b0dd6cca3d548f upstream.

[Why]
The dcn32_override_min_req_memclk function is in dcn32_fpu.c, which is
compiled with CC_FLAGS_FPU into FP instructions.  So when we call it we
must use DC_FP_{START,END} to save and restore the FP context, and
prepare the FP unit on architectures like LoongArch where the FP unit
isn't always on.

Reported-by: LiarOnce <liaronce@hotmail.com>
Fixes: ee7be8f3de1c ("drm/amd/display: Limit DCN32 8 channel or less parts to DPM1 for FPO")
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 25bb1d54ba3983c064361033a8ec15474fece37e)
Cc: stable@vger.kernel.org
[ dropped missing `dcn32_override_min_req_dcfclk()` call since ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1872,7 +1872,9 @@ bool dcn32_validate_bandwidth(struct dc
 
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
+	DC_FP_START();
 	dcn32_override_min_req_memclk(dc, context);
+	DC_FP_END();
 
 	BW_VAL_TRACE_END_WATERMARKS();
 


