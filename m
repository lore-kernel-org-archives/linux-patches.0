Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC5197A8F;
	Thu,  6 Jun 2024 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683280; cv=none; b=Ubu99anEAdBY1q90IBpuG7QX0zVmcwRMuH6JsGUqFlLO8D4c4dmTwS6V6vG3hPDenfpKH52HgE9TdlCGHnSrw2iP++8MGV2gtw/hhyo85fygonBiI4CzqIFE7J9Or49oeLeG+ylECtD+qmHDCeLelYxhAOaHaqJSXMzgfM28/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683280; c=relaxed/simple;
	bh=RbU86L38+KXl/SyJKxctEjov7HGLQwPraiuC5UGMt0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRj5xe9Qa0/S/MJkShJtX2BvUmXVcTHzf1B8diNIkB4iAzlXHT+/V/pgrcpaOkwP43TF3RA5zmD1LxRXeEGDM2o1CETngWzJmb60vXByla+WKc5yHEarDiIqQqR1hS9Ysne/nTqKvB03js4sHxTvqk+McGjeQCR61SjY50UrRC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qq+UoY54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq+UoY54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DADC2BD10;
	Thu,  6 Jun 2024 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683280;
	bh=RbU86L38+KXl/SyJKxctEjov7HGLQwPraiuC5UGMt0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq+UoY54+77x3APZrI2sjP2Zo7udlQDYxGjD+i4XiD9jXiD3AGimRDMXSgUyoTPBk
	 LzrFroqjDGtlSfWeC3Y85SZSc2hIbchIuBgHWn6FJiC2eI6NU6iNcy+EcT4vlC1T10
	 ZQV0H70uTjKW8zk876tDzvlEyGAPm03yMGGBmVU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/473] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Thu,  6 Jun 2024 16:01:27 +0200
Message-ID: <20240606131705.183595012@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit d0184a375ee797eb657d74861ba0935b6e405c62 ]

Currently, we allocate a count-sized kernel buffer and copy count from
userspace to that buffer. Later, we use kstrtouint on this buffer but we
don't ensure that the string is terminated inside the buffer, this can
lead to OOB read when using kstrtouint. Fix this issue by using
memdup_user_nul instead of memdup_user.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-4-f1f1b53a10f4@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 451fd236bfd05..96174353e3898 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -170,7 +170,7 @@ qedf_dbg_debug_cmd_write(struct file *filp, const char __user *buffer,
 	if (!count || *ppos)
 		return 0;
 
-	kern_buf = memdup_user(buffer, count);
+	kern_buf = memdup_user_nul(buffer, count);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



