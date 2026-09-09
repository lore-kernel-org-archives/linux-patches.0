Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A30250BF2;
	Wed,  9 Sep 2026 14:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964177; cv=none; b=UVVaXc2U84DnRR3azY/MHLvcS2op/ZeqzUcFjQUZDNaeW9FKDThOxly8ymd08xXu98gu5hpYrGBlM1QD2yIWWsqcIhSRI4J3YSNlWSQ3xBnmz6gVFC1qh4/YiF2oFc2LhqUeQsChYQ1d5Ey4nnSYDoNA5Ryhostl8TNpsBcFRoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964177; c=relaxed/simple;
	bh=Jvw+rGSdkeAQW8RYGp8hUb+N2HAlJQdeJsQcSDh35rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooLvSwct+xLvVyaDKhdl3tl/6Jcr34m3hE9Ctm6dnn5T9WfxdbKXl0ULZ9lGTl48rBc2K3I+VaRxZggszTdRpUyILmGHcaMm6epYKqjUMudsihjJOyLmSBaTDrShU+yN9SE5DIGBtYTGkzWNuAll8ZRr5+A6uof+e1D87sBpli0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj5U7fsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj5U7fsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A711F00A3A;
	Wed,  9 Sep 2026 14:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964176;
	bh=8qkNHwdTwKVoBQVZk5yvg1xHYlSCDrjwKgNdbev9J5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dj5U7fsgX8y4m5cxLqKS052kyMf6hVlKSgEIq9CHpcb5qOQVgMKYE2klz2U8Uf+nf
	 fiqJvSw7q8IKb1GaVZqonVOiIf2k0o76IqhvgbyhBSjek5yJX7K4G7E5wznOwvhX/Y
	 nka8WRV35g3uRgxPvLra99G5EzCOYLcY2D45pMiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 334/583] scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
Date: Wed,  9 Sep 2026 15:40:19 +0200
Message-ID: <20260909134249.573348495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -3933,8 +3933,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -3959,6 +3957,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	qla2x00_free_device(base_vha);
 
 	qla2x00_clear_drv_active(ha);
@@ -6830,8 +6830,6 @@ qla2x00_disable_board_on_pci_error(struc
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 
@@ -6849,6 +6847,8 @@ qla2x00_disable_board_on_pci_error(struc
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
 	qla2x00_free_fcports(base_vha);


