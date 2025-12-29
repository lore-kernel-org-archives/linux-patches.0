Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F98532FA18;
	Mon, 29 Dec 2025 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025707; cv=none; b=LUlJFVoUqrHzqOIkAOnAx/bX0C0Uu2hfor1r7IrjPVo5CoGBH+k8o/QAI5tUXlRKktVLa3Dem3S1VoWOlSKjaaUChHhXass48V3qEJV8l+0BUYRX/9/Oh67Vpy7YdKZoRCJ/OPoWhE7/57jZJAPswYfr0BtFLLrxrioyXGpg8rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025707; c=relaxed/simple;
	bh=p7A63HB/BKvFxmlNHPvjelsdS8PF+GZcYhHSbIBH1kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0Jzt1Qx+m9h5lL1FGT02zGdMjt8WkVf02LML+LdqBAJqBJL8TkaQTJ3s2VRA7iV5TnrghfUuwCUXLnbbaHdC9PXHmflBPeKYHIT2AnbLXnafszhH2RxC/dw/jSpxCOqKAt/onWRdjE7jZ5YK0vh8kGruAH5AYbptBZh7MH+Nic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGvA0bBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGvA0bBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72FEC4CEF7;
	Mon, 29 Dec 2025 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025707;
	bh=p7A63HB/BKvFxmlNHPvjelsdS8PF+GZcYhHSbIBH1kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGvA0bBS5Xe4LhCleXEZVdXc7oYsq7RDmpEPajNioq2Lj7U5yNYeqUhAxNT9cFgKH
	 CnIwjpUE6K/QAmah9XP4DtXy13/+LDd3Dzpx+eIu6sLmk2r83jMMOI2OeufBU/Pz+l
	 VfrIL5GMCC2HHDvdaVU30jQ+RYN7FODcC/FA0asQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 307/430] scsi: aic94xx: fix use-after-free in device removal path
Date: Mon, 29 Dec 2025 17:11:49 +0100
Message-ID: <20251229160735.632343756@linuxfoundation.org>
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
@@ -882,6 +882,9 @@ static void asd_pci_remove(struct pci_de
 
 	asd_disable_ints(asd_ha);
 
+	/* Ensure all scheduled tasklets complete before freeing resources */
+	tasklet_kill(&asd_ha->seq.dl_tasklet);
+
 	asd_remove_dev_attrs(asd_ha);
 
 	/* XXX more here as needed */


