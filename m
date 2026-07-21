Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9278746C4AB;
	Tue, 21 Jul 2026 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656624; cv=none; b=BBMxk/xVfTSC3b63DW4QgfzZoGKMvpoRTuSbYWte1TbsPSYBEqRUEGPqSVphSK8G1GBGqPXrqTvYykHNv1wogXvKVno8lY3HBt1oeq6W9uDJbaIasTgiJoynWhFSVh9iWS1/anLnzp505pArO2FGwiTVru2Vnbed8XSwEfLh2P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656624; c=relaxed/simple;
	bh=YUrE3TXeADimAl8UCNX9HTbWCehgU95UaSEjLD8tWEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwO9dHbjSlVJOMehNhlhGyy9d37785ed4xW/tT5YOdlj6xvfDYpcs0NuVrs/SIynRCgXVZKhrAQpAZxwIjrcUHht8OGppw+Ql67tyVSSK8saCki4hIiNPU7DArgc+6bYCANzwTav5zNAs5p6huuqoo8rj5MrZCrSPJ6xK2bG1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYHtipQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYHtipQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15FC1F00A3A;
	Tue, 21 Jul 2026 17:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656623;
	bh=xWCJBxMTRe7rsI1j3IDkZO4k3V9EYUzX0Nvd7ZcyNz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYHtipQpRkRYuumeh5rXyoyKCuFW3GSbHh/ws7ym93Yc8gmu1DmQ36AVEJkMnITul
	 akh/NlZ7s2q9hWwAKJPCKVRgEk8s3KyI3wrWVD9/VNDQzZcrj4zMMxlAU+IRDm8VfF
	 8Y6lsRn2FT/fgAE/o7GoEiBRlsBS9kpjFBtAxtbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0456/1611] vfio/qat: fix f_pos race in qat_vf_resume_write()
Date: Tue, 21 Jul 2026 17:09:32 +0200
Message-ID: <20260721152525.564379446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 4ec5e932e636896e97e4c6a8205b0ac76d52421a ]

qat_vf_resume_write() checks filp->f_pos before taking migf->lock, but
copies into the migration-state buffer after taking the lock and
re-reading the shared file position.

Two concurrent writers could therefore pass the bounds check with the
old offset, then have the second writer copy after the first advanced
f_pos, writing past the end of the migration-state buffer.

Take migf->lock before doing the boundary checks.

Fixes: bb208810b1ab ("vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV VF devices")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Link: https://lore.kernel.org/r/20260608151317.136613-1-giovanni.cabiddu@intel.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/qat/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index a19b68043eb2e7..c6f5f2edc0dd4a 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -303,14 +303,18 @@ static ssize_t qat_vf_resume_write(struct file *filp, const char __user *buf,
 		return -ESPIPE;
 	offs = &filp->f_pos;
 
-	if (*offs < 0 ||
-	    check_add_overflow(len, *offs, &end))
-		return -EOVERFLOW;
+	mutex_lock(&migf->lock);
 
-	if (end > mig_dev->state_size)
-		return -ENOMEM;
+	if (*offs < 0 || check_add_overflow(len, *offs, &end)) {
+		done = -EOVERFLOW;
+		goto out_unlock;
+	}
+
+	if (end > mig_dev->state_size) {
+		done = -ENOMEM;
+		goto out_unlock;
+	}
 
-	mutex_lock(&migf->lock);
 	if (migf->disabled) {
 		done = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



