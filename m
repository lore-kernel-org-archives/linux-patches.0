Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70138403EB9;
	Tue, 21 Jul 2026 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654866; cv=none; b=Ghc3MobLjdV0GPaD57d7y7mVNtzmWxe/TTHvZtaM7Xtx+wruTjPbbVtpNCuxeu0cZhXjGTQ2g1NCsXP6xN2BMDy+Sj5do8D2VmcVw3Iu5yO1y1NMbRdThwVnD0LTpw5elULytSm4ozENaFuhuq9QJs3tMehmDYwTisH45FBfaAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654866; c=relaxed/simple;
	bh=ODzzi1kqGILyk8aE9QxxleZLWx8uqvDiLhHrsiT4Ot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHG8a4NXNZrA7v6w9TMThbM5iBZ5Bt4VYJWtLNJTRNMIJMdTNgC3pRI8zJhKs4OKXbqhQmISdRHP/CycgI7O8OoeyAxVYdNR+CePM1bUYkTOEfgS1wWe0yXJKE41o2gYGFEjAE4azqTJ4Ur9DYFuOkpKiEm8rBBs2iOUZ7XUNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpVNPNWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpVNPNWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9621F00A3A;
	Tue, 21 Jul 2026 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654865;
	bh=ilqdOQaMfO0OjAAzSpOgq75JEb0vY5ifUdg25tr3xzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpVNPNWqF1EUWA+r/hs+4dCZjpC1gtlnBWedtqK5eGA1q2tncIV+qFsjGdMBVuLyq
	 pWhYF+V8lb6puvR3J/uvqQoIH7/I3bWCTcJpRzwqSar73LMkJH8DkVYm9hZzxvco+s
	 BjZZinIqdeLC2YuLqBWWdxeOSsyi3AYoQdijsgFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.1 1867/2077] accel/amdxdna: reject user command submission without a command BO
Date: Tue, 21 Jul 2026 17:25:40 +0200
Message-ID: <20260721152636.768685558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 261c1fe3327ad24508f54552c6366e3e4db82c15 upstream.

amdxdna_drm_submit_execbuf() passes the user-supplied command BO handle
straight into amdxdna_cmd_submit() with drv_cmd == NULL. When the handle
is AMDXDNA_INVALID_BO_HANDLE (0), the block that fetches job->cmd_bo is
skipped, leaving it NULL, and no check rejects it on the user path (the
!job->cmd_bo guard lives inside the != INVALID branch).

The job is then armed and pushed to the DRM scheduler.
aie2_sched_job_run() takes the drv_cmd == NULL path and calls
amdxdna_cmd_set_state(job->cmd_bo) -> amdxdna_gem_vmap(NULL) ->
to_gobj(NULL)->dev, a NULL pointer dereference in the drm_sched worker.
A process with access to the accel node on a system with a probed AMD NPU
can trigger a kernel oops with a single AMDXDNA_EXEC_CMD ioctl
(cmd_handles = 0).

Only internal driver commands (SYNC_DEBUG_BO / ATTACH_DEBUG_BO)
legitimately pass AMDXDNA_INVALID_BO_HANDLE, and they always set drv_cmd.
Reject the invalid handle for user submissions (drv_cmd == NULL) at the
submit choke point so every user path is covered.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Cc: stable@vger.kernel.org
Found by 0sec automated security-research tooling (https://0sec.ai).
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260713173030.87541-2-doruk@0sec.ai
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -513,6 +513,16 @@ int amdxdna_cmd_submit(struct amdxdna_cl
 			ret = -EINVAL;
 			goto free_job;
 		}
+	} else if (!drv_cmd) {
+		/*
+		 * Only internal driver commands (drv_cmd != NULL) may omit a
+		 * command BO. A user command submission with the invalid handle
+		 * would leave job->cmd_bo NULL and later fault when the scheduler
+		 * dereferences it in amdxdna_cmd_set_state().
+		 */
+		XDNA_DBG(xdna, "Command BO handle required for user submission");
+		ret = -EINVAL;
+		goto free_job;
 	}
 
 	ret = amdxdna_arg_bos_lookup(client, job, arg_bo_hdls, arg_bo_cnt);


