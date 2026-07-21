Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D203B71B6;
	Tue, 21 Jul 2026 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669490; cv=none; b=D5lnhJX0Ene0ANjgpfD9VttS6L2jHipVsDG62aGZbVjZqQXqmVxVrxKVPP9al2cTRE15BkfCm8lgc+3xhzpgh59zRX5B5uCLWJDUoOrwTnrT5QtrPqvoygAE36e/eVA3DteYjAwf0vmgOiz7Ec3ehwiLXyZYaXuZ3FJ8xYlM7H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669490; c=relaxed/simple;
	bh=/y37cwUMsH0RuzwmV+u4VsgyQeQbqONe71kToMSk2pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4U34vtyexgSMhBZHnvP2Fi4EGf75+ptVcx6rMdj4v5seuJ/DtRXH09VQQ+EFyiizYYPlrEOXTddQJw5riuOS1f3M5j02RmWQGe//8oHHr3CNZzDbkmM+B7kx1bEKE1BWOuBIdgg4YUxQ2qGa41f83ChrDYm26vVRWl0vVzC6uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDLy7Uck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDLy7Uck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642961F000E9;
	Tue, 21 Jul 2026 21:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669488;
	bh=dvXv0GGwIWlJT1k8Ybp9V1zZv8ol2wHnTEWm+0eA6Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDLy7UckVuGIgX2RTQRPraaPmYAQemmUN/S4C4A4+t/S4jceEzdkQAjvP/H91E+2V
	 ZFPw9vEY+fTV0T2Po7D1E55Du7yd7wkJW6EDJLJGRKNbbfgCJ09BYJhmA22uT62B3m
	 2DBWKKPuIhcc30oMsEvxql9goWzkV6ggtvuPUc7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0575/1067] drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
Date: Tue, 21 Jul 2026 17:19:36 +0200
Message-ID: <20260721152437.466165863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ff00c3cbb9bb95..6555a15e016ecb 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3772,6 +3772,7 @@ int kfd_criu_resume_svm(struct kfd_process *p)
 	list_for_each_entry_safe(criu_svm_md, next, &svms->criu_svm_metadata_list, list) {
 		pr_debug("freeing criu_svm_md[]\n\tstart: 0x%llx\n",
 						criu_svm_md->data.start_addr);
+		list_del(&criu_svm_md->list);
 		kfree(criu_svm_md);
 	}
 
-- 
2.53.0



