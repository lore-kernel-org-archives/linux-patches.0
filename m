Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D792F2909;
	Mon, 22 Sep 2025 19:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570297; cv=none; b=Jkzq5yE1xHrN8NmyWayCkaydwbSlRybVgpBp2vgV6tw1AWWzhGl/fbtW2ehoGgRPRJbzrlwl5LrqY1fMPMHVVL1pMdF1iqecSDNZ1R1xxij7Z7vknN6rDStyApnLtmrMuPZWbsbRRxPSjBfUe6H7sQcl5qwPK2NPCeX2eAsmLgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570297; c=relaxed/simple;
	bh=TpsX0u1b63KMo5ZPfjn0xUrZ0VD72tZAItLL6DsY+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVbdVTCPKFF03uOs1+22ZfG6kosAO+QwhRjj7Kzm8j0NWBa1sBqSgUVtrCmQenzLXYjc/HNMqCmcl4TqRCxHawM8f5rTQlW6oFy2N8lScC+rvWiBArz+8eTCJZJyOgYlJjvJuiYtw3HL7Og88zKOpejLTHkI1BkCy0VOfzrVJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0AMq7Oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0AMq7Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE68C4CEF0;
	Mon, 22 Sep 2025 19:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570297;
	bh=TpsX0u1b63KMo5ZPfjn0xUrZ0VD72tZAItLL6DsY+FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0AMq7OzaMsL7BBPSWU/b1HGOnI7JYKgnFhhTHnVbT7zdpBoy0OdJ0WhY5Ke9Jd7S
	 1Pl/FtfyL1U/e1yEDeJW+l9CAEvdk4ipJYfXTMTHLIAsNUTRFtMbpdx8ta/3MaLX4j
	 0Yknj6SpEKx+rK9fmhvhfnZ/N5LluTV0ILeFNMQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	David Perry <david.perry@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 094/149] drm/amdkfd: add proper handling for S0ix
Date: Mon, 22 Sep 2025 21:29:54 +0200
Message-ID: <20250922192415.257701476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 2ade36eaa9ac05e4913e9785df19c2cde8f912fb upstream.

When in S0i3, the GFX state is retained, so all we need to do
is stop the runlist so GFX can enter gfxoff.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: David Perry <david.perry@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4bfa8609934dbf39bbe6e75b4f971469384b50b1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |   16 +++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |   12 +++++++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    |   36 +++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -250,16 +250,24 @@ void amdgpu_amdkfd_interrupt(struct amdg
 
 void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool suspend_proc)
 {
-	if (adev->kfd.dev)
-		kgd2kfd_suspend(adev->kfd.dev, suspend_proc);
+	if (adev->kfd.dev) {
+		if (adev->in_s0ix)
+			kgd2kfd_stop_sched_all_nodes(adev->kfd.dev);
+		else
+			kgd2kfd_suspend(adev->kfd.dev, suspend_proc);
+	}
 }
 
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool resume_proc)
 {
 	int r = 0;
 
-	if (adev->kfd.dev)
-		r = kgd2kfd_resume(adev->kfd.dev, resume_proc);
+	if (adev->kfd.dev) {
+		if (adev->in_s0ix)
+			r = kgd2kfd_start_sched_all_nodes(adev->kfd.dev);
+		else
+			r = kgd2kfd_resume(adev->kfd.dev, resume_proc);
+	}
 
 	return r;
 }
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -426,7 +426,9 @@ void kgd2kfd_smi_event_throttle(struct k
 int kgd2kfd_check_and_lock_kfd(void);
 void kgd2kfd_unlock_kfd(void);
 int kgd2kfd_start_sched(struct kfd_dev *kfd, uint32_t node_id);
+int kgd2kfd_start_sched_all_nodes(struct kfd_dev *kfd);
 int kgd2kfd_stop_sched(struct kfd_dev *kfd, uint32_t node_id);
+int kgd2kfd_stop_sched_all_nodes(struct kfd_dev *kfd);
 bool kgd2kfd_compute_active(struct kfd_dev *kfd, uint32_t node_id);
 bool kgd2kfd_vmfault_fast_path(struct amdgpu_device *adev, struct amdgpu_iv_entry *entry,
 			       bool retry_fault);
@@ -516,10 +518,20 @@ static inline int kgd2kfd_start_sched(st
 	return 0;
 }
 
+static inline int kgd2kfd_start_sched_all_nodes(struct kfd_dev *kfd)
+{
+	return 0;
+}
+
 static inline int kgd2kfd_stop_sched(struct kfd_dev *kfd, uint32_t node_id)
 {
 	return 0;
 }
+
+static inline int kgd2kfd_stop_sched_all_nodes(struct kfd_dev *kfd)
+{
+	return 0;
+}
 
 static inline bool kgd2kfd_compute_active(struct kfd_dev *kfd, uint32_t node_id)
 {
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -1501,6 +1501,25 @@ int kgd2kfd_start_sched(struct kfd_dev *
 	return ret;
 }
 
+int kgd2kfd_start_sched_all_nodes(struct kfd_dev *kfd)
+{
+	struct kfd_node *node;
+	int i, r;
+
+	if (!kfd->init_complete)
+		return 0;
+
+	for (i = 0; i < kfd->num_nodes; i++) {
+		node = kfd->nodes[i];
+		r = node->dqm->ops.unhalt(node->dqm);
+		if (r) {
+			dev_err(kfd_device, "Error in starting scheduler\n");
+			return r;
+		}
+	}
+	return 0;
+}
+
 int kgd2kfd_stop_sched(struct kfd_dev *kfd, uint32_t node_id)
 {
 	struct kfd_node *node;
@@ -1518,6 +1537,23 @@ int kgd2kfd_stop_sched(struct kfd_dev *k
 	return node->dqm->ops.halt(node->dqm);
 }
 
+int kgd2kfd_stop_sched_all_nodes(struct kfd_dev *kfd)
+{
+	struct kfd_node *node;
+	int i, r;
+
+	if (!kfd->init_complete)
+		return 0;
+
+	for (i = 0; i < kfd->num_nodes; i++) {
+		node = kfd->nodes[i];
+		r = node->dqm->ops.halt(node->dqm);
+		if (r)
+			return r;
+	}
+	return 0;
+}
+
 bool kgd2kfd_compute_active(struct kfd_dev *kfd, uint32_t node_id)
 {
 	struct kfd_node *node;


