Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D4734F49F;
	Thu, 28 May 2026 20:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999292; cv=none; b=GbTuEVphPns6v7087G/TdpCMhrtm2Tca1vMZVddDBq1wM6M1pitp4bkeI6lXlct/NS4js/zQKHL8i2RDyq9luusR19FNUCl0j0U5XYxkdvtBeFlP/KApgemLWVX6r6W5SSNUBRmcHrr7XCYsb3SNeAUh7QLbYtkn74hR/wVVnlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999292; c=relaxed/simple;
	bh=MVxYPbNobzLthBqpgurJ68FpY9izBlN4bi725pBkHCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sr7qKBGhNQ4Y3T0NZsl4c09f4ofCun+ay7V9ZPXLIA1RoIr7aEGbTi0Rg2WWT3cAkgmbopc3H65MQZMfC6v+8mXDsYbdzWKduvEEaQOJFn23KZi9XFL+hblPIPJ20qN4Nk/HTM1Zv18ynSieMMe1EKkR4oU4E+CBBatYBHlEHDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5bk4+iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5bk4+iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED991F000E9;
	Thu, 28 May 2026 20:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999291;
	bh=3XYBX/kxLUnCoDGlRV52gzuDM7sgVkqtFE+MszgFFUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5bk4+iF89TWREXC9atrCLymvLgbJkxS9H75Qgzvn1+ubXGVYelRAW0NpYzB2DXiq
	 WNqP4VR8rxeIxXcNcJ+9rSx4//6lxyEDNBc3IA/Xc2kmfGYnAIGr0W19eM2C+tstLx
	 rBL+8dOiS9MqwMU+mQbv8T+TkzRVbFMpwoXiuXxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommy Kelly <linux@tkel.ly>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.18 015/377] ata: libata-scsi: improve readability of ata_scsi_qc_issue()
Date: Thu, 28 May 2026 21:44:13 +0200
Message-ID: <20260528194638.827906487@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -1767,7 +1767,7 @@ static int ata_scsi_qc_issue(struct ata_
 	int ret;
 
 	if (!ap->ops->qc_defer)
-		goto issue;
+		goto issue_qc;
 
 	/*
 	 * If we already have a deferred qc, then rely on the SCSI layer to
@@ -1786,38 +1786,37 @@ static int ata_scsi_qc_issue(struct ata_
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


