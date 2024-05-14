Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864E06D1A1;
	Tue, 14 May 2024 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685186; cv=none; b=KBA4Okol2uJ10U5IRgpyK+gywsFhRxwAIgtDvWk3IAEJaevGC8vDCJP6LY4zhvgNyCA8vAmNoMseqq/8880racqvHiEJ4VTq593+Vd8Y8AK++lNS0U3FsZqXDU7jJi9f4jEoYjivjNYSxWAbuCBgcCzRZGyYIgjgSkKu7vmUkZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685186; c=relaxed/simple;
	bh=+KX3YGPU27YC0XnPCrwNLtUJWFIS4w5JYCrA2+1nGl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh6Fe6WR3ZKSs2lHuxw+f+EoCWFBUZe7V7Ce5I3uuuWOdICFQmJcs9Ro7uc9wp5wF2kxQuZ1MHetuFsRBDHOZ4P79mZeUbYHD+79B6Va16cF3J5sBr/tdKNfqqSk7sL+dXC2Sjpi22NLZC1j5w6OFXOpOgQnq3GTJBtaC9Tbauo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM0D9jON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM0D9jON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF6BC2BD10;
	Tue, 14 May 2024 11:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685186;
	bh=+KX3YGPU27YC0XnPCrwNLtUJWFIS4w5JYCrA2+1nGl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM0D9jON1PC3F+yjjFNkZPtF05oSy+lcYYFM8xwSupI4fRq5AhvpWtizzDv6G+pZS
	 c5PIh+OBVdnf4JgCtlGY/BQC2RPpKxULB4f6YEJ11gBCSif/MwxD67egB0mCi3tx9f
	 hFIasfX92h/xLtW4SKNAsn9fw/y3XZThLFOlSN3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/301] amd/amdkfd: sync all devices to wait all processes being evicted
Date: Tue, 14 May 2024 12:17:00 +0200
Message-ID: <20240514101037.882270318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93ce181eb3baa..913c70a0ef44f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -935,7 +935,6 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 {
 	struct kfd_node *node;
 	int i;
-	int count;
 
 	if (!kfd->init_complete)
 		return;
@@ -943,12 +942,10 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
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
@@ -959,7 +956,7 @@ void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
 
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 {
-	int ret, count, i;
+	int ret, i;
 
 	if (!kfd->init_complete)
 		return 0;
@@ -973,12 +970,10 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
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



