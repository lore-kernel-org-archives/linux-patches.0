Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83EC168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scpoaqm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F6EC433C9;
	Mon, 23 Oct 2023 11:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061725;
	bh=K78yTwosjl+f86KbOQghVYkEyD68bZIqMJQI2dyzOUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scpoaqm0cHSQjJzVX/v+eVut4TPGWstNScZSf38JBJFoGee6MfWJ9DziIbkWNy6Ke
	 qliA2D7tiVCBNvdmi3slR9RB9uIknRVT8SDJBSoFNbkDK90Btsp6ZSADPXCw08VPMO
	 REX4Cvx7HiK0P5D2/dcgIqOC/4uRAM7HzH5T0FP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <yongqiang.sun@amd.com>,
	Tony Cheng <Tony.Cheng@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/202] drm/amd/display: only check available pipe to disable vbios mode.
Date: Mon, 23 Oct 2023 12:57:30 +0200
Message-ID: <20231023104830.718209216@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <yongqiang.sun@amd.com>

[ Upstream commit 850d2fcf3e346a35e4e59e310b867e90e3ef8e5a ]

[Why & How]
1. only need to check first ODM pipe.
2. Only need to check eDP which is on.

Signed-off-by: Yongqiang Sun <yongqiang.sun@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 23645bca9830 ("drm/amd/display: Don't set dpms_off for seamless boot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 099542dd31544..9cf287124fe4c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -862,12 +862,16 @@ static void disable_vbios_mode_if_required(
 		if (stream == NULL)
 			continue;
 
+		// only looking for first odm pipe
+		if (pipe->prev_odm_pipe)
+			continue;
+
 		if (stream->link->local_sink &&
 			stream->link->local_sink->sink_signal == SIGNAL_TYPE_EDP) {
 			link = stream->link;
 		}
 
-		if (link != NULL) {
+		if (link != NULL && link->link_enc->funcs->is_dig_enabled(link->link_enc)) {
 			unsigned int enc_inst, tg_inst = 0;
 			unsigned int pix_clk_100hz;
 
-- 
2.40.1



