Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6350145FF0;
	Thu, 13 Jun 2024 11:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279935; cv=none; b=U3pfXGevaz57A0NiS7iwszLvY2EQyuxPikfjeWEqf45T2ABOD5Z/4DrAD8jHUsh1CFPAzUnzSAaRRgAV5DI2nHnMDetrEmRc/Adr0ZfJykuCECOFu0u3E26AkVpD/fBl6JQMOxD3zVwCvnswu5GACHZp91E3YTETlZRgl/kGOXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279935; c=relaxed/simple;
	bh=5A0ratWMdMbuX+xiPwTM2KLZg44/ncdpHt2JX2BSanc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsCn0t6SH2qkJ8jleLr+ZYikwxjEXgZyNdQZF/wV/J0ma4Uwdk9iwLB707rdzYES0jH0cO5F9YKDB7E0B3IkynaNEQQo5K3oF5H6TghdtwSwyW4WZ+rkysA9knrgtMgdPdCVCZrhSRv6sUXIDGRf9s0ZNPRXR2kkLh+NnIKXuOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SExEijRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SExEijRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E49C2BBFC;
	Thu, 13 Jun 2024 11:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279935;
	bh=5A0ratWMdMbuX+xiPwTM2KLZg44/ncdpHt2JX2BSanc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SExEijRc5wRZTOAZHHCcuK5tf6Pj6axT8OkC28wUQQAyrReeBRDKFIjehZj4Ef/mi
	 Ct6jDnWQ8fCKcyVzNXr6B5OVyCPGg+bhmwAyDvsL3Dy6dhg/G5CYXA9ICtJo5CFuea
	 rCr/GRkJTMAw3ERf5ygD+rf1veYc/26Zq5T6wiZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/202] scsi: qedf: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:32:33 +0200
Message-ID: <20240613113229.902071818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b0a28a6a9c64a..41e7fab99013c 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -172,7 +172,7 @@ qedf_dbg_debug_cmd_write(struct file *filp, const char __user *buffer,
 	if (!count || *ppos)
 		return 0;
 
-	kern_buf = memdup_user(buffer, count);
+	kern_buf = memdup_user_nul(buffer, count);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



