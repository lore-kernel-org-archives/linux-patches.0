Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7122DFF0A;
	Tue, 17 Jun 2025 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177293; cv=none; b=Mo9aJ6cjDuYGzFo1qBlm/k6uR4LlRvvYn+MsphY65dQFylXX/yNxgt3Z1bg8odTQPDWhK9a7g7FH5RwaaDmAEOT6Tc+sPBfEW2Ho9n5hTI3dHDyddadlj9Ro5nkAbG0V7/5v+Fh8saljOcL7aaM7BJYkr/1vY/HWkvhvaJabjBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177293; c=relaxed/simple;
	bh=WWdrqnUqMas7iJIAFZDt8oZ4xPz+PqZ130BkQ+ynQXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgydWqEYx/Klu+JwSx687y3b0DE9vjmZZp6Lg9sr7oHCI+3gYnO79ewf9+hVw4OoGZttpzpIYMCGM/5+weFQr3s4ubEAxwHMmCj80k2ex4MXQAa5Oz9Z0izTzgkgzMi1e8ztRb4DYVSBOC9ig/nKcvz5J++XxR3LQaHo9JkSKHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYbav+nU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYbav+nU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44D0C4CEE3;
	Tue, 17 Jun 2025 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177293;
	bh=WWdrqnUqMas7iJIAFZDt8oZ4xPz+PqZ130BkQ+ynQXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYbav+nUv6LHgZ+O783+GQ234aT5BowQ1j9p+HnP7fRciF5C1K8yt0umumsq9nr4/
	 oZ3XuUs7rP24m8sTkAurEPZJhS2uPV2UwVcLADx5l7YTEKOZ4mmGl/luGjNxf4GDjj
	 s133NxsRFyzZ+GDX+7V5aKhYN1AJJh1zKkXlYqCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam R A <gautam-r.a@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 285/780] RDMA/bnxt_re: Fix missing error handling for tx_queue
Date: Tue, 17 Jun 2025 17:19:53 +0200
Message-ID: <20250617152503.080026125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam R A <gautam-r.a@broadcom.com>

[ Upstream commit e3d57a00d4d1f36689e9eab80b60d5024361efec ]

bnxt_re_fill_gen0_ext0() did not return an error when
attempting to modify CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TX_QUEUE,
leading to silent failures.

Fixed this by returning -EOPNOTSUPP for tx_queue modifications and
ensuring proper error propagation in bnxt_re_configure_cc().

Fixes: 656dff55da19 ("RDMA/bnxt_re: Congestion control settings using debugfs hook")
Signed-off-by: Gautam R A <gautam-r.a@broadcom.com>
Link: https://patch.msgid.link/20250520035910.1061918-3-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/debugfs.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/debugfs.c b/drivers/infiniband/hw/bnxt_re/debugfs.c
index a3aad6c3dbec1..9f6392155d915 100644
--- a/drivers/infiniband/hw/bnxt_re/debugfs.c
+++ b/drivers/infiniband/hw/bnxt_re/debugfs.c
@@ -206,7 +206,7 @@ static ssize_t bnxt_re_cc_config_get(struct file *filp, char __user *buffer,
 	return simple_read_from_buffer(buffer, usr_buf_len, ppos, (u8 *)(buf), rc);
 }
 
-static void bnxt_re_fill_gen0_ext0(struct bnxt_qplib_cc_param *ccparam, u32 offset, u32 val)
+static int bnxt_re_fill_gen0_ext0(struct bnxt_qplib_cc_param *ccparam, u32 offset, u32 val)
 {
 	u32 modify_mask;
 
@@ -250,7 +250,7 @@ static void bnxt_re_fill_gen0_ext0(struct bnxt_qplib_cc_param *ccparam, u32 offs
 		ccparam->tcp_cp = val;
 		break;
 	case CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_TX_QUEUE:
-		break;
+		return -EOPNOTSUPP;
 	case CMDQ_MODIFY_ROCE_CC_MODIFY_MASK_INACTIVITY_CP:
 		ccparam->inact_th = val;
 		break;
@@ -263,18 +263,21 @@ static void bnxt_re_fill_gen0_ext0(struct bnxt_qplib_cc_param *ccparam, u32 offs
 	}
 
 	ccparam->mask = modify_mask;
+	return 0;
 }
 
 static int bnxt_re_configure_cc(struct bnxt_re_dev *rdev, u32 gen_ext, u32 offset, u32 val)
 {
 	struct bnxt_qplib_cc_param ccparam = { };
+	int rc;
 
-	/* Supporting only Gen 0 now */
-	if (gen_ext == CC_CONFIG_GEN0_EXT0)
-		bnxt_re_fill_gen0_ext0(&ccparam, offset, val);
-	else
+	if (gen_ext != CC_CONFIG_GEN0_EXT0)
 		return -EINVAL;
 
+	rc = bnxt_re_fill_gen0_ext0(&ccparam, offset, val);
+	if (rc)
+		return rc;
+
 	bnxt_qplib_modify_cc(&rdev->qplib_res, &ccparam);
 	return 0;
 }
-- 
2.39.5



