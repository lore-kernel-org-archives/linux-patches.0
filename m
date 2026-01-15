Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A073C00B0;
	Thu, 15 Jan 2026 17:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499385; cv=none; b=ZWdJiMuvMc/cFYhnfGoqD2D+kESyPPlSwkY2cg2SuDT+m0sIv6M72vXfqV+JCgEc1HDw2aR22lAWXNCMk9LW+mugssPKyl8DkXu0RhRwO1hlht3hvFmRYhsz4Sug0C63UJkH9JWkzL99mn/Y40ht6tkbFBZR8xfZSr/E1y7WkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499385; c=relaxed/simple;
	bh=fX6e3Lrg7PEyoDebCmmeSLtdHUlIQHd5spjgRHnCeaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdjTltQZ/0wN/um+w/w+yDHBuGDeAlzPe83yqFWGXd88pYm/ee5I5nxLlD/qI1rpkKyRkqkyekSJyT/BT247UgmTteqdJWyMQVRZsqJDbyeMQch7cReHCxqFzH/LdBaLxqGDSXXuhBsh9M8t3jcKGRwJEqlKRovfP9LH5P0gJu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWUKoY2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWUKoY2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADCDC2BC86;
	Thu, 15 Jan 2026 17:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499385;
	bh=fX6e3Lrg7PEyoDebCmmeSLtdHUlIQHd5spjgRHnCeaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWUKoY2g4HYzCb1KnlgG8yoUIQP8QYsztrHmFdtSYW59HMwicxj7/j9oLn9LE5Sxz
	 xCx2m6PJ3CkN2zIWFBJQcZYSljZEIwTdxfWpwn4Qkv7bvIREUQhIGP371hT10e+hZK
	 e3KAesDtLKT9TFkeXcwcGj7AX+nZOxX76ZghCQ0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/451] scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive
Date: Thu, 15 Jan 2026 17:46:50 +0100
Message-ID: <20260115164238.461435105@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 8f58fc64d559b5fda1b0a5e2a71422be61e79ab9 ]

When given the module parameter qlini_mode=exclusive, qla2xxx in
initiator mode is initially unable to successfully send SCSI commands to
devices it finds while scanning, resulting in an escalating series of
resets until an adapter reset clears the issue.  Fix by checking the
active mode instead of the module parameter.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/1715ec14-ba9a-45dc-9cf2-d41aa6b81b5e@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a6ecb4bb7456..f35a53cc00dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3288,13 +3288,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
 	if (ha->mqenable) {
-		bool startit = false;
-
-		if (QLA_TGT_MODE_ENABLED())
-			startit = false;
-
-		if (ql2x_ini_mode == QLA2XXX_INI_MODE_ENABLED)
-			startit = true;
+		bool startit = !!(host->active_mode & MODE_INITIATOR);
 
 		/* Create start of day qpairs for Block MQ */
 		for (i = 0; i < ha->max_qpairs; i++)
-- 
2.51.0



