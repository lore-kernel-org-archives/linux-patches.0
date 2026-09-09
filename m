Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EA4580390;
	Wed,  9 Sep 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962889; cv=none; b=jDg0SZWy3BX+T6GEKgGUWLKEtyFRmrdWllRcNTfRcy2Tzq8AzPAp/LS2FNncA1yGocDDIV0ewXIFj4BGuVk8+YD73d/0vIVahdKU0DxLv1f2gGep2qJ2HuQQtxbb0JzMnQf9Pe+JEMJPaCXN3wH7RS4tif4vVusFpaN81UmPzdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962889; c=relaxed/simple;
	bh=loYAhMlQL68dUK78qR1eI7ZY3gS6A7/p4ubXnMy86Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNrTOYYWsk34AgPd/KFAknkspAElaMhOF7e956+zbWrfFWw7suV3SstqAPoiRdMq3FA249jMzLY47cCttIvQw9IlJ4c+EoHeg0kiQsPhpo5OLI9LRVuDyhPClUjaHZKY/OAvrnllf436AS4apZPjNTyliZEybvfQ6ux8HkOXO8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzh1eHxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzh1eHxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92971F00A3A;
	Wed,  9 Sep 2026 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962888;
	bh=hlvAxNmvozXdE0xA9NAzeTzxHNcDRtjEucmpK588UbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzh1eHxqPoHJNZUaDMjIY++s+2ij626LciKloZ7u8rcEJoFcR0WMj5XV1Z/7QeJ2r
	 UtmgO2ADyUX46f+qEbu+gJwRgd5ASAYEOuiid0i4ZCP+dh7PlggFlnbu9XPgR8nQO6
	 SPjLKfxPXm2WtiL32nH3N2oqV1G5xkq3kg7bbAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 429/556] scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
Date: Wed,  9 Sep 2026 15:41:49 +0200
Message-ID: <20260909134245.694301539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -6828,8 +6828,6 @@ qla2x00_disable_board_on_pci_error(struc
 
 	qla2x00_dfs_remove(base_vha);
 
-	qla84xx_put_chip(base_vha);
-
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 
@@ -6847,6 +6845,8 @@ qla2x00_disable_board_on_pci_error(struc
 
 	scsi_remove_host(base_vha->host);
 
+	qla84xx_put_chip(base_vha);
+
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
 	qla2x00_free_fcports(base_vha);


