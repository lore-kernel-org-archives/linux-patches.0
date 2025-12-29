Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231909460;
	Mon, 29 Dec 2025 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025364; cv=none; b=SKvy2QCRb39oYjqttCHJvASL6O54JvXQ0DOB+5M3uyoeIHizyuHTkVLokXIJtZ2sBmpzPHWGnn1MbMdccoYDp6LTvISjJIwLUQZMZx83hoqJMG1ppJkWYyoYQzS7mkbh5i3oHzDA0heKxoeBCIQMXo/J5EGnhAIc6nB/2m++n2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025364; c=relaxed/simple;
	bh=DsKe8SkFXbxKt170SRpBW+Gvm6KEUsKPxxcmz/iai8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efjsNjs2Iuy1d1UwY5Ontd2ZfcXbz9U2oPZDFH6S7gNO62SV7rxt8FRJaBjkmYa2Tyxgqba5BJ8K0YFtMFjlnsJGE8u2n6Wqh09Ex7rcSpY+z3FRLbVjUyFhRm+quAU88Z9oe25LYV5icSTsFEoVhc2Mm5ttWY090fgKUOcbRhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvWhu8GR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvWhu8GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF39C4CEF7;
	Mon, 29 Dec 2025 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025364;
	bh=DsKe8SkFXbxKt170SRpBW+Gvm6KEUsKPxxcmz/iai8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvWhu8GRSQaFt27ocIJt8XtbHUrlYyiQrgHj1SrFuFQVAzHYCLR3cYYngmyXmHNcI
	 xmyKe5nXn+WvAcwgrzfu17QxnfaDOWVAePu0O4E+it7phWGoZkIYfmqS7MSpDzLBhg
	 2oo8C5t/De/mZtT6rTe3d0x93Utj9zuqciZCAxwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/430] scsi: qla2xxx: Fix initiator mode with qlini_mode=exclusive
Date: Mon, 29 Dec 2025 17:09:49 +0100
Message-ID: <20251229160731.238671885@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 70a579cf9c3f..6b0f616b1ca0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3460,13 +3460,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->mqenable = 0;
 
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



