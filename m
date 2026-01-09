Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CC91CAB3;
	Fri,  9 Jan 2026 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962507; cv=none; b=YeqhCGX4tJ18IyX2zUxzwA/+aU/mt+zO70Thm2SdjzEfqKOhZKX6DxjEJTXFWW1Qr/bPl2yKvB5h7T39BDU5D1epXRTU0I1PT/3foU89fpoyVdWfY2XSXk58T/Vwcuxvkplfiv1ktZPuYduZyYbU4cloWFSPypWIgRsOLPvZ3WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962507; c=relaxed/simple;
	bh=JIFdScJo7rTVoiIY3WLOONdq+jWUpq2LmyV2YcA94Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUQ3I9jiqrb9gFoLMX92wmDCyxMi56CKQsHLebuL50jketWd/sfldjyyPUY4GWKWjQFmsIjmNtr/BLZylsB2pGrJARHHggeIWYlhFXDEYjXBVvC+9UewJSwG0eUAWqPtBgRO9z48nscs2eV5Y+AD0Hbec3SvNXN97OVZRXstxJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOTfXcI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOTfXcI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494F4C4CEF1;
	Fri,  9 Jan 2026 12:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962507;
	bh=JIFdScJo7rTVoiIY3WLOONdq+jWUpq2LmyV2YcA94Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOTfXcI1ZA1wZVf0dx5/68q4o5dBTsKCaMzE6m9KQ98bfNMdJLK4vCgaVRRTUQRpj
	 rJthHuxA+Rza8WlUflyJG5xFZOZrrF0ZcBXlL02pXarT0XtgNKEYI3514OfiFtaFoO
	 t4+cAvTJqEyCddCgYwSfL9xB6is4oCZ8Yplj2+cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 346/634] scsi: aic94xx: fix use-after-free in device removal path
Date: Fri,  9 Jan 2026 12:40:24 +0100
Message-ID: <20260109112130.544329767@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit f6ab594672d4cba08540919a4e6be2e202b60007 upstream.

The asd_pci_remove() function fails to synchronize with pending tasklets
before freeing the asd_ha structure, leading to a potential
use-after-free vulnerability.

When a device removal is triggered (via hot-unplug or module unload),
race condition can occur.

The fix adds tasklet_kill() before freeing the asd_ha structure,
ensuring all scheduled tasklets complete before cleanup proceeds.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/ME2PR01MB3156AB7DCACA206C845FC7E8AFFDA@ME2PR01MB3156.ausprd01.prod.outlook.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -897,6 +897,9 @@ static void asd_pci_remove(struct pci_de
 
 	asd_disable_ints(asd_ha);
 
+	/* Ensure all scheduled tasklets complete before freeing resources */
+	tasklet_kill(&asd_ha->seq.dl_tasklet);
+
 	asd_remove_dev_attrs(asd_ha);
 
 	/* XXX more here as needed */


