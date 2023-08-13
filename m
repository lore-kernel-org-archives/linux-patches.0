Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD63E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6799CC433C7;
	Sun, 13 Aug 2023 21:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962496;
	bh=Y4ZlPZHJBwFnZkix0rXiDMMLsEtVOyrOMTwhz/E39ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbVS349INl5g/FgLIUjLjp4nV+DLv7JkDxyxIj2Q8uLTpZ6rp0aaW3K1+xaKPzzHl
	 9ktcdA+bHCneragD7v0djR5/Xc/ZErD47fc/afakDFUN81LVCsf+WihsL35C+N6ZYH
	 k72Ey6lapENL4hO6NYPAV9BHmH5qdEg8leOUi92w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 050/149] drm/amd/display: trigger timing sync only if TG is running
Date: Sun, 13 Aug 2023 23:18:15 +0200
Message-ID: <20230813211720.314143141@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 6066aaf74f510fc171dbe9375153aee2d60d37aa upstream

[Why&How]
If the timing generator isnt running, it does not make sense to trigger
a sync on the corresponding OTG. Check this condition before starting.
Otherwise, this will cause error like:

*ERROR* GSL: Timeout on reset trigger!

Fixes: dc55b106ad47 ("drm/amd/display: Disable phantom OTG after enable for plane disable")
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ NOTE: This is also 5f9f97c02dd2 ("drm/amd/display: trigger timing sync
  only if TG is running") ]
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -2284,6 +2284,12 @@ void dcn10_enable_timing_synchronization
 		opp = grouped_pipes[i]->stream_res.opp;
 		tg = grouped_pipes[i]->stream_res.tg;
 		tg->funcs->get_otg_active_size(tg, &width, &height);
+
+		if (!tg->funcs->is_tg_enabled(tg)) {
+			DC_SYNC_INFO("Skipping timing sync on disabled OTG\n");
+			return;
+		}
+
 		if (opp->funcs->opp_program_dpg_dimensions)
 			opp->funcs->opp_program_dpg_dimensions(opp, width, 2*(height) + 1);
 	}


