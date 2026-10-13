Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF784F3910;
	Tue, 13 Oct 2026 12:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893589; cv=none; b=XeGPCF9Lc9gfyBH8H3Ntx92S9rg1vskGLtgsr5Wqtn3egH7tiLRjA7G1ER4UB7i87YLiOulyWp8vs1WhKbbt0FqXK6oYuMLaSiluKCBCBAP7pp7s+s9VDzojgw79cCzGR5srH0cYFDlKC2LUUfLWOCpjFIFWQwu9OkbE2zXi0sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893589; c=relaxed/simple;
	bh=JYA8xKov1pjuJZWkT6qO/bL955ocfExjUICU7grNsow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIBAmhG7jx4oXXS2Z4EIlNihBVcuFq78pysb5i5+8tfkccGK86LWcsXUWaUQDvK6CS6Q/WmtrWwDaoBtWE6YhgnW0rbzHIZKypbwKAXbJPs1b/vIM3FnPT5gSvbEm79WoLbA/30ViUKXDtrPHhZ6iBAK7PlxASqF8CeTVZUMSoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XPpGZ5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XPpGZ5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF2C1F000FF;
	Tue, 13 Oct 2026 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893588;
	bh=N0xFhaPi4p7ChYd+llcKIiaGiYp8DE0EGnV5gwWCTtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XPpGZ5CAwqScMdR4FuY9569tdB/wWIDVu3J+31TfntaHWA2Nei+rzOFl0a8oX+Ar
	 N+xxxB0620Jn2XlM9yfxg7mukqgl6nyQ536OMjgH6v+KVqOtPiyNMDwDQYbhgemsJO
	 0Lk5IJ0snj5zARLpPqP7PHTP58cCF7nmf90EHyYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/621] accel/amdxdna: reject user command submission without a command BO
Date: Tue, 13 Oct 2026 13:34:31 +0200
Message-ID: <20261013112927.411514817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit 261c1fe3327ad24508f54552c6366e3e4db82c15 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.c b/drivers/accel/amdxdna/amdxdna_ctx.c
index 6668fc0f250f4..db94a8d0e4bb0 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.c
+++ b/drivers/accel/amdxdna/amdxdna_ctx.c
@@ -423,7 +423,14 @@ int amdxdna_cmd_submit(struct amdxdna_client *client,
 			goto free_job;
 		}
 	} else {
-		job->cmd_bo = NULL;
+		/*
+		 * A command submission with the invalid handle would leave
+		 * job->cmd_bo NULL and later fault when the scheduler
+		 * dereferences it in amdxdna_cmd_set_state().
+		 */
+		XDNA_DBG(xdna, "Command BO handle required for user submission");
+		ret = -EINVAL;
+		goto free_job;
 	}
 
 	ret = amdxdna_arg_bos_lookup(client, job, arg_bo_hdls, arg_bo_cnt);
-- 
2.53.0



