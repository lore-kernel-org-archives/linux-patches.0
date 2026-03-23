Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E9637F8A0;
	Mon, 23 Mar 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274676; cv=none; b=C80gj4nGdzUtPnnxgUgGb/k1MQkOivMvLNgVzudS25sOdcEvjFSOX0P4/bhi/rmRWryI8lQWQp2wiEpYcnvlDr+cLeO5Akfw7udV1NjkDazOWcRBG0MX8FNttN3kckfDkTEgqhrg6FBRfH+V04YkNJXvINmelUYL978LOKsDxh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274676; c=relaxed/simple;
	bh=B7UirBJq3BfATV5AiNlggcfEtNcVZUgxfCU0tpdebxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvjS5kb4mcgy0sTLlKMh4VEWWWWDDVXepAQiyXCFqfTmu+YorNWBCcKqwXySO9KyjuDdSBNFPStHJzB819RPu/mBIeWIYo6OtCLpo/pGxGQrZRbCdqFWWla83FgsJwSRs37Vo6DpWeH7ubsAbG6yhJTe37QAPL2fuVJPI92o0R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLrGDxe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLrGDxe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35822C4CEF7;
	Mon, 23 Mar 2026 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274676;
	bh=B7UirBJq3BfATV5AiNlggcfEtNcVZUgxfCU0tpdebxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLrGDxe2dMunPXmFVqZ+bWwDlUfBlbwaZf7wywN/AkBOltVpBBLWtNHlV1iKPtTrW
	 LUW9Zkh78XlRCa6w9xJ4TsMEOLVurIb5Lq9iKIVVs93mWl8LAPZSoPWGrhg8SgEc6E
	 ANBvYtWKKIzcvSSh87QofRKylL6JvdmflwjlDICI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Varun Gupta <varun.gupta@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/212] drm/xe: Fix memory leak in xe_vm_madvise_ioctl
Date: Mon, 23 Mar 2026 14:44:17 +0100
Message-ID: <20260323134504.901317232@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Varun Gupta <varun.gupta@intel.com>

[ Upstream commit 0cfe9c4838f1147713f6b5c02094cd4dc0c598fa ]

When check_bo_args_are_sane() validation fails, jump to the new
free_vmas cleanup label to properly free the allocated resources.
This ensures proper cleanup in this error path.

Fixes: 293032eec4ba ("drm/xe/bo: Update atomic_access attribute on madvise")
Cc: stable@vger.kernel.org # v6.18+
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Varun Gupta <varun.gupta@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260223175145.1532801-1-varun.gupta@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 29bd06faf727a4b76663e4be0f7d770e2d2a7965)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ changed old goto target from `madv_fini` to `unlock_vm` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm_madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -390,7 +390,7 @@ int xe_vm_madvise_ioctl(struct drm_devic
 						    madvise_range.num_vmas,
 						    args->atomic.val)) {
 				err = -EINVAL;
-				goto unlock_vm;
+				goto free_vmas;
 			}
 		}
 
@@ -426,6 +426,7 @@ int xe_vm_madvise_ioctl(struct drm_devic
 err_fini:
 	if (madvise_range.has_bo_vmas)
 		drm_exec_fini(&exec);
+free_vmas:
 	kfree(madvise_range.vmas);
 	madvise_range.vmas = NULL;
 unlock_vm:


