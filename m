Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EB713DDB8;
	Thu, 25 Jul 2024 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919135; cv=none; b=C5wl7CTbqoro6EZuGMXRbVTQEXdGakqAJzUpIgMuPSEg8rDOIxOhZUgePzs9U2TfPnEnxoBwaFPc7TXik1VEuesdf6G6l3wCGb9L2L6b+lqHSdmZUayQIXyJPlWnWoE/0O5Qqvxg8uK9Vldgmf6L3yKYIUxGM9jO3udAm3hLQ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919135; c=relaxed/simple;
	bh=UfN87ARUrgCokFa86qpvTt838c9AD12a4w4Nih9xwiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEaxm8YsXhPnpWXZtTRKuYYgG9r8czRo0YEYV2ylMfrsxkzoMNGxIoGGJ4cJI1LoOdY5BbGA7D/FJlgr9EC51l89dPw/rxc1SCwFvXrGPCPJLCKnvPI3u50iJav5r/HzLUIjHqPwVrVAT+YhmlDjIdKw3Np2d59ZmciGKXh3G20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=df3dYF65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="df3dYF65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7CDC116B1;
	Thu, 25 Jul 2024 14:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919135;
	bh=UfN87ARUrgCokFa86qpvTt838c9AD12a4w4Nih9xwiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df3dYF65IwOiACIVlQ++CIFOig9cOKRaN7cD0KP+WDSr57dy1edo2IcKZF76ircHG
	 FH6jcD54kE11M/Zow/T27lK+UcjtO2SifC34uXr/eIeSU18sR5DmynMj/nZxRCsyyf
	 9Ygjy+WNKB6hz5bmNFhjS9RFMLYxw52rayfbf/MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/87] scsi: qedf: Dont process stag work during unload and recovery
Date: Thu, 25 Jul 2024 16:36:41 +0200
Message-ID: <20240725142738.743076453@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 51071f0831ea975fc045526dd7e17efe669dc6e1 ]

Stag work can cause issues during unload and recovery, hence don't process
it.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-2-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 18380a932ab61..ab43e15fa8f36 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -4001,6 +4001,22 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
+	if (!qedf) {
+		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
+		return;
+	}
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx,
+			 "Already is in recovery, hence not calling software context reset.\n");
+		return;
+	}
+
+	if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+		return;
+	}
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0



