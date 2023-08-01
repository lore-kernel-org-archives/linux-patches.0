Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8981F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0EFC433CC;
	Tue,  1 Aug 2023 09:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882202;
	bh=ze6kmQ3r7UqTDogfJhqBwT2aGGzgxuSSSizaNcVqibU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3yAO+IXbe7m73wvSzS2ZhRceMHdQQYbs6DIfn/YQxIvZ5tqavVklffsC1ULJYbYk
	 MNlw81VbJ1Hku67/fBbHG6xOe1c6L42NVEKrGIrIPpK5zIwYRPM+0C7YqOOzRQF2IL
	 q/3qcKSvscyAfUD0+FSxqKBM/hJjN81ejnM2sYag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 005/228] drm/amd/display: Keep PHY active for dp config
Date: Tue,  1 Aug 2023 11:17:43 +0200
Message-ID: <20230801091923.015668714@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Agustin Gutierrez <agustin.gutierrez@amd.com>

commit 2b02d746c1818baf741f4eeeff9b97ab4b81e1cf upstream.

[Why]
Current hotplug sequence causes temporary hang at the re-entry of the
optimized power state.

[How]
Keep a PHY active when detecting DP signal + DPMS active

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -108,6 +108,11 @@ static int dcn314_get_active_display_cnt
 				stream->signal == SIGNAL_TYPE_DVI_SINGLE_LINK ||
 				stream->signal == SIGNAL_TYPE_DVI_DUAL_LINK)
 			tmds_present = true;
+
+		/* Checking stream / link detection ensuring that PHY is active*/
+		if (dc_is_dp_signal(stream->signal) && !stream->dpms_off)
+			display_count++;
+
 	}
 
 	for (i = 0; i < dc->link_count; i++) {


