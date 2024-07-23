Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878D157A4F;
	Tue, 23 Jul 2024 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759126; cv=none; b=AIlNJI23/H0h49LqJIIv9g5btKJKf7DTkiB2I4oUmsRWFItRh/i+XNkpoVcCHen5l+NmoxukpjQm8VvHaSI122oJs59YjOk1ovKtblkYo81SIg9/D1WV7EiMZakalIu7MHklJXWDDyJO/W8geI99MSiG6jwYuxSBKGUfV0cGoFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759126; c=relaxed/simple;
	bh=r2Y6yqiG1vl9u+koJoZne+C29VpaNaAhqtW7Gb9wDX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg68B0ZDHUvtdxsNm19llyYpaIADBMp9lBFp+/3zhankjD99Tc6WXc4XH4Ivyns82Di+L1kHnxMRj5J3lNKAj1TYZPkcsfASecGKEhBY9T5yUYxnmP+JAdFIlcug6xKhhQrRDrpz42gaARPFs309beA5ypVUjv+VWP9Qph4mwaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgulyc1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgulyc1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C163EC4AF0A;
	Tue, 23 Jul 2024 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759125;
	bh=r2Y6yqiG1vl9u+koJoZne+C29VpaNaAhqtW7Gb9wDX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgulyc1DH2aayi9DtWon3LgGiTIDQscrpl5fLYSVnSPjRy2btG2EkMwtRILbR/WCE
	 7zNBdfmfHKrFjFzFM13sYNKO7wT9seYQn+dD91YNe0kzRj4sQjxmiJ/Nq6x6qQgLDw
	 VW3MeKpNTNBtfI/nAmnKwRpFPorO/J2di2QsM8AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/105] scsi: qedf: Dont process stag work during unload and recovery
Date: Tue, 23 Jul 2024 20:22:48 +0200
Message-ID: <20240723180403.181592746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d969b0dc97326..27f4028bff3bf 100644
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



