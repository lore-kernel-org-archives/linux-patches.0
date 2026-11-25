Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621774;
	b=fmYtS/aCLEqafjR6Ib5TB6LvWyFdrLKO4Cyx9FKQy7T1W2i9eYbjcbGOOBkAiGzM3Ids
	 PBQ5mnsOZ8OqnFwrjNMhGt98o/FSvbg28dPl+8KzRdfikQd0ABmGoZD+douCm+momMl7I
	 PpTQJ3DUBYfkpXWhv0w6O3HTfuY3io9vxcKIvJtjJyF7PHeDDFpk63atn4f5mIiwbQQb8
	 JWBnLN7MLVGoSfJJxHDMqAkxLFJN0Jhobtc4f5QEgKAwHwYVIAm6cHzbOuNIp1BPOBwPT
	 9ndMEELheMPfj15UibfGYmMssqEQlxFTePHmsFWy4mgTPckHtzoB1xByEWhjBREGQOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UOHAF7pGgKud9ViroeLA79jU3Xduu+sNnbr6sPVDLSY=;
	b=PzlaWumFiim5qIu0zk/Lvgs3g8A0o7ApZg38siviK0tGOf5MCblv32C1/Q8PxI2ebIkT
	 t6BPhhqPtCjRX9FgO6U03+XI6jJAOuJoLr622RBCDE4MjKP+VyBuqq4Rqr3QlbU3UzTRS
	 /hk0dC5NPZ2Nw4RCldMtaqTE8E4S3XlT2zyrdIBUwoSBgOQe8gHGSx35kzt55jD+LFSCK
	 fkfjU11QJtd1iiqoqhOFczpkv9k3UW0L1EjK6NSDSgkoZbn8EEkURDNSEqV5eR5lYsEve
	 r42Yd3NdG0BFRilI9C2mn98ySdzOmkGH/XjlR7wx31ky/FaMJ1/YfvfHJ/tT2QD0g7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYOAjM+x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9B606A326;
	Wed, 25 Nov 2026 15:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYOAjM+x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102CC1F000D1;
	Wed, 25 Nov 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621773;
	bh=UOHAF7pGgKud9ViroeLA79jU3Xduu+sNnbr6sPVDLSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYOAjM+xjJB/0fN5QJEGgh5ncOhkfdgR4+1sMGaD96hVFTWvO4nRWBbxEo3gEuT57
	 QooCcr8t35i2l/qGVU1vdBbVgd0ogxWSN88rBwBX0fvsFFfXOUbP/V5xgcZDQLWTFZ
	 5R3p/Dp1Vl2ccg+3DVT7sRTiZf7C8pM6Y+sxqgOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 332/990] ata: libata-scsi: fix MODE SELECT handling of data after the mode page
Date: Wed, 25 Nov 2026 15:28:19 +0100
Message-ID: <20261125143829.864481291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ce206f90d8bc4..ee0346de04744 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4359,6 +4359,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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
@@ -4381,13 +4392,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



