Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1FE415F1A;
	Tue, 21 Jul 2026 19:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662776; cv=none; b=h0zh/FF1QnyOIgYXYAZBQnjetGkh+6kCfgd3IwZ0Y7wMpLLJkLibM1r3+hi9i1tZLaGT8bbC7fonaOD9+7BK9EUD6xua5ydduYtZV1PuBc3WO00JodJUls7WnJvAqzU/OpjYE7WFk+FYGfjYOd0EBfm0mlgj47JvQWlA7vc92tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662776; c=relaxed/simple;
	bh=h2XI8j3N6FpIGzXWi0VcbaZ4wz6xsjcr1dng+aUyltc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTOT9KzUpheZ+aNlvAwJWb7FD0N9ak/ukUy3U8FLKDRgwBnpi/IsO3+f2zWpWbwbBUItjSPSyNisoqZH/yyutM4gVSkAEsVBr5nxne0VVzWR4qVOQBWxLZmFIsVs0OIICcqVmmYJdfYnDCi1wxTwazofdkMUM4MIK7jAaQqUBVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0kuGoHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0kuGoHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE6D1F000E9;
	Tue, 21 Jul 2026 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662774;
	bh=1Op6r2efhDhiuF1UZCmusZJdHV3pZSLJuGkdME2ksAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0kuGoHFWX09zCa86M4BisS2MlOZbsAta1YzhSyDYWgOmZjEI1in77dZZ56QnCBwm
	 V9536mnYi3RlvEG5deywFnNE3MYofUPgnyLNSyqYE2EPR3ymx38FfaLWL7JtpZvd1k
	 HqcyfntOExmoc6VhuswqoLlEkksPUtKHtzC++yeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0572/1276] drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
Date: Tue, 21 Jul 2026 17:16:55 +0200
Message-ID: <20260721152458.917508730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 31b6903e6b746a..08fcc94c0a2c35 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4051,6 +4051,7 @@ int kfd_criu_resume_svm(struct kfd_process *p)
 	list_for_each_entry_safe(criu_svm_md, next, &svms->criu_svm_metadata_list, list) {
 		pr_debug("freeing criu_svm_md[]\n\tstart: 0x%llx\n",
 						criu_svm_md->data.start_addr);
+		list_del(&criu_svm_md->list);
 		kfree(criu_svm_md);
 	}
 
-- 
2.53.0



