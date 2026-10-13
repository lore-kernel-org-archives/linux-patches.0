Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1F74F3910;
	Tue, 13 Oct 2026 12:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893586; cv=none; b=V4n+yLncMTej3sIrXkMz3D3xWURrzEhWt4LE7WBPUoBIvj+w3V8BRxn2oYvdIB7gaWG84aoZPxfCJ671O0x6MIUbwFcsP85I9sFSX2mIT7Rz8BJx7iyGAgXtouThW6Qz1tOoU0iGhltki4dlB/aEIP1NyJpdeorAg5aqjAyGLcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893586; c=relaxed/simple;
	bh=f8rvwFqo853AMaiZ6ei6YVrEFTEbL4gZnyMkNbl8r6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXVUpNcyn2/q432nL8Aj6XuGW+NdoOkBQHR62dZEYukmLHjmQ1uUGRJb+br/vJrV//ofLQsk1FErCZ5TT005gpHJWtSpnWA0oKUYw+8wZH+D/+bD5jhD2ziUSCALU5MUjcUUh4QFy6CmpZwEo+BNmRwY/2Tq4wqnzyk4ozwrp4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3Q/3K1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3Q/3K1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E4A1F000FF;
	Tue, 13 Oct 2026 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893585;
	bh=NTu40kM4+R2zFPZaWmFjnlxePUgEwzAxLLyC7phuapQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3Q/3K1qXrkOzWXdphHcFLRQP5EcwH40D/xlxtXcsS90GCsVVXVzlzmncPkeqsAEQ
	 JJHYetqCiscseHvaBsYvOXIwCwFiDuJxkUEUCsAFNPRjcvFpkrQVHHRe262i7em56n
	 tMi6MXcM/o9PeohZ+iz3t8pJuc2/ZGUKzYjb9V/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/621] ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD
Date: Tue, 13 Oct 2026 13:34:30 +0200
Message-ID: <20261013112927.387787876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 462775c620197adaabc983ce847e5b9878ff4cb0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 44d53910b8111..cd9c96560ddd3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4281,6 +4281,9 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	/* Apacer models with LPM issues */
 	{ "Apacer AS340*",		NULL,	ATA_QUIRK_NOLPM },
 
+	/* PNY CS900 (Phison PS3111-S11, DRAM-less) drops the link on DIPM */
+	{ "PNY CS900 1TB SSD",		NULL,	ATA_QUIRK_NOLPM },
+
 	/* Silicon Motion models with LPM issues */
 	{ "MD619HXCLDE3TC",		"TCVAID", ATA_QUIRK_NOLPM },
 	{ "MD619GXCLDE3TC",		"TCV35D", ATA_QUIRK_NOLPM },
-- 
2.53.0



