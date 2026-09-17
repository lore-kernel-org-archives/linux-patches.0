Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70944D17A2;
	Thu, 17 Sep 2026 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667987; cv=none; b=n1+k8oRIStolK347PEGaYVDA6mgRuiDjdGePYwJhld2rpx73TRXVz1LgOFWWI/G1UV9hEIFHWR+6oA478FavXQS1Bj4NRPqZ7laEgC2Ff8glQPi9m48oUWMK0brZmK8W1GAu6IZh4HpcX2VYVFCyOiwlytEMfkiyrxTUk8lxHlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667987; c=relaxed/simple;
	bh=qeLJlXA/JgdfMpELuXlJloGUYSk/D+r/S++y1DK8jYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDeC5tjtzkjezEc7xLcSqcQS7JhO5NflZqxidPtL3YjST0ebm3MHpzReg0dzfs4FuWu04XX4FmjANeQfzmlCp76QaWQpcJxD3zVrTY5EiFaUg3t0BBuiAsnvCvB1SREgFcTMETomhN+UxHd7AWc8koT4lpJt59whVS8HS4mUvTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHq9bv1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHq9bv1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A841F00893;
	Thu, 17 Sep 2026 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667985;
	bh=uIeYh6+CRWU2DAUuMCc+zk+UzDFLzb3OdNAAQSYx4SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHq9bv1bN5fLTiDxTCSIhDsdOKbQz/lCJsqndSMWlLhQknB4Jer9ZYSVbix86qB9Y
	 NZ3QWsoj0P1pAivgPh1USPPSnDennDCVjUE9ooBKM6DE9hRJwBufVzeIPwB26GScro
	 Ne0tlgFmIw6iEo3zgCJChtt/rncX7nJJw+WZjaBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0275/1102] ata: libata-pmp: add JMicron JMS562 quirk
Date: Thu, 17 Sep 2026 16:03:38 +0100
Message-ID: <20260917151546.513957471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit c62aff1174cf88e10716c7513702443c47551fc6 ]

JMicron JMS562, as used in QNAP QDA-A2AR RAID1 adapters, may
keep the exported ATA device not ready while the array is rebuilding.

In this state, libata may repeatedly try to softreset and classify
the fan-out link.  On the affected adapter, this can time out, make
PMP/SCR access fail, and eventually disable the fan-out link before
the RAID volume is exported.

A failing boot shows the fan-out link failing SRST, PMP access
timing out, SCR read failing, and the link being disabled:

  ata4.00: softreset failed (device not ready)
  ata4.15: qc timeout after 3000 msecs (cmd 0xe4)
  ata4.00: failed to read SCR 0 (Emask=0x4)
  ata4.00: failed to recover link after 3 tries, disabling

After that, the root filesystem on the exported RAID volume cannot
be found.

Add JMS562 to the existing JMicron PMP quirk that disables LPM,
avoids softreset on fan-out links, and assumes an ATA device.  This
prevents libata from dropping the exported RAID volume during rebuild
recovery.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-pmp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index e954fc07ddbb6..20dd3a5a818a5 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -457,8 +457,13 @@ static void sata_pmp_quirks(struct ata_port *ap)
 		 * otherwise.  Don't try hard to recover it.
 		 */
 		ap->pmp_link[ap->nr_pmp_links - 1].flags |= ATA_LFLAG_NO_RETRY;
-	} else if (vendor == 0x197b && (devid == 0x2352 || devid == 0x0325)) {
+	} else if (vendor == 0x197b &&
+		   (devid == 0x0562 || devid == 0x2352 || devid == 0x0325)) {
 		/*
+		 * 0x0562: JMicron JMS562, as used in QNAP QDA-A2AR RAID1
+		 *         adapters.  The exported device may stay not ready
+		 *         while the array is rebuilding, and SRST/classify can
+		 *         time out before the RAID volume is exported.
 		 * 0x2352: found in Thermaltake BlackX Duet, jmicron JMB350?
 		 * 0x0325: jmicron JMB394.
 		 */
-- 
2.53.0



