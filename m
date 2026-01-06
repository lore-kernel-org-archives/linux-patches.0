Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A303E346FB8;
	Tue,  6 Jan 2026 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720313; cv=none; b=tFmN8mQs5OJ5px4WAto7haEahMIN+Kgz19ng+qHJ43JnzpwjSm0ihK3GiDMXyMHuR/ULDsbi2ixFEFmjwRUcd2OKcohnhO2dtmLRqzNcg98wlW7ih2cvG41kxmnzI6x4IJREJvdQrIRKHONfXVuLgg8SDeB35h32xfP6L7rARyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720313; c=relaxed/simple;
	bh=JNmdgZhIebrhm5Ns6AumCsbwgxFKGPx2/uVM5zNdFpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRrjEYHaOUvigM9yjrWDCrKr7UYKSUBLFue91ud0c5M4XbbiVRDMvQ49liSdo2D+QbP+9PA+wVKKnwr9Vg8utwI6oLyvHfAv/icuIUN5HEZf3wRu/SzNDt6qydRNA7ghb2s1OriWm6ayBg6BzY0cPTfAUVgc9vSlGntS3UTz6eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZp/s8TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZp/s8TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19EEC116C6;
	Tue,  6 Jan 2026 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720312;
	bh=JNmdgZhIebrhm5Ns6AumCsbwgxFKGPx2/uVM5zNdFpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZp/s8TUPduUFl0uz+OFqFrHj2kT5z05qdoBw4oURM+r/oU1aw2G7xQCTSvnHW4UV
	 bwF/QTGJhlGhUA0K3F0YAxK5thrj81ToTgEPiWH908wxHwmL3dCyR0yka7OinshPlk
	 YQs3ch3ytod41BOLG1fpoOzjbVPRSKB3sxVaiBLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 198/567] scsi: aic94xx: fix use-after-free in device removal path
Date: Tue,  6 Jan 2026 17:59:40 +0100
Message-ID: <20260106170458.648917333@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


