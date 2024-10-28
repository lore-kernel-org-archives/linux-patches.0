Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD9518E350;
	Mon, 28 Oct 2024 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097512; cv=none; b=TGTD9OUcCXtlMaoBdIUskAzjlQHW70mNDhw3hVoKepzRKpCRHVDcRtXlhuyrGnyI/+9JvpROFJoOO6bNTnuWEEBFtpNfZQ7/BbIQyGVVkg3hozNi+r6XXjidY2ncRSgFwvVLR+xw4mQsmbPddziqwrxw7SHvQt1Uq40/2/KsAvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097512; c=relaxed/simple;
	bh=5/gEXkdGyVUvTJAwL5Wo+834c+lyX16yffyzNRxIy/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgiiRruKefJKCp90rpIdg+iXBjkvZPtliTEeMgF8wjZNhAWAbqCDcXPTvEjmhc07dnz5LmOjLvSvZekwiYDj/wtJhM9RliaSdlnlnNdDUtOCP/cHkfRptXlGsz4u4A6D+6jyzVwBnMHmpp79J7rsmW5KwYxMshMl0/EX2hlW+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naqeJhuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naqeJhuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B23AC4CEC3;
	Mon, 28 Oct 2024 06:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097512;
	bh=5/gEXkdGyVUvTJAwL5Wo+834c+lyX16yffyzNRxIy/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naqeJhuuwx/jF8JU1tOVOCd51HYO5vTIHygCswwdTGeFkuOzzrYm7O6YMwXet0niP
	 DYn1hH6ltC2FO+pFOYS8IS+xWAlHFs9IVYnXGqCoTgsS9gtFjust3GzyiwVMAGAhUP
	 mri0YhsxlNy40pdXiZByBq7MvXOp2J+Vm/rGRYq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/208] RDMA/bnxt_re: Fix a possible memory leak
Date: Mon, 28 Oct 2024 07:23:07 +0100
Message-ID: <20241028062306.835907234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3fc5410f225d1651580a4aeb7c72f55e28673b53 ]

In bnxt_re_setup_chip_ctx() when bnxt_qplib_map_db_bar() fails
driver is not freeing the memory allocated for "rdev->chip_ctx".

Fixes: 0ac20faf5d83 ("RDMA/bnxt_re: Reorg the bar mapping")
Link: https://patch.msgid.link/r/1726715161-18941-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 039801d93ed8a..c173d0ffc6293 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -176,8 +176,11 @@ static int bnxt_re_setup_chip_ctx(struct bnxt_re_dev *rdev, u8 wqe_mode)
 
 	bnxt_re_set_db_offset(rdev);
 	rc = bnxt_qplib_map_db_bar(&rdev->qplib_res);
-	if (rc)
+	if (rc) {
+		kfree(rdev->chip_ctx);
+		rdev->chip_ctx = NULL;
 		return rc;
+	}
 
 	if (bnxt_qplib_determine_atomics(en_dev->pdev))
 		ibdev_info(&rdev->ibdev,
-- 
2.43.0



