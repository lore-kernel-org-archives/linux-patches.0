Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3684C57ED96;
	Wed,  9 Sep 2026 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963068; cv=none; b=mWq7FIAdoWKpkGshFDk+6el8lQnNLofZjih0NUvSBuz83fcYCoqIa36eWqPywFCHzRlyvAwWXNMnlFCLX3tPGvoUb4yQ6Bss6yxw+NkZb2w8dpf6Bsl5OfrNgGWI+6ZIQtsLxLrFE3eJL12y/DAywbQf0RBSGJIHXHOppn4POMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963068; c=relaxed/simple;
	bh=vf1Kkj/KktbsANOd7azDTOBz9gD2wUndHMF6N/GJRhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6+UeibCWRns4kVYV90Eu7z8pRD88cW/ebBUmakYhTMnqyLpIOHEZWC3s2wxwVJbP/C/MdqabFh+fxkPCE44iry/Akuz0lZD8A2hDcIxKYgo1rxmkiuNyIvZ17taLqoM3CUB+dKJ33vwPNL94v0jfoSlAYwPFpauzh5KQDTk/Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRDOUtFl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRDOUtFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1B21F00A3E;
	Wed,  9 Sep 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963066;
	bh=pNVbCvDwOu5Kxvpab0+yO7jGGBLrVXHeXeq2Vv0mmkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRDOUtFlXPkOaINjYGzjmM9SmR5TKNFoWNps/JOyf3p+dINAJ9F+PamHaYwaI3LGv
	 Y3cSe4S682TWOMjA/DxshmPU2FksqsN93NW6mMyTw8AgOZdtuQEsVD044g4IdW1Clg
	 PM9SsIEoNL3wIsBh9xq8EFcQ6AWfkoaHUUStftDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 507/556] drm/amdgpu: fix Idle BOs list in VM debugfs status info
Date: Wed,  9 Sep 2026 15:43:07 +0200
Message-ID: <20260909134248.297476295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 90ce19bd11b2864e26e4b43e7acbffabf037b69b upstream.

amdgpu_debugfs_vm_bo_status_info() prints the "Idle BOs" section by
iterating lists->needs_update, the same list already printed just
above under "Moved BOs". struct amdgpu_vm_bo_status has a dedicated
idle list, populated whenever a BO's state machine settles, but it
was never read here, so genuinely idle BOs never show up in the
debugfs output and the "Idle BOs" section duplicates "Moved BOs"
instead.

Iterate lists->idle for the "Idle BOs" section.

Fixes: 4cdbba5a16aa ("drm/amdgpu: restructure VM state machine v4")
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 451bfc778a8c364841837def00ba15936f72762b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -3111,7 +3111,7 @@ static void amdgpu_debugfs_vm_bo_status_
 
 	id = 0;
 	seq_puts(m, "\tIdle BOs:\n");
-	list_for_each_entry(base, &lists->needs_update, vm_status) {
+	list_for_each_entry(base, &lists->idle, vm_status) {
 		if (!base->bo)
 			continue;
 


