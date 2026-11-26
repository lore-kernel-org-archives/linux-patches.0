Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705371;
	b=2YLGHI7SFeIABw9IfIJiey/sBh3dWWa+JLDgqQg8Xuyr1Y60ynqOnlLZJcgDS0Mgld9K
	 vb4dnKBc01bK5vLl2MTimsu7rYoSSEL6+ZOKGzRulOVrDJ7lFrZEYpeprr8OsmzK91hWC
	 f6M6xTppb4XTHhoz+l31Ayww+zjjrpBloVAYhBIwnmx5mRrvYPrA0uljXhG+Y/jqDg54I
	 sJjTIXvifLA00EjLdDMNPWIVCWgPxpggAMa1Z59oKlF1Gik1lGQCr6iVzs/TJZO2kEl3M
	 3qVe6OOG8qKeJMrGKeH8LREJs4/F0X2JXZ/4wbR7//uRIugrQQkciifDlkzwJ0UnRwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IXyFJsPItRTwhgosdaYh6fMTKCDxec1V4x3DUClr5YQ=;
	b=m1aFBIRclUvinkZgdvSBaTtq6RP9IViIVTO3eu/lzSL4J27u65OZy59SBfJ0CFKaLsrb
	 Il61JXczoCtvYAFh9qO0JJQQk6iNg1qa1bwmBgFxMB9PzmN782d4em/I2jlkFB8EKusoi
	 5D/Ew/IMe3PFCwLFkTeOsiJFIkDe0LA81wbuLO2lAu8m2pbVBBrvC2zx8t5IKIOPVMfTr
	 jyBmJJRejyF/VwUFB98NmQlde7ZrsrUVQHtTkkiuXNLxTvVQsiudDSXZXVvXnmcUkFHko
	 DBGuE4qgffEUe8c5zV5gkr2fSwtq61aSPKlqIzpf6SjhIY/No1dtQp3Bc1GKmIkvp6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K9/yoVVa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B7606A326;
	Thu, 26 Nov 2026 15:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9/yoVVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95A51F000D0;
	Thu, 26 Nov 2026 15:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705371;
	bh=IXyFJsPItRTwhgosdaYh6fMTKCDxec1V4x3DUClr5YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9/yoVVareDBj1WaabmXB/QEApZGGrgXNjGz5AiBgTcPea0trderaSSpP7WldpPH/
	 09Ah/8Lee5JS3ceYWGfR4SnP0ZeaqZs1stPuoXLz9uam6xDTbwTR5eVcOvN/x0WZ/P
	 0MtOAraqK8a4OP/O/lmEWg9I7Mt8ssmy6I2A0tvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/319] ata: libata-scsi: fix MODE SELECT handling of data after the mode page
Date: Thu, 26 Nov 2026 15:38:18 +0100
Message-ID: <20261126144009.679841295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6fde0444d07ec954f3d885375e0402ff2f2e5064 ]

ata_scsi_mode_select_xlat() only supports one mode page per MODE SELECT
command, and rejects a parameter list with data after the mode page with
INVALID FIELD IN PARAMETER LIST. However:

- It does not set the field pointer, so the sense data reports 0xffff as
  the FIELD POINTER.

- It only checks for data after the mode page after the mode page
  handler has been called. ata_mselect_control_ata_feature() has then
  already updated the CDL enabled flag of the device, even though the
  command is rejected and the CDL setting of the device is not changed.

- For the control mode page, ata_mselect_control_spg0() does not need an
  ATA command, so the check is skipped, and the data after the mode page
  is silently ignored.

Check for data after the mode page before calling the mode page
handlers, and set the FIELD POINTER to the first byte after the mode
page, i.e. to the first byte of the next mode page.

The reason why only one mode page per command is supported is that a
MODE SELECT command is translated into at most one ATA command, so
update the comment accordingly.

Fixes: 1b26d29ccd59 ("[libata] scsi: implement MODE SELECT command")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-11-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 231e1d2faa2fe..7433be9adc016 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3805,6 +3805,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (pg_len > len)
 		goto invalid_param_len;
 
+	/*
+	 * A MODE SELECT command is translated into at most one ATA command, so
+	 * only one mode page per command is supported. Reject any data after
+	 * the mode page before calling the mode page handlers, which may
+	 * already update the device flags.
+	 */
+	if (len > pg_len) {
+		fp = p - buffer + pg_len;
+		goto invalid_param;
+	}
+
 	switch (pg) {
 	case CACHE_MPAGE:
 		if (ata_mselect_caching(qc, p, pg_len, &fp) < 0) {
@@ -3825,13 +3836,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param;
 	}
 
-	/*
-	 * Only one page has changeable data, so we only support setting one
-	 * page at a time.
-	 */
-	if (len > pg_len)
-		goto invalid_param;
-
 	return 0;
 
  invalid_fld:
-- 
2.53.0



