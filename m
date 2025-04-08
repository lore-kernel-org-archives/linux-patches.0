Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08964267B7F;
	Tue,  8 Apr 2025 11:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110513; cv=none; b=pUJzLd2ouknCT1t+akLlJSM4YMCRAfnpqsqkc4Xtzb1VllYyhKZSOIodc9bTwxktAMz28FKDH+5llvm7NkLLPnsPCMiVWkqawfGv+kYgpRqxqYRxwNps8CporaTb5PnMY1OjtX3zqHQ8dvYKG/ephIS82ij3XueU2TLTZ3jIKVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110513; c=relaxed/simple;
	bh=E5rsf7aELKGRXgwZZsWeFBeS6QkM9MxJmNQy5Z/98Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kcj7YvrECrSXl74+eM6bt3942tSv3vHXn3dL83xw7PlXcEXMsl096ukEC2M/c9b4w9HaIsAxz3fmojK/m1Ygqt9bsY+LrlYEoKpc9AYbI1RWRAWB5roNQEQHoIV4ys2kNl6a7nqrw3iPEdWMJBrbQ8yemYT/WbH4Hh5HBrSXMwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0sXNGWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0sXNGWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2955BC4CEEA;
	Tue,  8 Apr 2025 11:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110511;
	bh=E5rsf7aELKGRXgwZZsWeFBeS6QkM9MxJmNQy5Z/98Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0sXNGWbyKp6YITG4RwbbWQEI1lTG7v1LpWVedpYyi2wDf4eGDfi/QIjq2NvTOLtK
	 TqXvT6e9JtJDfKwJLOx5/Fi3wW1LaIzumIjghlanqxOHyiQoPoFpnvg2iYQp3jj9QD
	 OvDj/xvFiK5EQKUKD8NU3pIjvBqgO3ZGlVVF1hTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 092/731] scsi: mpt3sas: Reduce log level of ignore_delay_remove message to KERN_INFO
Date: Tue,  8 Apr 2025 12:39:49 +0200
Message-ID: <20250408104916.408280753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit fb27da6e06a0869d2e36255bb7e0b6102daf712f ]

On several systems with Dell HBA controller Linux prints the warning below:

    $ dmesg | grep -e "Linux version" -e "DMI: Dell"  -e "ignore_delay_remove"
    [    0.000000] Linux version 6.12.11.mx64.479 (root@lucy.molgen.mpg.de) (gcc (GCC) 12.3.0, GNU ld (GNU Binutils) 2.41) #1 SMP PREEMPT_DYNAMIC Fri Jan 24 13:30:47 CET 2025
    [    0.000000] DMI: Dell Inc. PowerEdge R7625/0M7YXP, BIOS 1.10.6 12/06/2024
    [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)

A user does not know, what to do about it, and everything seems to work as
expected. Therefore, remove the log level from warning to info.

Device information:

    $ dmesg | grep -e 0:4:0 -e '12)'
    [    8.857606] mpt3sas_cm0: config page(0x00000000db0e4179) - dma(0xfd5f6000): size(512)
    [    9.133856] scsi 0:0:0:0: SATA: handle(0x0017), sas_addr(0x3c0470e0d40cc20c), phy(12), device_name(0x5000039db8d2284b)
    [    9.366341] mpt3sas_cm0: handle(0x12) sas_address(0x3c0570e0d40cc208) port_type(0x0)
    [    9.378867] scsi 0:0:4:0: Enclosure         DP       BP_PSV           7.10 PQ: 0 ANSI: 7
    [    9.386551] scsi 0:0:4:0: set ignore_delay_remove for handle(0x0012)
    [    9.387465] scsi 0:0:4:0: SES: handle(0x0012), sas_addr(0x3c0570e0d40cc208), phy(17), device_name(0x3c0570e0d40cc208)
    [    9.387465] scsi 0:0:4:0: enclosure logical id (0x3c0470e0d4092108), slot(8)
    [    9.387465] scsi 0:0:4:0: enclosure level(0x0001), connector name( C0  )
    [    9.390495] scsi 0:0:4:0: qdepth(1), tagged(0), scsi_level(8), cmd_que(0)
    [    9.401700]  end_device-0:4: add: handle(0x0012), sas_addr(0x3c0570e0d40cc208)
    [    9.471916] ses 0:0:4:0: Attached Enclosure device
    [    9.480088] ses 0:0:4:0: Attached scsi generic sg4 type 13
    $ lspci -nn -k -s 41:
    41:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI Fusion-MPT 12GSAS/PCIe Secure SAS38xx [1000:00e6]
    	DeviceName: SL3 NonRAID
    	Subsystem: Dell HBA355i Front [1028:200c]
    	Kernel driver in use: mpt3sas

Fixes: 30158dc9bbc9 ("mpt3sas: Never block the Enclosure device")
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/20250131171640.30721-1-pmenzel@molgen.mpg.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a456e5ec74d88..9c2d3178f3844 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2703,7 +2703,7 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		ssp_target = 1;
 		if (sas_device->device_info &
 				MPI2_SAS_DEVICE_INFO_SEP) {
-			sdev_printk(KERN_WARNING, sdev,
+			sdev_printk(KERN_INFO, sdev,
 			"set ignore_delay_remove for handle(0x%04x)\n",
 			sas_device_priv_data->sas_target->handle);
 			sas_device_priv_data->ignore_delay_remove = 1;
-- 
2.39.5



