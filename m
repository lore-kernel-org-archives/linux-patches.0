Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA152D8376;
	Tue, 21 Jul 2026 20:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666544; cv=none; b=F+RMQb0KVHuVc2lG5iOr/pSWCkchudR+7mSerKW86AvPq0IDDnOJmNLuAAzDc8DXqNiA4UwLARJtqFA1CNmn+4a5fF8mBjbMpkKpCY+vUCDiBR732F7eeTohzuP4fE/E3hhBx0+Ge+gN513fQdYh3ap3SSQJAY38j7JxhD1MxMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666544; c=relaxed/simple;
	bh=wnDGxir5LZEy1i4cBi0Qab4d+3/uk4d7FPu7dUZO+DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0b8oK0DcF58tXiasnkM2TRwGBsWIdZXbrLSuUmb5hhe5398ACtNYvHGRowrv8wT07/QdJdiCHRnTZ+oLeH9yG38HMMULJ4YPxGmGxH15a+XkTxwAsWgxyb7nTqopqJRvZ5NCLVbgPAIB2gc6/qGSVwM1jvJZM1CsojdegU1rwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUkG6L/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUkG6L/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412081F000E9;
	Tue, 21 Jul 2026 20:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666543;
	bh=6/X26a1x3Zhj1Mq65Q+Ux6RGLiz+K7s1/EjQ4SJpLhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUkG6L/aKOQgPjKYBm7gWhRGI4PS5yRO5/XKitjtWpNux7jThsF6wPsM2Kk1HFcrT
	 yDiltt+mKgo4Zozch6GYNm354p0Gr9ebtzH+VoB4Ukq1UdPqFSSm0zvDYa6S/7Yh2V
	 X5lFkSliqeOywaneIhD2lBW4xE7EAL7gJRGD0Ji4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0722/1266] drm/amdkfd: fix list_del corruption in kfd_criu_resume_svm
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152458.025725438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1fcc40b7308d9..dc4d6bd4a7d00e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3935,6 +3935,7 @@ int kfd_criu_resume_svm(struct kfd_process *p)
 	list_for_each_entry_safe(criu_svm_md, next, &svms->criu_svm_metadata_list, list) {
 		pr_debug("freeing criu_svm_md[]\n\tstart: 0x%llx\n",
 						criu_svm_md->data.start_addr);
+		list_del(&criu_svm_md->list);
 		kfree(criu_svm_md);
 	}
 
-- 
2.53.0



