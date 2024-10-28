Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822818837;
	Mon, 28 Oct 2024 06:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097949; cv=none; b=nxMDL9LmFSI/Xe3UG/hoU1FCpo1/j1xd+brqHqcP0lRsXd/HJ5cqm2RaT+X61nDJbvHna1LFGw0Uh4MsfpHWQsZLujIp6cDKSJAGE9kwaN1J0rkyS3mva0dOHVqNWTG9UUR3EC2S5DFLy8T89VZ2qUXK8OYWWgl1kKhdcRzeeok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097949; c=relaxed/simple;
	bh=liXynmcnROob7R5Iqb6zzULbqcZ6QWVqlhjYsPdPkP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XetvKUthV8tIDyjLySG+SpF6tstZ/hQ3IXruxB/tsZX8AkhB9hciarUYZ5O6eTRH9AyQmCXiJkUMd1AVyhjdjlFNj42IQ6MGMz2Z0fNcTqnZ8BUJyRHoRYs6wr92kj32R0ICeoo/MFGxgXip2uo/tzypqD1EpUSbreGIeZCxwBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNUtfejG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNUtfejG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259D7C4CEC7;
	Mon, 28 Oct 2024 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097949;
	bh=liXynmcnROob7R5Iqb6zzULbqcZ6QWVqlhjYsPdPkP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNUtfejGP6ldsoIeql/m+94u/0rHJVmFTkTF7IHpQ9M4y5VKBh5ztpFNKTsgrv6NR
	 in75Tr23mY2oUUojeldw5nHMpIADC7Ky1GalsgYTynLD3Ryp9jV1mWKVOOE2ifJ2NB
	 90wyLohvLCC780hI8Q5Ah7bEEBZJIZIHktX8FAK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/261] RDMA/bnxt_re: Fix a possible memory leak
Date: Mon, 28 Oct 2024 07:22:33 +0100
Message-ID: <20241028062312.293720155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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
index 9714b9ab75240..2a450d7ad1990 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -184,8 +184,11 @@ static int bnxt_re_setup_chip_ctx(struct bnxt_re_dev *rdev, u8 wqe_mode)
 
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



