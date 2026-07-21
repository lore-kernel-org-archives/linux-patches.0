Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCF476CFB;
	Tue, 21 Jul 2026 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667714; cv=none; b=tXky3+jmnzXGOr8vEtbpWqEoGuUAg3e7JuBEaQrAk99KdIKwZssJWvy/StStPAVMF+dWcCTsUPS5gWZwm33Dm8Jp4Ab4Clw/KzbOwSVptZIChuYEDrBMK94PyPFCvQWxfygzCF8dAmxIQzXgxI//m6O8/YNhJASaIm3jTcHeuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667714; c=relaxed/simple;
	bh=agzdV2KlDOGbo+YncDNUq6USZ0aPrmNVkl7CJ2UdmwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+gY1FGJMRAeoxXMlxe/pj4S21yi4gy04JP0BOFtlh6y0WQ5/CGWHTca6gW6iP4cQE3oZW8+vDXYq1FA7TQDWV/IZY5fKYvFlr8A90j51ebQNTiczplsiMDChsZ4UMeCtYzV6DzBhZRAVo/rso75MbVviRXUISk7VW/3CT39Z1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr9L4Ja7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr9L4Ja7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80F81F000E9;
	Tue, 21 Jul 2026 21:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667713;
	bh=ejChnuwwTn+jOMFviVYiGD0hF9VY8huce//5KqMglRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr9L4Ja7BU+wUqb9x05esmp4ubcdhqG7VJr1ZUDXlHHa2YIolE8qJ57vIY5L+0o0e
	 nBHRhGvN+/dZejrXPH6qpFss4FpVTctZQu1RPzqTfRkTBeqxHKeR6QVz3yEwY0E+tG
	 9TOcd1xpk1zDMQCCGiXV1Fij/qvC5gbL+c5XiJoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1166/1266] vfio/mlx5: Fix racy bitfields and tighten struct layout
Date: Tue, 21 Jul 2026 17:26:43 +0200
Message-ID: <20260721152507.876079688@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit f2365a63b02ddea32e7db78b742c2503ec7b81f1 ]

Bitfield operations are not atomic, they use a read-modify-write
pattern, therefore we should be careful not to pack bitfields that
can be concurrently updated into the same storage unit.

This split takes a binary approach: flags that are only modified
pre/post open/close remain bitfields, flags modified from user
action, including actions that reach across to another device (ex.
reset) use dedicated storage units.

Note mlx5_vhca_page_tracker.status is relocated to fill the alignment
hole this split exposes.

Bitfield justifications:

  migrate_cap: written only in mlx5vf_cmd_set_migratable() at probe
  chunk_mode: written only in mlx5vf_cmd_set_migratable() at probe
  mig_state_cap: written only in mlx5vf_cmd_set_migratable() at probe

Dedicated storage units:

  mdev_detach: written in the VF attach/detach event notifier
               mlx5fv_vf_event() at runtime
  log_active: written in mlx5vf_start_page_tracker()/
              mlx5vf_stop_page_tracker() during runtime dirty tracking
  deferred_reset: written in mlx5vf_state_mutex_unlock()/
                  mlx5vf_pci_aer_reset_done() during runtime reset handling
  is_err: set by tracker error handling and dirty-log polling at runtime
  object_changed: set by tracker event handling and cleared by dirty-log
                  polling at runtime

Fixes: 61a2f1460fd0 ("vfio/mlx5: Manage the VF attach/detach callback from the PF")
Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
Fixes: f886473071d6 ("vfio/mlx5: Add support for tracker object change event")
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-5-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/mlx5/cmd.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -147,23 +147,26 @@ struct mlx5_vhca_qp {
 struct mlx5_vhca_page_tracker {
 	u32 id;
 	u32 pdn;
-	u8 is_err:1;
+	/* Flags modified at runtime - dedicated storage unit */
+	u8 is_err;
+	int status;
 	struct mlx5_uars_page *uar;
 	struct mlx5_vhca_cq cq;
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_nb nb;
-	int status;
 };
 
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	int vf_id;
 	u16 vhca_id;
+	/* Flags only modified on setup/release - bitfield ok */
 	u8 migrate_cap:1;
-	u8 deferred_reset:1;
-	u8 mdev_detach:1;
-	u8 log_active:1;
+	/* Flags modified at runtime - dedicated storage unit */
+	u8 mdev_detach;
+	u8 log_active;
+	u8 deferred_reset;
 	struct completion tracker_comp;
 	/* protect migration state */
 	struct mutex state_mutex;


