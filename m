Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2F93B42FF;
	Wed, 23 Sep 2026 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172712; cv=none; b=fx5/xmxUJhrgsP6wCabEBEebVzGKTRZHlUHLTGhsNDWtW4f9RVikwlJYUVp2ZBg1O9lG9LQBHzpS9gBuw8OQB1Xvg66dh2hV4zFMBf/UWb6hAUuMx1GA64XVkkIqAKHFqHjhzGVwKybxezzBYbMhENiBdU24WmIJ6R1XBJJ41jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172712; c=relaxed/simple;
	bh=roou0x87scp+rryuEQlIJ0kmFwfqZKBrnXW8CvuKUOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMRw7rGfDplMHvL/s9KyVPn413ALXwJQNubwcJUW1ByYwI4Iwj2NACw0jJQfy+sN7na3f2mezxSiYpw4sd0FT0jQmR2AXQAZgaNoWX8dEO5h6n0T9xuXeuwfMxnNB8CCKf01QpbSGdUs/2w8Njvaa2VG42J7ln3OqM4htqBxFVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/dFtz0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/dFtz0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480681F000FF;
	Wed, 23 Sep 2026 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172710;
	bh=b5IwCK6oQvqIJlggB9D1uLr5YJtThtj2A3COk1eLZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/dFtz0ziX5esQc1Rxe3uOBgh3XVFKibYT5GiIkCb06wp/q2fQVg61TqiRTfPbCQ+
	 guD26mw8gOn9v+xAhidi7nOtt5eENdbzL6I2Pu42SjKMr66N3+PLLWyyNVPh0+OYow
	 ZVAsqJFgcw5WAS3nZNnpgQ8FnOtU7P41mBDHrRo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 037/438] RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup
Date: Wed, 23 Sep 2026 16:00:58 +0200
Message-ID: <20260923140645.745624955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index d25fdc458120e..c2fa83eb0da59 100644
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
@@ -2343,7 +2347,9 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 op_type)
 
 	bnxt_re_debugfs_add_pdev(rdev);
 
-	bnxt_re_init_dcb_wq(rdev);
+	rc = bnxt_re_init_dcb_wq(rdev);
+	if (rc)
+		goto fail;
 	bnxt_re_net_register_async_event(rdev);
 
 	if (!rdev->is_virtfn)
-- 
2.53.0



