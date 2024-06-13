Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EC0384;
	Thu, 13 Jun 2024 12:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281924; cv=none; b=OfRflujrvjiO4b1kt1y2olGlEAwdWzBSLNei4wzJR7BJ+IK+TQQrPoHXWR7xoUCcfFLHUp/VTf4Cw5jFkWeNRfIOsECPSBfp3WgNdNoClnIW3Speh9f1Pi3+4nH+r8BrP+c6//Op9ELcL6J4r893MZnLLHvI312Gl4ViloPTpI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281924; c=relaxed/simple;
	bh=otmjacSioPyNH/123b3Ktlak5OTHSjfYYV9Zy08J8sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hk5l4MEN2FsJ3lKa7qVpf6x0t88IVjWfyQZv5y13ymeDUI8aVI9tt1lH3zButawMuTQg7KdCvDDG7u9WhPTs/nkv2Hu0Bn7CiAKbbkN0ZuDYm6YCS0NgHNWhdoZkgtwtqDDz5fgY8OTVHrIgImJhpYeoyD9qkKQto+6zvn5108g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChEIxjXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChEIxjXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3F7C2BBFC;
	Thu, 13 Jun 2024 12:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281924;
	bh=otmjacSioPyNH/123b3Ktlak5OTHSjfYYV9Zy08J8sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChEIxjXRxFvabKHB8vKPH61bgCVh+q5PbVyQCkFvbV2Z83VRxVO33Pb8Nd/bb5xfe
	 35ZgG+0dPSc1LSOf1bSAgbOiPQwUIXyGf68Wml0Sq2Qm+SX3itaFKtmDGmO2+aKYKK
	 IZSUsixXOK4sZSL7DoruCdBphMN6YAIYmxZyJjAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/402] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:30:59 +0200
Message-ID: <20240613113306.113224929@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



