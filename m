Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063554;
	b=kS93cxqAd+AwC2VPX7WpZ+tBU/95V4F6RQ8BMXeFYNwdLM1QnlZLV6NuP3VD2XFzR2mT
	 qFa+XtevKmuWlEgVlBxuTQORrOlIcmkXUhXmxMRnrXaoAHPT7WVw3R2vZQBNDdwudAOEp
	 pvZIqI6Ngdqxqs4qYSjxPHq/EgIApnCMtpAvjS52JODq7zzuLghj/Lb3bhZPII3Uk9e+x
	 KJmLojVCSN2Sd44z+xLIysm1Ps0VEujyLK+NwnX4GOGsdWuZMMUJHhDtJBGPcy/morfxg
	 zsMCvfhf+jcKR8+GLrtdwGJMyEFRbLNMFdhPvWHBHRtlg1KAVvDNWVA5x9a+ivxpEnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zA03uRruqUA+9yeF88H8oNrmlPZZ41QfJsyuZgIR0k=;
	b=cytSDYi7o4Ta/pk2SCcn9zhvQ/zJDsfzUaIit89F65cXri3JzU9t6vubVpYhyNeKOJuY
	 x04BvAUzAJS0xGFYcQ7qog1DannxUJrTJFVLsNkx0hgmDQzVCSq19jMru9sIpLJXYq2AL
	 gMH1i85EJKOx1hJL4sDu/YewOpDR/19o5I0iscKJawGuYtDbmk4lpGMXp+wkV2bV3FSdo
	 tCn6TxfTkd2634tI+dzgZEGTeqvJlpBd+Bmt8x3ANL30+qCDBbwVtEihGhsuF9EiTc3Xr
	 6oABO/9yUXC6/o/S5dGo2iWz01/ggCIe1goAfNbBgOQSgVYEM8s1rOgL3Hzz9CGHnnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aUInpos;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC916082BCF;
	Sat,  7 Nov 2026 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0aUInpos
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF17F1F008A6;
	Sat,  7 Nov 2026 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063554;
	bh=5zA03uRruqUA+9yeF88H8oNrmlPZZ41QfJsyuZgIR0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0aUInpos9LWHzZ+x8q0pC4X9HK//IYVnKZtJ+qcdC1DTTmhxfciPNK6mu5MsGdXfe
	 a3TruakM8f85qvfPxgPLuuFh92pNCZqAoPdfd2KgPltb2wjE1oUKHDooMI3ZTQdPjY
	 jJ5FVWC2jwpVne/zyxvgmW0Z3XaOdlEEGFdJGLkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	William Palacek <William.Palacek@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 681/869] drm/amdkfd: wait for a GPU reset before freeing a BO
Date: Sat,  7 Nov 2026 08:56:03 -0500
Message-ID: <20261107134916.154321674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 47d799a718439764432d8ef3a0952af45f025f76 ]

When a GPU reset takes the reset domain, KFD eviction cannot unmap
user queues: execute_queues_cpsch() fails its trylock with -EIO, so
the queues keep running until the ASIC is reset. The TLB flush is also
skipped while the reset is in progress. If the process unmaps and frees
a BO in that window, its pages are released while a queue can still
access them through stale translations.

On MI300X, munmap() then crashes in free_swap_cache() on a small bogus
page pointer in its mmu_gather batch page:

  BUG: unable to handle page fault for address: 0000000000002900
  RIP: 0010:free_swap_cache+0x5/0xb0
  Call Trace:
   free_pages_and_swap_cache+0x3a/0x60
   tlb_batch_pages_flush+0x43/0x80
   tlb_flush_mmu+0x3d/0x110
   zap_pte_range+0x80d/0xcd0
   ...
   do_vmi_align_munmap+0x3e8/0x5b0
   do_vmi_munmap+0xdf/0x190
   __vm_munmap+0xad/0x180
   __x64_sys_munmap+0x1b/0x30

In a traced crash the bogus pointer was the read pointer value of an SDMA
queue the process had just destroyed, at the read pointer's page offset:
the queue's writeback landed in its freed rptr page after the page was
reused as the batch page.

commit f0b4440cdc18 ("drm/amdkfd: Fix mode1 reset crash issue") fixed
this race on process exit by waiting for the reset to complete before
freeing the process's BOs. Free through the ioctl has the same race.
Wait for the reset there too, using the same helper.

Fixes: 9c33e5fd4fb6 ("drm/amdgpu: fix locking scope when flushing tlb")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: William Palacek <William.Palacek@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 06ff8ce77726b15a98fcc285dd6005cb3f48558b)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 3 +++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    | 1 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index c224d78a770a1..1ec77554da503 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1222,6 +1222,9 @@ static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 		goto err_unlock;
 	}
 
+	/* Queues a reset could not stop may still access the buffer */
+	kfd_process_wait_gpu_reset_complete(p);
+
 	ret = amdgpu_amdkfd_gpuvm_free_memory_of_gpu(pdd->dev->adev,
 				(struct kgd_mem *)mem, pdd->drm_priv, &size);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index ef1afeaa8d85d..1f5f528188980 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1084,6 +1084,7 @@ void kfd_unref_process(struct kfd_process *p);
 int kfd_process_evict_queues(struct kfd_process *p, uint32_t trigger);
 int kfd_process_restore_queues(struct kfd_process *p);
 void kfd_suspend_all_processes(void);
+void kfd_process_wait_gpu_reset_complete(struct kfd_process *p);
 int kfd_resume_all_processes(void);
 
 struct kfd_process_device *kfd_process_device_data_by_id(struct kfd_process *process,
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 0b760aab11c6f..1c591953cc80d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1144,7 +1144,7 @@ static void kfd_process_remove_sysfs(struct kfd_process *p)
 /*
  * If any GPU is ongoing reset, wait for reset complete.
  */
-static void kfd_process_wait_gpu_reset_complete(struct kfd_process *p)
+void kfd_process_wait_gpu_reset_complete(struct kfd_process *p)
 {
 	int i;
 
-- 
2.53.0



