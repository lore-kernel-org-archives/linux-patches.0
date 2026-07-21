Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F76D388E40;
	Tue, 21 Jul 2026 19:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660874; cv=none; b=Hl/quD25WVLG5uW/hgLJzYq72B8zBh8F9OBbQYutmx2GcEfnkc00d6qMfS1DOTtKwKwwlPIXdz15K3jLxqrs1CF+tCjW2jzlrs7r6O/lSfCOJkYKYFvklnXhp+LOBjhNAyJrPqNfmbOHxip5wx13qbvcDdgRIW6FWW939r1kS2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660874; c=relaxed/simple;
	bh=gjbOnlAYTlSZaxcjxd08TOP6C1MCLqdkA6uAqVgWTz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guNa5WpPgrkSKbKWgRRJydmCgoWFoD4dmUH6wgwBo20Y3i3f3SRn2mT6uUaOKama2fPM/+u09Awoo2RYQ8Wfojno/eAVZQ6KdgvPzPmadrtey8Ttn7VD5xMYR/hT27wL+Z4+1bWv8OtSCX9OysLvW90bC7gtQk1HBh+A+9hDnpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2SiSbSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2SiSbSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51D21F000E9;
	Tue, 21 Jul 2026 19:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660872;
	bh=ofpQiHRfx1v/fPVb3ol+H5TAXJL3eaiHi5S75l4fOTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2SiSbSuvRRxDYpB7KVdhxqMe8RUxzAtER5DeDgnLU/qLA4D8p5OP/SAQfMBWWcCp
	 5umFjF+gnkgV8XkJStm623o+NgNwvsgAPJv4/vJDGwkIuRzHpnEaukPSPLijnGOiMR
	 UvSMVklnQmv2DC/6bNf8rD2QlzI4J0Lgd3XFUehU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1107/2077] drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
Date: Tue, 21 Jul 2026 17:13:00 +0200
Message-ID: <20260721152618.931255018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3841943da5ece6..0b54ad8036b641 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -4115,6 +4115,7 @@ int kfd_criu_resume_svm(struct kfd_process *p)
 	list_for_each_entry_safe(criu_svm_md, next, &svms->criu_svm_metadata_list, list) {
 		pr_debug("freeing criu_svm_md[]\n\tstart: 0x%llx\n",
 						criu_svm_md->data.start_addr);
+		list_del(&criu_svm_md->list);
 		kfree(criu_svm_md);
 	}
 
-- 
2.53.0



