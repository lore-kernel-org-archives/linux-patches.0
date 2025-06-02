Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D11219A9B;
	Mon,  2 Jun 2025 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876969; cv=none; b=MOkSpY8YFQnmrO1YibYEvJcrCtc9hYWKHjprg9QarpZPDH8vegY465TbXPdRoP2SAxAtA2c5I2e5LHiVpz0xYAzlRRGMJ/h43qLiiHkVoh13VascqqJM61cc10/saMfiiRm1N1MOcNAECQXbqegtworLm35XG9m62iXpI5dd+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876969; c=relaxed/simple;
	bh=pmemskVAXDsO5CafZ+yQqz/241LuKQur6jphmlxovvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnSu5mlwLpCw89DBBVgHI1hLQeJaOluNrAtNSo2ilgS7lVR/6v5df6tm8prN9C0GZ9uT6zSww9+WCjpsmh9EcSILyAeJQBxjpjOeI9OQa3NhSAPPaipFIVZJ42ymLUCMR8o4g+dRzACx2EaNuQJZBswK9IGIkSum/MnYfedUra4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaD88U4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaD88U4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8F5C4CEEB;
	Mon,  2 Jun 2025 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876968;
	bh=pmemskVAXDsO5CafZ+yQqz/241LuKQur6jphmlxovvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaD88U4gVrqDrfb56eVq7XUqbSCzxw5uWKA/fLwid0ftnqbxa9z9eCBIFYFCyUtzL
	 UIEDW2WCBEzYG1JIMfcWUR7C3tXVjImyYgoDW/K6ztpf6MLSF3JWi/C+VO3CAMEZOZ
	 Hv4+RJOpmzARxoXvxVIfwR8KKh7xNAS53R0ubkKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/325] drm/amdkfd: KFD release_work possible circular locking
Date: Mon,  2 Jun 2025 15:46:46 +0200
Message-ID: <20250602134325.089991555@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 1b9366c601039d60546794c63fbb83ce8e53b978 ]

If waiting for gpu reset done in KFD release_work, thers is WARNING:
possible circular locking dependency detected

  #2  kfd_create_process
        kfd_process_mutex
          flush kfd release work

  #1  kfd release work
        wait for amdgpu reset work

  #0  amdgpu_device_gpu_reset
        kgd2kfd_pre_reset
          kfd_process_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock((work_completion)(&p->release_work));
                  lock((wq_completion)kfd_process_wq);
                  lock((work_completion)(&p->release_work));
   lock((wq_completion)amdgpu-reset-dev);

To fix this, KFD create process move flush release work outside
kfd_process_mutex.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index bc01c5173ab9a..fd7fecaa9254b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -813,6 +813,14 @@ struct kfd_process *kfd_create_process(struct file *filep)
 	if (thread->group_leader->mm != thread->mm)
 		return ERR_PTR(-EINVAL);
 
+	/* If the process just called exec(3), it is possible that the
+	 * cleanup of the kfd_process (following the release of the mm
+	 * of the old process image) is still in the cleanup work queue.
+	 * Make sure to drain any job before trying to recreate any
+	 * resource for this process.
+	 */
+	flush_workqueue(kfd_process_wq);
+
 	/*
 	 * take kfd processes mutex before starting of process creation
 	 * so there won't be a case where two threads of the same process
@@ -825,14 +833,6 @@ struct kfd_process *kfd_create_process(struct file *filep)
 	if (process) {
 		pr_debug("Process already found\n");
 	} else {
-		/* If the process just called exec(3), it is possible that the
-		 * cleanup of the kfd_process (following the release of the mm
-		 * of the old process image) is still in the cleanup work queue.
-		 * Make sure to drain any job before trying to recreate any
-		 * resource for this process.
-		 */
-		flush_workqueue(kfd_process_wq);
-
 		process = create_process(thread);
 		if (IS_ERR(process))
 			goto out;
-- 
2.39.5



