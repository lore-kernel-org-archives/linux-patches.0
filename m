Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B495D199227;
	Thu,  6 Jun 2024 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683182; cv=none; b=QvGvRd+FZCfWySZa6pj04vWCqxpnRAyfl8t5d7Hqwky0PzHv1UljwfGNzuLtyxocmkTj26Mqrw/dz9ZDF+MYl+RmiyjM7s8Ve/JzMaiyWBywKdbGsVnbQy+gPRPUQ7wR6VlYqK6l5kXXB48H9DpNKlwfBVaG0Su7Mwqzsm52GgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683182; c=relaxed/simple;
	bh=GJxpRTw+pGQVx3DpjL9k54bPx9kcMao/oaNXZofkJHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI2YvPik/rebo8Bv5TpObxlAWXkwXvTAN6RVlGwlO3OWOIP7AUKNPIxBdUbmPFA6Zzlua+FzwPGLQrx7S0sqPd52jeiEKzplJHYWQ8/XKTtjPmDv5/uv4axAR4Cfn+bk4C+CoFk9DJTzUjFbalyNx/9dFY2qGJxN/1qXss6W0Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=heTpkplJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="heTpkplJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95206C32781;
	Thu,  6 Jun 2024 14:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683182;
	bh=GJxpRTw+pGQVx3DpjL9k54bPx9kcMao/oaNXZofkJHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heTpkplJMY28NgrVKdPAbvPhAbeVvOslLecehVF4rsfel3EnFPhXzUi82c/hlbKxV
	 9AOjI22eWCAH0JwpPuXxC0PIFAkIHnN9366IFHssOMMozZjWCIaWE1Hb7EQiW0+MpP
	 dyx5oxvcn29//ssO1xgaVj4/Tj4CPNd6ebD/x2lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lancelot SIX <lancelot.six@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/473] drm/amdkfd: Flush the process wq before creating a kfd_process
Date: Thu,  6 Jun 2024 15:59:46 +0200
Message-ID: <20240606131701.763670649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lancelot SIX <lancelot.six@amd.com>

[ Upstream commit f5b9053398e70a0c10aa9cb4dd5910ab6bc457c5 ]

There is a race condition when re-creating a kfd_process for a process.
This has been observed when a process under the debugger executes
exec(3).  In this scenario:
- The process executes exec.
 - This will eventually release the process's mm, which will cause the
   kfd_process object associated with the process to be freed
   (kfd_process_free_notifier decrements the reference count to the
   kfd_process to 0).  This causes kfd_process_ref_release to enqueue
   kfd_process_wq_release to the kfd_process_wq.
- The debugger receives the PTRACE_EVENT_EXEC notification, and tries to
  re-enable AMDGPU traps (KFD_IOC_DBG_TRAP_ENABLE).
 - When handling this request, KFD tries to re-create a kfd_process.
   This eventually calls kfd_create_process and kobject_init_and_add.

At this point the call to kobject_init_and_add can fail because the
old kfd_process.kobj has not been freed yet by kfd_process_wq_release.

This patch proposes to avoid this race by making sure to drain
kfd_process_wq before creating a new kfd_process object.  This way, we
know that any cleanup task is done executing when we reach
kobject_init_and_add.

Signed-off-by: Lancelot SIX <lancelot.six@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 7f68d51541e8e..5bca6abd55aef 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -823,6 +823,14 @@ struct kfd_process *kfd_create_process(struct file *filep)
 	if (process) {
 		pr_debug("Process already found\n");
 	} else {
+		/* If the process just called exec(3), it is possible that the
+		 * cleanup of the kfd_process (following the release of the mm
+		 * of the old process image) is still in the cleanup work queue.
+		 * Make sure to drain any job before trying to recreate any
+		 * resource for this process.
+		 */
+		flush_workqueue(kfd_process_wq);
+
 		process = create_process(thread);
 		if (IS_ERR(process))
 			goto out;
-- 
2.43.0



