Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2226D36654F;
	Sat, 12 Sep 2026 07:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199855; cv=none; b=Tm18y4o3lFWYZpavUAU/eDi5HGOq3ruBwQPojMMMZbmmyesibfJBHXlDTMg+29gCb0WP+j0OfOA6Uo8iG3ur9OcLOHFIo+bywe3xOVIhp9ZsOpE60w9SdY2sgMN2rvm6cCQ8rB2ofZ2KUWNQpRbhcs1z7VfnNaPOp/TrQNDDXjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199855; c=relaxed/simple;
	bh=ZDIhG9Ux7YjW1ZTv3dg09pe/j3RY0DMR2H4YSV0Lp9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAgR0c11T33lqgFSiwy3Tp/ZJm8rwib5A4hlSRUPCssFzYjVzrjCBnbx6QdUuQe45Tv1sFuULAxs6FKgmNa31xDINABJtlb4g4/e4i8XwbOmlXxRkmJeIrPeMj8JvmPsfXtHSyceG+041FxGjCiL5I3vm0texL1Lh5xdN32PRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzmSuKiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzmSuKiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26731F00898;
	Sat, 12 Sep 2026 07:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199853;
	bh=K5ZTfyKzNXd0oV/Uu6jz5oJYxdWonPEzZXaLzvuW1bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzmSuKiPSnVMIYFRWMow1X3wKRYVzEEb1xLwRWL+7E9RF+rLGlCCRP/CNPUwJRZjB
	 TPYPiA8bU8bFOmWtGyrOHye3ldgKDmfva0HjCGYypbOUnBQzyoVWOjcD7BWDYfpqqr
	 cXZOMmeSKkeQxhXyepTAp3amQB0QcomBJw7PWS8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0669/1815] scsi: ufs: Avoid NULL CQE dereference when reporting invalid tags
Date: Sat, 12 Sep 2026 08:40:19 +0200
Message-ID: <20260912065704.593233960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 331bda797e6afc143127ce72b1469d73316f49b4 ]

The single-doorbell completion path can call ufshcd_compl_one_cqe() with a
NULL CQE. If no command is associated with the completion tag, the warning
message dereferences the CQE while reporting the error.  Avoid that
dereference and include the invalid tag in the warning.

Fixes: 22089c218037 ("scsi: ufs: core: Optimize the hot path")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260717153914.26321-3-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bcfc1b031f260..355393ac562b7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5860,8 +5860,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
 	enum utp_ocs ocs;
 
-	if (WARN_ONCE(!cmd, "cqe->command_desc_base_addr = %#llx\n",
-		      le64_to_cpu(cqe->command_desc_base_addr)))
+	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
+		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
 		return;
 
 	if (hba->monitor.enabled) {
-- 
2.53.0



