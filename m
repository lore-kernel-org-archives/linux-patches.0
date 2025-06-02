Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66571EA65;
	Mon,  2 Jun 2025 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874767; cv=none; b=svCihksyWXcyYBZKx2UBzODulguV9hnOdjGVWhjpqNk8m/+/C2sG+ZqV/i7cLwDjlqbEaMd4dOfxmLJyZvVubJceO89VFJMn3nxvN1NnBh/+GZZ6v10j0RsoZL6kxIoHPsMTR5GYHfXi3zzgqLvzYnLV3CnZeHdJJHmtZDlUzCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874767; c=relaxed/simple;
	bh=EU6Yj+QvGnd7t6yj4chXgb665ZAIOGl7IIRfwvY/2Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qH/H/R5GoqRcX36rBVYVIzSld/IvnQV1N2lXL28Tcyt+Z8XIdZQA5i69baVhuWKZIhOylKZubWgIXKz+oFyQiGyEvCuLjf/GB/LlbzD0vZ6a2PZSMWi0wTgyaCIWAzh2CLZPedIrVJi1bMjZ6zkdh6RBOAMjAZtSHx4NEkNLsxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMo5IoyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMo5IoyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543A1C4CEEB;
	Mon,  2 Jun 2025 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874766;
	bh=EU6Yj+QvGnd7t6yj4chXgb665ZAIOGl7IIRfwvY/2Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMo5IoyRaqaOO8AeZZkyQ1CjSksBM7wdxTWxtZQWY4G4urtwovZVD4T6rjxMnq8ok
	 7y+xzF/K20xP28sVlUBgQVBz9E/Upy/T9L2Vwl0pzFkneaT4cVBAhkrI3MkhsRLhCw
	 19blRv0tqXq9S+ky7eqC4iOWbUHQPIpmJPQUgLic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/204] drm/amdkfd: KFD release_work possible circular locking
Date: Mon,  2 Jun 2025 15:47:42 +0200
Message-ID: <20250602134300.714892944@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 662e4d973f13a..b07deeb987475 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -277,6 +277,14 @@ struct kfd_process *kfd_create_process(struct file *filep)
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
@@ -289,14 +297,6 @@ struct kfd_process *kfd_create_process(struct file *filep)
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



