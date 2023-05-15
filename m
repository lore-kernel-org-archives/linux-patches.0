Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C851FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE557C433EF;
	Mon, 15 May 2023 16:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169940;
	bh=aD/UzSRZXTpj3ZsYw23CWW6F91Ss7u2tnKo3ViXMz7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCDTWlhqi7n/g2CCxSo+oPN6nzDvRxDART7se5cnuLDK/rxAZMi+V83zMOw2QkJtp
	 nO1cXVDtlUpf0bhXHEhCHgOM12eD5iYgbkqWsjcDHJuTgsKEDpuoo+DSPquQvDYu3g
	 yByEKakVmb7KFqj2FbJav9pSUB7Q0wupV9/GHHVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 190/246] drm/amd/display: Add NULL plane_state check for cursor disable logic
Date: Mon, 15 May 2023 18:26:42 +0200
Message-Id: <20230515161728.317501655@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit d29fb7baab09b6a1dc484c9c67933253883e770a upstream.

[Why]
While scanning the top_pipe connections we can run into a case where
the bottom pipe is still connected to a top_pipe but with a NULL
plane_state.

[How]
Treat a NULL plane_state the same as the plane being invisible for
pipe cursor disable logic.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3385,7 +3385,9 @@ static bool dcn10_can_pipe_disable_curso
 	for (test_pipe = pipe_ctx->top_pipe; test_pipe;
 	     test_pipe = test_pipe->top_pipe) {
 		// Skip invisible layer and pipe-split plane on same layer
-		if (!test_pipe->plane_state->visible || test_pipe->plane_state->layer_index == cur_layer)
+		if (!test_pipe->plane_state ||
+		    !test_pipe->plane_state->visible ||
+		    test_pipe->plane_state->layer_index == cur_layer)
 			continue;
 
 		r2 = test_pipe->plane_res.scl_data.recout;


