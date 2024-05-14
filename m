Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B789513A412;
	Tue, 14 May 2024 10:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683100; cv=none; b=PI1Gr+U3yxJ4iIo+xRIfEU7ErBJt9OCYv3gIXXE9sokGDvMyzpNATXMfRgLf0s1ZiTv/KCdq5sLybIRdonyVwsxo9CGfnC2SWhe6abFT15fLWFfAsVmSVo1FL5HMAL2+g5vhVzVufsqAQxXe9Z17llM5FNL4PzB3VKqojQWAW98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683100; c=relaxed/simple;
	bh=Mf9Zqvi5+nQSjP765QSZzLtzrSwqxDT8euR042qBz2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGIHSSXQM1T2aM8pf2B8OyvnsiwJkEUMbRMxxSvYERQW8Ssy4cpXJWFZP3t87EucbXeld8PzCSINTMtKKXicyWj6Gtyjj+2ot5C4yrOtWop7grtOf3n8gpPUC1zE5f7s5RJgYYz/ZUNHdaLeWES3/zZS/LC2mwpcAq2uihZHSVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi8GDNMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi8GDNMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E9BC2BD10;
	Tue, 14 May 2024 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683100;
	bh=Mf9Zqvi5+nQSjP765QSZzLtzrSwqxDT8euR042qBz2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi8GDNMF+G9MiitGRyeQb05tUslp5PERwsLY7UL7qDFqxQgLXZINN5fdxMWxbYXiq
	 JU/Am2808vR+RPwZswKkGkSpbEdozbT7IONdiE0FLMjPis0gDj5aDOXx0UfvN0WHxs
	 +Frbzd9ivKPERspcPXW1cdr/kXMiG4oBX+zm15VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 166/336] amd/amdkfd: sync all devices to wait all processes being evicted
Date: Tue, 14 May 2024 12:16:10 +0200
Message-ID: <20240514101044.871240121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit d06af584be5a769d124b7302b32a033e9559761d ]

If there are more than one device doing reset in parallel, the first
device will call kfd_suspend_all_processes() to evict all processes
on all devices, this call takes time to finish. other device will
start reset and recover without waiting. if the process has not been
evicted before doing recover, it will be restored, then caused page
fault.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 0a9cf9dfc2243..fcf6558d019e5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -944,7 +944,6 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 {
 	struct kfd_node *node;
 	int i;
-	int count;
 
 	if (!kfd->init_complete)
 		return;
@@ -952,12 +951,10 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 	/* for runtime suspend, skip locking kfd */
 	if (!run_pm) {
 		mutex_lock(&kfd_processes_mutex);
-		count = ++kfd_locked;
-		mutex_unlock(&kfd_processes_mutex);
-
 		/* For first KFD device suspend all the KFD processes */
-		if (count == 1)
+		if (++kfd_locked == 1)
 			kfd_suspend_all_processes();
+		mutex_unlock(&kfd_processes_mutex);
 	}
 
 	for (i = 0; i < kfd->num_nodes; i++) {
@@ -968,7 +965,7 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 {
-	int ret, count, i;
+	int ret, i;
 
 	if (!kfd->init_complete)
 		return 0;
@@ -982,12 +979,10 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 	/* for runtime resume, skip unlocking kfd */
 	if (!run_pm) {
 		mutex_lock(&kfd_processes_mutex);
-		count = --kfd_locked;
-		mutex_unlock(&kfd_processes_mutex);
-
-		WARN_ONCE(count < 0, "KFD suspend / resume ref. error");
-		if (count == 0)
+		if (--kfd_locked == 0)
 			ret = kfd_resume_all_processes();
+		WARN_ONCE(kfd_locked < 0, "KFD suspend / resume ref. error");
+		mutex_unlock(&kfd_processes_mutex);
 	}
 
 	return ret;
-- 
2.43.0



