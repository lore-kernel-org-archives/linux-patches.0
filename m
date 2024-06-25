Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015E5FBEF;
	Tue, 25 Jun 2024 09:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308224; cv=none; b=X13neNRbDLuWulAuorfPFwrO8otTY1LRelGQDCe4CAevV1RlEhka3CCEmycHcpLGa8N0oxKTKS8pEYy5illAb6y2/Lx0MBqHda/qsCumtzMxhgBj00L+VUVUr5fPM12o/CYr5yT0H+J8vdHBuA2widtqohjT0wTgo9LW8w9MxJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308224; c=relaxed/simple;
	bh=ATUiry40TwbchxJvfMvb5loQtXfgTme7pU6ABsTjWGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTN8ZQMEpLr6KVlDkJgN5Phibl/Um4WNJDkelZgeWEHl2Oi/5UFuX2ypNu6f/aBtltNJevV+KEmQvxxFWdpjdbBlBMqpb/wO10kV2zShU1lO5obzxkN1aZK0Nz45Vjx6ldPxsgJNdBfo7IByey0zh6z9pYehsHjEtGYl/JtBPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojVl4XS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojVl4XS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A53BC32781;
	Tue, 25 Jun 2024 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308223;
	bh=ATUiry40TwbchxJvfMvb5loQtXfgTme7pU6ABsTjWGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojVl4XS17H96FaFQORnVBL1x7wFi59vrS2PJV8i7nHFbrVGFQuq+uddBOOYFTJo6E
	 8pfy1nJrPqy+r2zkjPFSlS239Bw8rwslAJbxhJtwLwtRrgPuCd+w1YgJn12tp3X1wu
	 pXt53ybQEb/XFA/Mq8uRf04Vqtjy3lqscH+aSUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duncan Ma <duncan.ma@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 048/250] drm/amd/display: Workaround register access in idle race with cursor
Date: Tue, 25 Jun 2024 11:30:06 +0200
Message-ID: <20240625085549.905335452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit b5b6d6251579a29dafdad25f4bc7f3ff7bfd2c86 ]

[Why]
Cursor update can be pre-empted by a request for setting target flip
submission.

This causes an issue where we're in the middle of the exit sequence
trying to log to DM, but the pre-emption starts another DMCUB
command submission that requires being out of idle.

The DC lock aqusition can fail, and depending on the DM/OS interface
it's possible that the function inserted into this thread must not fail.

This means that lock aqusition must be skipped and exit *must* occur.

[How]
Modify when we consider idle as active. Consider it exited only once
the exit has fully finished.

Consider it as entered prior to actual notification.

Since we're on the same core/thread the cached values are coherent
and we'll see that we still need to exit. Once the cursor update resumes
it'll continue doing the double exit but this won't cause a functional
issue, just a (potential) redundant operation.

Reviewed-by: Duncan Ma <duncan.ma@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 23 +++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 6083b1dcf050a..a72e849eced3f 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -1340,16 +1340,27 @@ void dc_dmub_srv_apply_idle_power_optimizations(const struct dc *dc, bool allow_
 	 * Powering up the hardware requires notifying PMFW and DMCUB.
 	 * Clearing the driver idle allow requires a DMCUB command.
 	 * DMCUB commands requires the DMCUB to be powered up and restored.
-	 *
-	 * Exit out early to prevent an infinite loop of DMCUB commands
-	 * triggering exit low power - use software state to track this.
 	 */
-	dc_dmub_srv->idle_allowed = allow_idle;
 
-	if (!allow_idle)
+	if (!allow_idle) {
 		dc_dmub_srv_exit_low_power_state(dc);
-	else
+		/*
+		 * Idle is considered fully exited only after the sequence above
+		 * fully completes. If we have a race of two threads exiting
+		 * at the same time then it's safe to perform the sequence
+		 * twice as long as we're not re-entering.
+		 *
+		 * Infinite command submission is avoided by using the
+		 * dm_execute_dmub_cmd submission instead of the "wake" helpers.
+		 */
+		dc_dmub_srv->idle_allowed = false;
+	} else {
+		/* Consider idle as notified prior to the actual submission to
+		 * prevent multiple entries. */
+		dc_dmub_srv->idle_allowed = true;
+
 		dc_dmub_srv_notify_idle(dc, allow_idle);
+	}
 }
 
 bool dc_wake_and_execute_dmub_cmd(const struct dc_context *ctx, union dmub_rb_cmd *cmd,
-- 
2.43.0



