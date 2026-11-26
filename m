Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704396;
	b=gydpVuof08BoAf3r7EMeoZiC7+dYKaOwVnb8epwl44pvbZijsvs62GoMbHRbl4jWuCDm
	 pUq+wAhz+g01hZ9c85RfjA1SsHiyPhRMRq4lZKet1fLynpSZt66XmxBHnKREz9OI7iY8F
	 yf2H61ZbOBbRv8FrfSUJ63HmrAReYUyGPZMwQNE0OjFuv+EtzVS4Jqpv8Em5wLZybmauA
	 MiLU0AH57Dkt+Hyj++YWOYGEscFrU5rG1xPMJKnmznfEyI3uD23xM70eOx0VgY9W4T0Do
	 Rw8wJEBGCUa0zFa6BLnXeppg/kKtAHZ8wzWbPoUaX2QP9scw2V2mVxeLf9aHqN9lOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VatMBk91YUX9NrLfMwSGHPsW3fKpkXLf62kgFNuOVDg=;
	b=5W01yQkAtH0xp4afVrg/PO8tVbS9GHm4x+vffFEDd4jt6uJq4Dn8z7QKsuPQy+Rf39Yr
	 vZMXivvkhnqmDSuUr0qPk5z06HzGhtjPZWbhvDeeOJ6NT43zfY0ebrpu4Y0ATBV3eUDqu
	 ZoovMkgnqEFISWrVe4fC12T0JmLk8X9X/SI60zFG6w8zudXkXfjk1wZ2UpA4SIJXZUaqO
	 4ZZexO54Q/O7qN5gUF5mkKwxRXXxFqeuYw2GKpRZhi2ZIbr/Sg8VmK1HPouA6Dvg7H0Ib
	 /1V7pESDwO1lrUIr9k0GNSJI77KSDLKzW3pOzuckzAjrp2mqtStYqxZoSbUzTEiKozA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5Y9zMuQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE889606A327;
	Thu, 26 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5Y9zMuQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F266E1F000C6;
	Thu, 26 Nov 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704396;
	bh=VatMBk91YUX9NrLfMwSGHPsW3fKpkXLf62kgFNuOVDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5Y9zMuQr5yIDfHO+ytW0Y4WAVxEOVLIKbo1cQ++qxlmkujlxB7Hy0YL0edCXIEZp
	 5O51nELPkaOFcB/mwh71AjPkn4aMfb2RWK2hSB0THJmt/alS/c0I5wD7kb4YxBO9xt
	 ILKaFZxWPIGxyG2b/nBR5D1PcEPt7eWgG0V2qGNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/265] ata: libata-scsi: fix MODE SELECT handling of data after the mode page
Date: Thu, 26 Nov 2026 15:37:21 +0100
Message-ID: <20261126143612.797428491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6374cd9062a24..af4d183dfa423 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3851,6 +3851,17 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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
@@ -3871,13 +3882,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
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



