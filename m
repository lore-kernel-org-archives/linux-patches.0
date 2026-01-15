Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7C3EDAD8;
	Thu, 15 Jan 2026 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499476; cv=none; b=EI5DbG941qK9IdrFKbNFn5CFtU1qjoQFKqVwJ4cwTSHZLpDzD4smeC6s62IKzMLxXD++yWKCDT+I3NNgz4+EWrTZ1i0yRriWCPueLIcYxwatsz+0nqMV6yxfZsf5tYI/d72s+xaEFAcUneZAp3L/exWgDdziVkkFvg4vAiANUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499476; c=relaxed/simple;
	bh=0A3U9aqkDw3Cvw+p3KvbXT3DLmvHG7dN3nqvd/SRchg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJBSuEiLT/Lk2h3jEgbYKH0z3VOFOZMZ4U+Vk8jwgTYNLBm9Tzr7nF4IwOv+ulF0WYRNwJBTP3E7YugzeDGDyJ1haffRgTSS1Z5od8JYCrrOoocSWYec5py5hIoJaQHU3cQigryT1f1UK38hHYIFYra7zH3ob79+4wDWg9kt7hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdQxv8r1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdQxv8r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC17EC19425;
	Thu, 15 Jan 2026 17:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499476;
	bh=0A3U9aqkDw3Cvw+p3KvbXT3DLmvHG7dN3nqvd/SRchg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdQxv8r1AYGnoWwE/DL8mN/ba8MvEcTV/PSFOBwGXZ3mmeNUn0Z4ZmWUj941L9LCe
	 kutkdIyI9nOULmr6ODNi8tOigxp9cleNFBYwebq80SnJ1mV2rZD7/8cZlGrMAZzSqb
	 xpva9Uu/zbss3wRCEAANtK4CYlGbMb8ls9xpv6Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 241/451] scsi: aic94xx: fix use-after-free in device removal path
Date: Thu, 15 Jan 2026 17:47:22 +0100
Message-ID: <20260115164239.611594823@linuxfoundation.org>
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


