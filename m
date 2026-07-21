Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3694746F49A;
	Tue, 21 Jul 2026 19:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662105; cv=none; b=DJXGMavhx5w50Q6H1xc6GrJS2mS+2QWjXrVGy2RK68rzbHiJI4EdKYB0P1TV3A7cjAZ7jwOprTuYblyYq5a8lpy29FzZDW8oiAxkdr0YW1xeEzTPG5/8vMipKWH7Z8qu9H7xxPCK+63tArn6bb3KOqkwfroRaVQw+NZBez5zZPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662105; c=relaxed/simple;
	bh=/dokOuyD1LSC//s66IxANuLKdGkv2N8nB8wssUZfY2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCpYWc07T1PQDkddiybc1Y/VpWF7nRyrDtQ7HgSGErg1Af4XurlgFj/KBD9cL95mJ2QX8I856JgZj2V0pMkcsIUScOVCA5zWbelTyXK/9jvtu+ER+xbpagDcqWvO8EF3xvNJs1Hi8Tp1R7O10ccUH+9tVZcBCUoIxL6RAYPSgtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raPhXDOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raPhXDOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF8A1F000E9;
	Tue, 21 Jul 2026 19:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662098;
	bh=lQwSpOA4q2xkjoAAhe2loseIHNhDx574WmS3hCYHYdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=raPhXDOPBJiAdjEaYcsFKeVp/j7plsFlhIN32Vm+lWJDKHhkdTZbqCxO1SbI2EEpi
	 FFb1E8CF2BcZAQFQKJqhwSST9ve8e/b4Lvzt/PxTkUxXWQp7AcyJ8CsCoROqCq1kpV
	 T8AUktshZ26dreMuyz2TIM+qtJ1sy0/w4hfPTmfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0314/1276] vfio/qat: fix f_pos race in qat_vf_resume_write()
Date: Tue, 21 Jul 2026 17:12:37 +0200
Message-ID: <20260721152453.125010361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c78cb6de93906c..eaf996c85eb246 100644
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



