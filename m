Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6099A1A28C;
	Mon, 14 Oct 2024 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916565; cv=none; b=PcK5F7qKy0OOP0UoF0jVjPvmmKuhprgLfC4daUeXex6zK1sV2H+kHqe3lDSng4a4yYqION4BfrUBhWz90jlAgT8eL2BCdp+nlTdDL+8gYLXAyqBDnclDuymKihAlePc/UJZiKI6otF7blG4PAB4fepRH2Lrg57HXXS/huYC51fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916565; c=relaxed/simple;
	bh=EAv43SH2mnrKiYPPRjCjLh9BnRQuuKKOLPSspHdpyeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ3XnMmwckDZeur27Y0hXc1IeUMqq1ml2Wgaz4HBfitssRgwYMamjFjVOjQCQv+tfkSiD7HBlxDMdkaR3EJOJjw/IwzOFTyu8VWBYcBqvCPUVrTg4q1xOYS1PgUp/v6GqNRcoNiMvMaxRAvrSxppn/TA7/pLrtJDSr1xLfuogCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3IuKXBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3IuKXBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCB6C4CEC3;
	Mon, 14 Oct 2024 14:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916565;
	bh=EAv43SH2mnrKiYPPRjCjLh9BnRQuuKKOLPSspHdpyeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3IuKXBxuM0ypMKHEUO6kJ58mXQwF8e305B+5lmAtXnxFYgTY/f0UqNkTdkrcAEPp
	 lioFVd4/z1FAHpO8HounPK17sPkmKx/+jUu3eMM8zLhm4JqX5WhoNClIZ7cL7DLmL4
	 U/W7jcz2U+69jX+B4tmpnXMA8AI+NWaLgFkrznUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@outlook.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.11 201/214] ice: Fix improper handling of refcount in ice_sriov_set_msix_vec_count()
Date: Mon, 14 Oct 2024 16:21:04 +0200
Message-ID: <20241014141052.820154141@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@outlook.com>

commit d517cf89874c6039e6294b18d66f40988e62502a upstream.

This patch addresses an issue with improper reference count handling in the
ice_sriov_set_msix_vec_count() function.

First, the function calls ice_get_vf_by_id(), which increments the
reference count of the vf pointer. If the subsequent call to
ice_get_vf_vsi() fails, the function currently returns an error without
decrementing the reference count of the vf pointer, leading to a reference
count leak. The correct behavior, as implemented in this patch, is to
decrement the reference count using ice_put_vf(vf) before returning an
error when vsi is NULL.

Second, the function calls ice_sriov_get_irqs(), which sets
vf->first_vector_idx. If this call returns a negative value, indicating an
error, the function returns an error without decrementing the reference
count of the vf pointer, resulting in another reference count leak. The
patch addresses this by adding a call to ice_put_vf(vf) before returning
an error when vf->first_vector_idx < 0.

This bug was identified by an experimental static analysis tool developed
by our team. The tool specializes in analyzing reference count operations
and identifying potential mismanagement of reference counts. In this case,
the tool flagged the missing decrement operation as a potential issue,
leading to this patch.

Fixes: 4035c72dc1ba ("ice: reconfig host after changing MSI-X on VF")
Fixes: 4d38cb44bd32 ("ice: manage VFs MSI-X using resource tracking")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@outlook.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1096,8 +1096,10 @@ int ice_sriov_set_msix_vec_count(struct
 		return -ENOENT;
 
 	vsi = ice_get_vf_vsi(vf);
-	if (!vsi)
+	if (!vsi) {
+		ice_put_vf(vf);
 		return -ENOENT;
+	}
 
 	prev_msix = vf->num_msix;
 	prev_queues = vf->num_vf_qs;
@@ -1145,8 +1147,10 @@ unroll:
 	vf->num_msix = prev_msix;
 	vf->num_vf_qs = prev_queues;
 	vf->first_vector_idx = ice_sriov_get_irqs(pf, vf->num_msix);
-	if (vf->first_vector_idx < 0)
+	if (vf->first_vector_idx < 0) {
+		ice_put_vf(vf);
 		return -EINVAL;
+	}
 
 	if (needs_rebuild) {
 		vsi->req_txq = prev_queues;


