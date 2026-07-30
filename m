Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3043E09D;
	Thu, 30 Jul 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422254; cv=none; b=K52NNapKQxjwUKegw75plyasbs9cIgWR8NaJYAFGg5JxOWex2sYTEgqAh+NRXHsehTqv0Jwzj2QvRH4gSnGhwdCJOwqbpaWdxrDbC/oVNnhHACoh5jAlvbOt2Eq5kmonRJu4HSyTsOiLOOr+91ElGP5DBmbIHZPznSpzsXI7f5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422254; c=relaxed/simple;
	bh=Pp7w853mdLOlGAik70wjwisJt32/Yj9YCS+BCjrQgmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlefaOusTmbDwCLsZbNj/DOWu4FXlkFct1d/EJG8UEYeTzzitK44qQP4Da8q2RbhHqzEIy6ucZ1Gudelc2JwGQ0wfgsLg09EoFfV+yoLvRk+StCbthbtqXQXdDclRPMySIYtSSFnBWY0Qcqij53yAcGS7Ky3T8PIxN7218QaB44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3+2s/7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3+2s/7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200AC1F000E9;
	Thu, 30 Jul 2026 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422253;
	bh=ACP9giVafcSkO5hsxsSmdOqE4kGKfuOqTednSXOdojM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3+2s/7U/0a79VVkhSRNfOJt1URnHdJ6chOIJaGfbTPQc15Js30OLp4IP0xLG2/o/
	 dFosS0wNax939ipEmO4/i6XQriKhu2xxIXFnou8jQpPsWjWoVymP01oafjFyhjqLuh
	 11Cjt//OJYYIUsvuBkIP/7nvVhb7SAaQiV9T6ny0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 7.1 377/744] drm/amdgpu: check amdgpu_vm_bo_find() result in GET_MAPPING_INFO
Date: Thu, 30 Jul 2026 16:10:50 +0200
Message-ID: <20260730141452.298721927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

commit 93475c34111916df71c63e510fc52db01351f809 upstream.

The AMDGPU_GEM_OP_GET_MAPPING_INFO path of amdgpu_gem_op_ioctl() looks
up the bo_va for the buffer object in the caller's VM via
amdgpu_vm_bo_find(), but uses the returned pointer without checking it.

amdgpu_vm_bo_find() returns NULL when the BO has no bo_va in that VM,
which is the normal case for a BO that has never been mapped. The result
is fed straight into amdgpu_vm_bo_va_for_each_valid_mapping(), which
expands to list_for_each_entry(mapping, &(bo_va)->valids, list) and
dereferences bo_va, causing a NULL pointer dereference.

This is reachable by any process able to issue the ioctl (render group)
simply by requesting mapping info for an unmapped BO.

Return -ENOENT when no bo_va is found, jumping to out_exec so the
drm_exec context and GEM object reference are released.

Fixes: 4d82724f7f2b ("drm/amdgpu: Add mapping info option for GEM_OP ioctl")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 528b19377affc1cc7362a70a254c1dda793595f9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -1094,6 +1094,11 @@ int amdgpu_gem_op_ioctl(struct drm_devic
 		 * If that number is larger than the size of the array, the ioctl must
 		 * be retried.
 		 */
+		if (!bo_va) {
+			r = -ENOENT;
+			goto out_exec;
+		}
+
 		if (args->num_entries > INT_MAX / sizeof(*vm_entries)) {
 			r = -EINVAL;
 			goto out_exec;


