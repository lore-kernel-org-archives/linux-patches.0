Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431133E7141;
	Tue, 21 Jul 2026 17:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655115; cv=none; b=IjIcchCSrgbeJvLAN54ZNvGVBdYavJYxuu/auiV369N/iffvh1NdOYQ6y2t1jMpH2lrOW/k1jwuq5+TyAAnrcEoGQVe5GJ/OvVqCyy2Q+GBGnzmv491I0d1OAehZPAC51WM8gi8zTGQBu4vRg/oHygWbvYfQu3bUH3oM2Eep+cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655115; c=relaxed/simple;
	bh=gd4bPCnZq+NNKgpz72oi2Ccy3pAckwJIcpM9JABcHzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsceYQFdPmVLU73/FiEYvdtV3Gr70XzXWqyF+sG+1BJZdRJTpklrLpBWQ5BWyGlswwI9R+N+U1q7FURXJCy2WeGOsr9TEWJaUX6WUHyWtoAOzTApqEhfSQ1blBy5yUqqYTKb+y2knzstaSPRg4wXpmZDr878Hwqfs+0EjFL574Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvXmMiHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvXmMiHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7671F000E9;
	Tue, 21 Jul 2026 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655113;
	bh=N0XLEilhKrgEXgLZWfAw9bFYTJjMyKpAXjiAVO3v2QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvXmMiHjXlOmuiIe9gT/oHhcPwA/94ktjmLQ/nNr55lQ+2Pg0pTZJEEDiGLZAXHte
	 ZjpRPCHgvSmElHCkNlZQLx0hWotNYZ/FMKZHinXqcDlPMAcVZOY6zphZtONjmrPhTh
	 22/LMNucoqtRy6wAxcpoS3cPKT3Zq0Z4Wt/8Yowg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 1961/2077] ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD
Date: Tue, 21 Jul 2026 17:27:14 +0200
Message-ID: <20260721152638.961736909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 462775c620197adaabc983ce847e5b9878ff4cb0 upstream.

The PNY CS900 1TB SSD (Phison PS3111-S11, DRAM-less) drops off the bus
after entering Device-Initiated Slumber during idle. With the default
med_power_with_dipm policy the link goes down (SStatus 1 SControl 300)
and does not recover, forcing the filesystem read-only. Forcing
max_performance keeps the link stable across prolonged idle.

Add a NOLPM quirk so link power management is disabled for this drive
specifically, leaving it intact for other devices on the host.

Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4295,6 +4295,9 @@ static const struct ata_dev_quirks_entry
 	/* Apacer models with LPM issues */
 	{ "Apacer AS340*",		NULL,	ATA_QUIRK_NOLPM },
 
+	/* PNY CS900 (Phison PS3111-S11, DRAM-less) drops the link on DIPM */
+	{ "PNY CS900 1TB SSD",		NULL,	ATA_QUIRK_NOLPM },
+
 	/* Silicon Motion models with LPM issues */
 	{ "MD619HXCLDE3TC",		"TCVAID", ATA_QUIRK_NOLPM },
 	{ "MD619GXCLDE3TC",		"TCV35D", ATA_QUIRK_NOLPM },


