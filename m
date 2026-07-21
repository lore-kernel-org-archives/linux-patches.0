Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C180638B133;
	Tue, 21 Jul 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657540; cv=none; b=nFPG14n+9hf/K0vT7JYo2bWdlJgvhm34JaLlGWiPDXhJi2HR+K+c/BfKVylDQQDbol2pmKXJgUPixhZtN5aQkCZTNpTZNOPsWIDD5L8i6RK3crbdmp+W15XNycyIQQ+nMhguFPndVsov8F1F21OT9P1fmslDgNMda4dgUz2t/H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657540; c=relaxed/simple;
	bh=GucMc6K3s3x9643FaGCO2N9kNnNk3A/7ruxW9gWlAkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJzC/7WiDutxNMKMlSyh88Hy1mqbPDGoIpIoGrVmlL4X3xmHxjRoeZVMjmgawTX89YZaCzZV49rrmQGm1lxtlF9doPnzpM0ztHpR94khjn6Ygbn+FFW4xLrWdSS6qWF6ITkSEKhA7AA3uTVor8AtbIRxCu9DL57+bQmMdHXf4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toGvXFxm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toGvXFxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2638A1F000E9;
	Tue, 21 Jul 2026 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657539;
	bh=sJtA8ZHxw82KwlSD1UBXnL3n1Xipp1ucM3MNJ3ARLrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toGvXFxmngd1ne/d/aAdrsjbtevtUsRNX5MaNfThjSXc0bmusK+O0Xovv2xjkcLab
	 57qA+BY7sklbTYaOUgAO+emmWQ78Rk7HZldOdVCqob9sNq2pkcIHDvjuXgRMwjd3e2
	 Jwrnek4W4Dz2VXW2v8h/cyA0ZPA+LOFJpQfiIMp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0804/1611] drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
Date: Tue, 21 Jul 2026 17:15:20 +0200
Message-ID: <20260721152533.469773916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8fa5655da368d0306c03e9dc9cda8ae2a7840926 ]

The cleanup tail of kfd_criu_resume_svm() walks
svms->criu_svm_metadata_list and kfree()s each struct criu_svm_metadata
without removing it from the list. The list head is left pointing at
freed kmalloc-96 objects.

A second AMDKFD_IOC_CRIU_OP from the same process re-enters: list_empty()
reads the dangling ->next (use-after-free), the loop walks freed entries,
and each is kfree()'d again (double-free). This is reachable by an
unprivileged render-group user via /dev/kfd with no capabilities required.

Add list_del() before the kfree() so the list is properly emptied. The
list_for_each_entry_safe() iterator already caches the next pointer, so
unlinking during the walk is safe.

Fixes: 2a909ae71871 ("drm/amdkfd: CRIU resume shared virtual memory ranges")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6322d278a298e2c1430b9d2697743d3a04b788b1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 04e4bf41ccf720..202ed1c456320d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4063,6 +4063,7 @@ int kfd_criu_resume_svm(struct kfd_process *p)
 	list_for_each_entry_safe(criu_svm_md, next, &svms->criu_svm_metadata_list, list) {
 		pr_debug("freeing criu_svm_md[]\n\tstart: 0x%llx\n",
 						criu_svm_md->data.start_addr);
+		list_del(&criu_svm_md->list);
 		kfree(criu_svm_md);
 	}
 
-- 
2.53.0



