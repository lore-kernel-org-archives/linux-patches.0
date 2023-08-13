Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F9E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9D5C433C8;
	Sun, 13 Aug 2023 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962483;
	bh=S7kcNkwOY/aLyZ5rLqk9v5gRpyt1q4Um99CFQVNDPW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVd58UsRiIz6GBsT754gzxfW//SRf1AhWVF4Ge2L6rdi7Jd55Dzr5HoYM1HMsxWB9
	 ij9tIoslD8N1amGymMrjqHGqQXHtPeHajK5n99v12WSqBv19TjgMEzXAiMzOQSWcV0
	 dpBtGKRa5ePwcjzfejuK3ZN6VhOG1c5x5Jgko/sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 045/149] drm/amd/display: Avoid ABM when ODM combine is enabled for eDP
Date: Sun, 13 Aug 2023 23:18:10 +0200
Message-ID: <20230813211720.164608726@linuxfoundation.org>
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

commit 7fffb03b4045c862f904a88b852dc509c4e46406 upstream

ODM to combine on the eDP panel with ABM causes the color difference to
the panel since the ABM module only sets one pipe. Hence, this commit
blocks ABM in case of ODM combined on eDP.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Co-developed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1996,9 +1996,19 @@ enum dc_status dc_commit_streams(struct
 	res = dc_commit_state_no_check(dc, context);
 
 	for (i = 0; i < stream_count; i++) {
-		for (j = 0; j < context->stream_count; j++)
+		for (j = 0; j < context->stream_count; j++) {
 			if (streams[i]->stream_id == context->streams[j]->stream_id)
 				streams[i]->out.otg_offset = context->stream_status[j].primary_otg_inst;
+
+			if (dc_is_embedded_signal(streams[i]->signal)) {
+				struct dc_stream_status *status = dc_stream_get_status_from_state(context, streams[i]);
+
+				if (dc->hwss.is_abm_supported)
+					status->is_abm_supported = dc->hwss.is_abm_supported(dc, context, streams[i]);
+				else
+					status->is_abm_supported = true;
+			}
+		}
 	}
 
 fail:


