Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CB432BF5D;
	Thu, 28 May 2026 19:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998058; cv=none; b=kndG9xyGqzRHLDzsh2MILH8Yaa1mX7fr1VxRMMUrrf2chuzz0Lvz5NrZZ7caoJ0q7OFeq1dmxumPknV2RzCAg7BtsuL1LtpJNMEA54P+9LPUQ/9vvHQYLjMxFbF6e8QaUeF551JBHcbWYU2ano06XXzRZoMrV51A6eP25KH5Z98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998058; c=relaxed/simple;
	bh=wKe/MvoZI2yIfVGpv8oMGIynhCAK7b0k4XxAWPTWyqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hz5n5BmgEgfjCwnGp/Jb1SWLMXpidYrl7gu7hp0tEiC7oLLotpPmFDEU0u24l9BLi1qQS7s2AfRoU6VBP+PyockZYA4q83M2F7GOpVTO5rfGhXFAqC4xsF99mZ2WpevHSY8riSfiJ7X1NGpq6O2rgclvvs9dyNinimrTK9i3Wvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoymrRiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoymrRiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB26C1F00A3A;
	Thu, 28 May 2026 19:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998057;
	bh=KvI0SX+U57cW2lIja8e66Cv5SX0vG6IirLuPazfFPJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoymrRiCXMGLzvXktIBEofgfOpZRDdkNNNcVwOlW10L9EtwWoakjCBQlCBsAyXiMw
	 tRmTFUf5BEsLQOCaBayNcyO/1C2yz28TM8ebvOn3t6Ejg7SyGodef9DgVICOjch+N0
	 CObbTpU2lAyBshlfQp92IwOY7dGcZyKKmdSVavtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 7.0 005/461] ata: libata-scsi: improve readability of ata_scsi_qc_issue()
Date: Thu, 28 May 2026 21:42:14 +0200
Message-ID: <20260528194646.989939488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 360190bd965f93794d5f5685a6de22ce6da2b672 upstream.

Improve readability of ata_scsi_qc_issue().

No functional changes.

Tested-by: Tommy Kelly <linux@tkel.ly>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1768,7 +1768,7 @@ static int ata_scsi_qc_issue(struct ata_
 	int ret;
 
 	if (!ap->ops->qc_defer)
-		goto issue;
+		goto issue_qc;
 
 	/*
 	 * If we already have a deferred qc, then rely on the SCSI layer to
@@ -1787,38 +1787,37 @@ static int ata_scsi_qc_issue(struct ata_
 		break;
 	case ATA_DEFER_LINK:
 		ret = SCSI_MLQUEUE_DEVICE_BUSY;
-		break;
+		goto defer_qc;
 	case ATA_DEFER_PORT:
 		ret = SCSI_MLQUEUE_HOST_BUSY;
-		break;
+		goto defer_qc;
 	default:
 		WARN_ON_ONCE(1);
 		ret = SCSI_MLQUEUE_HOST_BUSY;
-		break;
+		goto defer_qc;
 	}
 
-	if (ret) {
-		/*
-		 * We must defer this qc: if this is not an NCQ command, keep
-		 * this qc as a deferred one and report to the SCSI layer that
-		 * we issued it so that it is not requeued. The deferred qc will
-		 * be issued with the port deferred_qc_work once all on-going
-		 * commands complete.
-		 */
-		if (!ata_is_ncq(qc->tf.protocol)) {
-			ap->deferred_qc = qc;
-			return 0;
-		}
+issue_qc:
+	ata_qc_issue(qc);
+	return 0;
 
-		/* Force a requeue of the command to defer its execution. */
-		ata_qc_free(qc);
-		return ret;
+defer_qc:
+	/*
+	 * We must defer this qc: if this is not an NCQ command, keep
+	 * this qc as a deferred one and report to the SCSI layer that
+	 * we issued it so that it is not requeued. The deferred qc will
+	 * be issued with the port deferred_qc_work once all on-going
+	 * commands complete.
+	 */
+	if (!ata_is_ncq(qc->tf.protocol)) {
+		ap->deferred_qc = qc;
+		return 0;
 	}
 
-issue:
-	ata_qc_issue(qc);
+	/* Force a requeue of the command to defer its execution. */
+	ata_qc_free(qc);
 
-	return 0;
+	return ret;
 }
 
 /**


