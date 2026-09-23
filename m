Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3045372EA;
	Wed, 23 Sep 2026 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174294; cv=none; b=SdKa4skV9vz5+fxU0jhJzsFFh/4ctp6Q9tCxPANf9aCLeqdNFYdPZCNLQyV3hGMYYRUUuD/FId+r/pByN84CW9aTjof9LhY81wph5SGq5k7k3VzKD51AYpAjEP/Vwt+3tIoeo0nSNi2q/ajiSOtWT0mDfDPKblcvXW5T8KcsgTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174294; c=relaxed/simple;
	bh=hOpCtYjYle07+UzeSI/xPZNk3MBKN3ZTmBEjAasVbV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ7NuJl7pbtNTMwzSiMvMaV8UQ6V+EBV/H/I4D6Phio5xr0UbrhYH3SSFgz0OPT8mOHy5uOpjBfnkK6KOd1oBv9D3m2VsGqAAI2TT99uoTcfrbv5x+Y/37TXzvEGcGZ+TQwtoKd+Si5FHl1SRI/DEv72DI2NDNloPrZpRUkEgGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5skUfjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5skUfjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002081F000FF;
	Wed, 23 Sep 2026 14:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174292;
	bh=rX3Ea4LxNK8MrPsceH2OFTMncYGOR8Lhxn3YnJQ/Lao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5skUfjQXOV1fZDBCZL0QXT+g2VWJ4iPLyyd4DU0gsH5g4bNy57MbnIpgsh0v3ymi
	 qX5LG8WgggroL52S/aOGX91LpVla46RINLztKjhMnQwYilFctiwSQCvcJMCHSV3uHs
	 b02JRNNFNHgjtFarFQDj2nlBIzDDSFzKyveqjzhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/398] RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup
Date: Wed, 23 Sep 2026 16:01:53 +0200
Message-ID: <20260923140644.437877253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 6c368f7baaea63c1c7c28c6df271511f2a1562c9 ]

bnxt_re_init_dcb_wq() ignores a failed allocation. The async DCB
handler later calls queue_work() on the NULL pointer.

Fixes: 51dc5312dcd9 ("RDMA/bnxt_re: Add support to handle DCB_CONFIG_CHANGE event")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index f33e006126fd2..e8a4befd6ca01 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -356,9 +356,13 @@ static int bnxt_re_update_qp1_tos_dscp(struct bnxt_re_dev *rdev)
 	return bnxt_qplib_modify_qp(&rdev->qplib_res, &qp->qplib_qp);
 }
 
-static void bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
+static int bnxt_re_init_dcb_wq(struct bnxt_re_dev *rdev)
 {
 	rdev->dcb_wq = create_singlethread_workqueue("bnxt_re_dcb_wq");
+	if (!rdev->dcb_wq)
+		return -ENOMEM;
+
+	return 0;
 }
 
 static void bnxt_re_uninit_dcb_wq(struct bnxt_re_dev *rdev)
@@ -2340,7 +2344,9 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 
 	bnxt_re_debugfs_add_pdev(rdev);
 
-	bnxt_re_init_dcb_wq(rdev);
+	rc = bnxt_re_init_dcb_wq(rdev);
+	if (rc)
+		goto fail;
 	bnxt_re_net_register_async_event(rdev);
 
 	if (!rdev->is_virtfn)
-- 
2.53.0



