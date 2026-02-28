Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED28534251B;
	Sat, 28 Feb 2026 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301549; cv=none; b=YMFERsZsAEz4nrFsFSbVTQkDYleJZVxrM42kXeh1gjG0KH4LdYXexHz3X5MoegKMQenH4DzX96oU7h5Lbt2GusSS5rZ2hnyRoicffypftc5HdshYTmGHIypStNcCjsX4797eVU7++0WoT+1npKDtgsIaEs+dW9FIdX3CTbKl0/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301549; c=relaxed/simple;
	bh=Ad8rp7JJ8JuTBBW0xVn+Hrn34sFXYY/i1r51x1S/7+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LK5jrADHdZQ/Wmlltfkh2a/lkis2GVFBUk9RvnnEWMhF33TMX/sZsS11WoM8pNWQJWlnGCGblzp/eqEN/QE4+yr+BQlt+962PCdDggWYZCrTAXl2pv4/294b28C8dmovKyYhrEjI1DGxwNO55l0RU6NLy6j5BVcobLqJLrt2aJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hipJlZAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hipJlZAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88005C116D0;
	Sat, 28 Feb 2026 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301548;
	bh=Ad8rp7JJ8JuTBBW0xVn+Hrn34sFXYY/i1r51x1S/7+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hipJlZAHerweD3CWvC+j0Bb/FE/NeKgbU/jjlMTNcYP6rUdAL9EdsKfCJMl1lsW4L
	 fFjBrjp1OPJd3Py1RipxloCJ/HvjnBy7lEes8IjGv4FA7xj2ZblVi4DyAPiwpTH3gP
	 XA9zOIo+ClhA0hCs28an28MLnOvqz3CKilzthz2I9k0gJjbv8Gt5+bIs6xaXuC8QWu
	 /Ysnrswn0xaWjjQaTtIyC2FgnZqeL64QF9IpBs402P4a4PTh1fFMWl1ra1t0pK7Ybe
	 VIklCofdbjLUNo8GbJ3FPWgE2qGaW33hsP4mqPF4T/C/9cT8PgQHopqA89DjjcWZom
	 kHwWoLfI6tmTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jia Yao <jia.yao@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	stable@vger.kernel.org,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 731/752] drm/xe: Add bounds check on pat_index to prevent OOB kernel read in madvise
Date: Sat, 28 Feb 2026 12:47:22 -0500
Message-ID: <20260228174750.1542406-731-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jia Yao <jia.yao@intel.com>

[ Upstream commit fbbe32618e97eff81577a01eb7d9adcd64a216d7 ]

When user provides a bogus pat_index value through the madvise IOCTL, the
xe_pat_index_get_coh_mode() function performs an array access without
validating bounds. This allows a malicious user to trigger an out-of-bounds
kernel read from the xe->pat.table array.

The vulnerability exists because the validation in madvise_args_are_sane()
directly calls xe_pat_index_get_coh_mode(xe, args->pat_index.val) without
first checking if pat_index is within [0, xe->pat.n_entries).

Although xe_pat_index_get_coh_mode() has a WARN_ON to catch this in debug
builds, it still performs the unsafe array access in production kernels.

v2(Matthew Auld)
- Using array_index_nospec() to mitigate spectre attacks when the value
is used

v3(Matthew Auld)
- Put the declarations at the start of the block

Fixes: ada7486c5668 ("drm/xe: Implement madvise ioctl for xe")
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.18+
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Jia Yao <jia.yao@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260205161529.1819276-1-jia.yao@intel.com
(cherry picked from commit 944a3329b05510d55c69c2ef455136e2fc02de29)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm_madvise.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm_madvise.c b/drivers/gpu/drm/xe/xe_vm_madvise.c
index cad3cf627c3f2..fe7e1b45f5c0c 100644
--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -268,8 +268,13 @@ static bool madvise_args_are_sane(struct xe_device *xe, const struct drm_xe_madv
 		break;
 	case DRM_XE_MEM_RANGE_ATTR_PAT:
 	{
-		u16 coh_mode = xe_pat_index_get_coh_mode(xe, args->pat_index.val);
+		u16 pat_index, coh_mode;
 
+		if (XE_IOCTL_DBG(xe, args->pat_index.val >= xe->pat.n_entries))
+			return false;
+
+		pat_index = array_index_nospec(args->pat_index.val, xe->pat.n_entries);
+		coh_mode = xe_pat_index_get_coh_mode(xe, pat_index);
 		if (XE_IOCTL_DBG(xe, !coh_mode))
 			return false;
 
-- 
2.51.0

