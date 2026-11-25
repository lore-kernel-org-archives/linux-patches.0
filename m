Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624835;
	b=EjCUI6uU110G9Gaod4vwVHQU2Yf9hfdLY2LU/rrdn7uO7Ipwnd2Ah6qGrHpqHWqV47uc
	 FXVcZ+NujVzGcRsLPlTjEVY8AX+VqjqtoIVni0QmbJIO2+QFzGRKPHH9jJ0/sGX8ZVDSw
	 dJ0Q2fxGdPdVUm2NoIBjIo/WuSHWq6sZjWWjQzA/yLnWebnrQAMgPjsRCOp4aAigIiueO
	 ebhNbQdHxC8QI3nY0IbTYlj+5EVwVeXf2ft2SFhISexgHYiI0QwjYD22BX1MtDPXerqQ8
	 nvQdIHo6RYB3L5axw+3bzdWZZS1rF+69IV3b1vjiPPf4y+qH47nugyfH7AFl4u1AvRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b9koDnoHRUQ3I+dGojwd+FqruzkKtTam6NThucaI3B0=;
	b=tOs+xcKVVEnsuraz01VSstGFcotjTENG6bsQyj2NE3+bn2vbeceXJHhK5RXfVAQX+CUW
	 NS6N+AaqIKKp1hQrWJJKXk36T17rJiN9SFBZ4NysKXp+uKoy6dqH7uo7+QWzaKnpDVO1E
	 89OalZtH8Kg1sdONihvZTmjrigqpyYGt5Enbu+RqurUAltXzoHuG0MsnYpwlZK51RZudP
	 NWZdpdb0urc9vPhOG6cvPSqdMUFqFsEcefs+rA/901/Yt49YWaQbXeGJNdNiTy/4MfS0J
	 uz4uEg1CP7Jn2DZxLc2vTKBFq0jgiLRFEbjobzH143ZfNKl4hL+o8F42BKBc4EMsPSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0Q/btl5I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25238606A323;
	Wed, 25 Nov 2026 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Q/btl5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0BC1F000C0;
	Wed, 25 Nov 2026 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624834;
	bh=b9koDnoHRUQ3I+dGojwd+FqruzkKtTam6NThucaI3B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Q/btl5IuHvvOhB+A5KNPvW8yzrwwyrGFgiolSjAHrJRhJ8FhgKzd2Q8a9v5TzBFr
	 4yZWhRx2AT+rrG2K5MZ6Js+UhrXLAmO5zr9rF8yzZj6d4pFTNwh4UqFtDW7JkC/jMi
	 Wn1dDuJ/qg23MEp88/DMfi5wF9VNf/4ogkKPkGKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/816] ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length
Date: Wed, 25 Nov 2026 15:30:25 +0100
Message-ID: <20261125143855.621909316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a3e52dcf0fbaa1a103accef3e8861cdc250ee5d6 ]

ata_scsi_mode_select_xlat() only accepts MODE SELECT parameter lists
without block descriptors or with a single 8 byte block descriptor. For
any other BLOCK DESCRIPTOR LENGTH, it terminates the command with
INVALID FIELD IN PARAMETER LIST, and the FIELD POINTER should point at
the BLOCK DESCRIPTOR LENGTH field, i.e. at byte 3 of the mode parameter
header(6) or at byte 6 of the mode parameter header(10), as SPC requires
the FIELD POINTER of a multiple-byte field to point at its first byte.

However, the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH are added to the offset of the field, so the FIELD POINTER points
3 or 6 bytes after the end of the block descriptors instead. For
example, a MODE SELECT(10) with a BLOCK DESCRIPTOR LENGTH of 16 reports
byte 30 instead of byte 6.

Do not add the mode parameter header length and the BLOCK DESCRIPTOR
LENGTH to the offset of the BLOCK DESCRIPTOR LENGTH field.

Fixes: 7780081c1f04 ("libata-scsi: Set information sense field for invalid parameter")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20261103205448.931471-15-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 05aad48ccf5aa..98a18510db98f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4314,7 +4314,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 	if (bd_len != 0 && bd_len != 8) {
 		fp = (six_byte) ? 3 : 6;
-		fp += bd_len + hdr_len;
 		goto invalid_param;
 	}
 
-- 
2.53.0



