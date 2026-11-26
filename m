Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704402;
	b=hYDS8oCrDKyFd2Ip+FNIhNYRY5b8+Lv4/dLgVeS7n3iMisFhBADVKim7zBbnv2r4EBpZ
	 ELOMaLmSDBVzViC/ZoZuak0sgNCCBMmL6+boWkWbkKDmsC7EI8ARW4WDRQRiESg+Mi7eJ
	 W5/dbGQ7k6+ASHfm6wRZ7e9Icxn+3iWSHdLEYApbNGIQp1Y62za6ifMTlyELUMcsOzVcp
	 z2Usmd4sXza9oa27SJYqw22W9ycQo8/geKJOFNkvmJUodgq0nUhD5djKPnE+2Hw3ekbEQ
	 flz5sRMqgW/dwmOPaKvjzBgo8LOHM0uoyRMdiosg3GngRBUnvHrDVl47wv6EeXdujtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t1aVjiL9TjownY9X+8Ct8nEk6dnYE8/5pBzCoR+yTpQ=;
	b=e1GOHbdniHmqZm7YOTZHfukVLMZK7ziGOfBJX3it7jXPIerijxtCRzKPSJtNgeS8UmFi
	 iRTQ2eWLY5mI6nt624xX+Gt1ObiOqI/Xjt9ehIKmcvUX86ZJwexAyNfa1z97CopGOBDbJ
	 ySmU96GyQPhHpE4N4CXllxWuBfOrVLRDix318c1GwP4eaxy2+fMHY1+sveLLGXmfntGYA
	 cdSk0IEFF0oJkl6y5aPmdwuky4FwiBa7NrgHqoiPI8Rk0SJMAI9/jweDHH+IkEWdDeHzo
	 BwmRoJiJ0J6Cilef7mESBHYDo6EvYv0RrZnz801FBJ71p7cceyTItt7cjybM4IJu1Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrQHiX3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A24A606A31C;
	Thu, 26 Nov 2026 14:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrQHiX3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5131F000C4;
	Thu, 26 Nov 2026 14:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704402;
	bh=t1aVjiL9TjownY9X+8Ct8nEk6dnYE8/5pBzCoR+yTpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrQHiX3vtMBC+keYTToGireKWyvjBpgmcagQwsx0Uuftv6ChSBwABzb88J1n9JUP2
	 MGEbqugwTSCa05RUo/nv3jmSo4Z7hRdAXw2aZkQcwlc3byE14GgpFavdjbqqdXd0ny
	 wri7cruYd2uM1dZZlwx46sTgwhd/48bRjgAzhfmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/265] ata: libata-scsi: Simplify ata_scsi_mode_select_xlat()
Date: Thu, 26 Nov 2026 15:37:22 +0100
Message-ID: <20261126143612.875135179@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 261e150799305e546753554babccab83a0d50627 ]

Use get_unaligned_be16() instead of using hardcoded accesses to
16-bits big endian cdb fields.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Stable-dep-of: a1eb72c477ec ("ata: libata-scsi: reject MODE SELECT mode pages with a wrong SPF bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index af4d183dfa423..a310f665c4a54 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3776,7 +3776,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 			goto invalid_fld;
 		}
 
-		len = (cdb[7] << 8) + cdb[8];
+		len = get_unaligned_be16(&cdb[7]);
 		hdr_len = 8;
 	}
 
@@ -3802,7 +3802,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	if (six_byte)
 		bd_len = p[3];
 	else
-		bd_len = (p[6] << 8) + p[7];
+		bd_len = get_unaligned_be16(&p[6]);
 
 	len -= hdr_len;
 	p += hdr_len;
@@ -3826,7 +3826,7 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 			goto invalid_param_len;
 
 		spg = p[1];
-		pg_len = (p[2] << 8) | p[3];
+		pg_len = get_unaligned_be16(&p[2]);
 		p += 4;
 		len -= 4;
 	} else {
-- 
2.53.0



