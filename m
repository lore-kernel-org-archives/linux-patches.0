Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AEC3209;
	Thu, 13 Jun 2024 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280903; cv=none; b=rvgc5mFVpj7sjCNr/857kKWy+zM8Y0ldttV1tu/RlFWwdVmtcQkqYkvL9cIqcmjBpplHrVAOh1YPZu74JA9jhXvSJ7cRKKhQqw4FexfnD1fxKskufnilejWs5v1PoGt4Wdve8QGeMLKKF1yD1djaVhbHrNSX7Xei6i06ZKx2RZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280903; c=relaxed/simple;
	bh=vkbFpBLsdVt3meN49iINcVxIBjYH+T/k+a77PDe4kJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOVjfEBgjRgQXp78g6j2V/sRYutUuze5yxgp3kZJ23+Oc49mfQwFnBgxbimzGfj2gBIwABGf1VufsaKsNsf4mLAWT6AYtzOtym45Qq5+QBQYOoh5kSr7fUoXZPkgLcD9frNXZ7oYSz3pu2sPSeyRJ1UujSJQTEH2/X4aXV7cFQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSUoGGPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSUoGGPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC96C2BBFC;
	Thu, 13 Jun 2024 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280903;
	bh=vkbFpBLsdVt3meN49iINcVxIBjYH+T/k+a77PDe4kJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSUoGGPoUXdhLMl5ngrHyIJgqf9fcJ7WFnIt+uNq6cUOqkcs1gwilXpdG/UrhmnwW
	 gNZGA/47HtMyMLOT3WcIljsjAd8nTAWC00BKtxwFTAoHT7wp64yZLONoI/AiZwwCh/
	 rrIchVtsMiBHDu9Cn3PeyFJXgBwfpYCHZ41FVX3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/317] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:31:32 +0200
Message-ID: <20240613113250.410745002@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



