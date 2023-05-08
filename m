Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E85E168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5248C4339B;
	Mon,  8 May 2023 09:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539625;
	bh=eCa6CE4qe7ECl4lOL2NwAW3TOnffpc+fFP2se2XH6jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXk9/QE3Gxa8LNxom2/rCqztT9bkUJE2vVnRtvszsiapzHbieK9327yfNsknPyXpb
	 G0rkwZbHuBaYluxMHUGheoLV3oi0v0Emimkmyb65zSPQKs79az2kXKXEnj3tKN4Rsq
	 kylA3YgWxSBT0Xxoj6koZoKukU6aZQfLnsquxQyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/611] drm/amd/display: fix a divided-by-zero error
Date: Mon,  8 May 2023 11:38:47 +0200
Message-Id: <20230508094424.879860695@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 0b5dfe12755f87ec014bb4cc1930485026167430 ]

[Why & How]

timing.dsc_cfg.num_slices_v can be zero and it is necessary to check
before using it.

This fixes the error "divide error: 0000 [#1] PREEMPT SMP NOPTI".

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
index 01fc6a368d2e3..9edd39322c822 100644
--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -924,6 +924,10 @@ bool psr_su_set_y_granularity(struct dc *dc, struct dc_link *link,
 
 	pic_height = stream->timing.v_addressable +
 		stream->timing.v_border_top + stream->timing.v_border_bottom;
+
+	if (stream->timing.dsc_cfg.num_slices_v == 0)
+		return false;
+
 	slice_height = pic_height / stream->timing.dsc_cfg.num_slices_v;
 
 	if (slice_height) {
-- 
2.39.2



