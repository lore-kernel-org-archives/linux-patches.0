Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9D5377ABA;
	Sat, 12 Sep 2026 19:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242136; cv=none; b=pSEvyJBm4hL0XHVIWouQirQT+v5r3bbtsOqlRIlk1r3xOyG0V4r6ZIOHYRt/KsGdJm0QyNt6t1ARNW8FLgRjW1flvbjcj9zdXzRrLxu5H4OTLdm3NFRSyu89S3r6TlP1vJ7uNgkBTuD/x/nOY4zW4Tyl76OZNxFiAR+IELXV+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242136; c=relaxed/simple;
	bh=gYf407orsz2Xsae/HdUaZrAdeUhpN4tVpa85PpfYZqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwxNxY47JslyJMoMpR2lO33DY/NVyByEgQM4oAbyadxJ3bHo60CYU03ToriQyF+kfnmQH3HlKYqERo/M/qcOZn2O3u+kmDIGKorCreQhZRoPh92PSjJomjsYIA2KV6Kq5OuVdK6dzjwFPcoHTFafA+/62d2Y/RguNr+vxvsV3o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnN4J2hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnN4J2hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE45C1F000FF;
	Sat, 12 Sep 2026 19:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242135;
	bh=P9AhTxBRhbKhiPxdss4OvlNcrz56nSF+dSVke+nW4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnN4J2hXVy5vU2UqXED2G+QdzV+kTiO21exE/rjWFT2I+E0Mp4DNk1fEwAM1zo7HA
	 6I3wtAw4kDTEvhTSOa+1fbqbra3TI+AFHEo48fqzZk6tUaiEAbjGbtjc4bEUXbOdMe
	 Ghb3piIVx3an/TKRbEIPucklYXVb7EYjBdk1u0rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 299/798] scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
Date: Sat, 12 Sep 2026 08:58:47 +0200
Message-ID: <20260912065524.015063753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 33d102102d925357c5fd172dd6672a27d74b3215 upstream.

qla84xx_put_chip() drops the last reference to ha->cs84xx and frees it via
__qla84xx_chip_release() without clearing ha->cs84xx. During teardown it ran
before scsi_remove_host(), which is what removes the 84xx_fw_version host
sysfs attribute. A concurrent read of that attribute in the window between
the two calls executes qla24xx_84xx_fw_version_show(), which dereferences
the freed ha->cs84xx, resulting in a use-after-free.

Move qla84xx_put_chip() to after scsi_remove_host() in both
qla2x00_remove_one() and qla2x00_disable_board_on_pci_error(). Once
scsi_remove_host() returns, the sysfs attribute is gone and kernfs has
drained any in-flight show(), so no reader can touch cs84xx; the put still
runs before the host and ha are freed.

Fixes: fe1b806f4f71 ("[SCSI] qla2xxx: Refactor shutdown code so some functionality can be reused.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-7-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3751,8 +3751,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -3778,6 +3776,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	qla2x00_free_device(base_vha);
 
 	qla2x00_clear_drv_active(ha);
@@ -6579,8 +6579,6 @@ qla2x00_disable_board_on_pci_error(struc
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 
@@ -6598,6 +6596,8 @@ qla2x00_disable_board_on_pci_error(struc
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
 	qla2x00_free_fcports(base_vha);


