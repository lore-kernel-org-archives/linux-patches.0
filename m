Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AC8364024;
	Tue, 16 Dec 2025 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887783; cv=none; b=f3Dsygec85paa9ijzwAO1t/IaGeNZUJyk/hKp0bxoQnSzyhJijdtjemtjc+qHcr0gxxIgvOiIDpaRWvEMBJD8eg/1Q6j3I1N9BALZeqby8K/Y62YI7iAj0AbAstzepOHXYaGLpmFkA2qrYGhjZivjacQzhetMRl/FHCLpryvkT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887783; c=relaxed/simple;
	bh=RHVwxkYpkLjdEIOWTRzH8MQtpIotqrGoq+aeK/JRfJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uis7KNCWEiuVNdnMSB2AQcNNaQB2kJG+qOPK2UQMIie5Rf2TJxpCj2LInzmbSvuNT+A8H02NNEyJQUF2WAcJzMQmFQxk45ct+5Y4SMuAJxWWM4EjiEdxIVIfj3xcpT0EoV6MzJc8jC42XWuJRz7opLZ4dYhOBJlqJYFk6H3Fzhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4D4r6pR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4D4r6pR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC007C4CEF1;
	Tue, 16 Dec 2025 12:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887783;
	bh=RHVwxkYpkLjdEIOWTRzH8MQtpIotqrGoq+aeK/JRfJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4D4r6pRpHkHlRfdecdLh/H7XaLyFff7+BBZ8K6tts/z1hiSfKOBvi8yWqCNlwhkI
	 0FDCVGx7NcSTkkOr/DVjEN0pxKMagSj4XiYs9vzMNxK+GlQ7tvyQWvqW5/zFp0azpM
	 xsB0qxu9eLB7g8s1u/ay6OcfnG8yc6BlagwJmzhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crystal Wood <crwood@redhat.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/614] tools/rtla: Fix --on-threshold always triggering
Date: Tue, 16 Dec 2025 12:11:43 +0100
Message-ID: <20251216111413.538618151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit 417bd0d502f90a2e785e7299dae4f248b5ac0292 ]

Commit 8d933d5c89e8 ("rtla/timerlat: Add continue action") moved the
code performing on-threshold actions (enabled through --on-threshold
option) to inside the RTLA main loop.

The condition in the loop does not check whether the threshold was
actually exceeded or if stop tracing was requested by the user through
SIGINT or duration. This leads to a bug where on-threshold actions are
always performed, even when the threshold was not hit.

(BPF mode is not affected, since it uses a different condition in the
while loop.)

Add a condition that checks for !stop_tracing before executing the
actions. Also, fix incorrect brackets in hist_main_loop to match the
semantics of top_main_loop.

Fixes: 8d933d5c89e8 ("rtla/timerlat: Add continue action")
Fixes: 2f3172f9dd58 ("tools/rtla: Consolidate code between osnoise/timerlat and hist/top")
Reviewed-by: Crystal Wood <crwood@redhat.com>
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20251007095341.186923-1-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/common.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/tracing/rtla/src/common.c b/tools/tracing/rtla/src/common.c
index 2e6e3dac1897f..b197037fc58b3 100644
--- a/tools/tracing/rtla/src/common.c
+++ b/tools/tracing/rtla/src/common.c
@@ -268,6 +268,10 @@ int top_main_loop(struct osnoise_tool *tool)
 			tool->ops->print_stats(tool);
 
 		if (osnoise_trace_is_off(tool, record)) {
+			if (stop_tracing)
+				/* stop tracing requested, do not perform actions */
+				return 0;
+
 			actions_perform(&params->threshold_actions);
 
 			if (!params->threshold_actions.continue_flag)
@@ -315,20 +319,22 @@ int hist_main_loop(struct osnoise_tool *tool)
 		}
 
 		if (osnoise_trace_is_off(tool, tool->record)) {
+			if (stop_tracing)
+				/* stop tracing requested, do not perform actions */
+				break;
+
 			actions_perform(&params->threshold_actions);
 
-			if (!params->threshold_actions.continue_flag) {
+			if (!params->threshold_actions.continue_flag)
 				/* continue flag not set, break */
 				break;
 
-				/* continue action reached, re-enable tracing */
-				if (tool->record)
-					trace_instance_start(&tool->record->trace);
-				if (tool->aa)
-					trace_instance_start(&tool->aa->trace);
-				trace_instance_start(&tool->trace);
-			}
-			break;
+			/* continue action reached, re-enable tracing */
+			if (tool->record)
+				trace_instance_start(&tool->record->trace);
+			if (tool->aa)
+				trace_instance_start(&tool->aa->trace);
+			trace_instance_start(&tool->trace);
 		}
 
 		/* is there still any user-threads ? */
-- 
2.51.0



