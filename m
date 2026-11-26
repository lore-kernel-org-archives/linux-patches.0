Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705241;
	b=XRb0cLMLt59GqMhBHrjnZ9m2pTmEiHPy2xqtBGhk9Mdl5qAmCDRz9UIMTtI395Movu/0
	 vT2D4DoTtHZLCzYC4NsZh7U7IRZAPU2+0JKq+hyoho+4lWRkomgA2pbnO8X+636NapDjX
	 8TLLUCu9qcn/p4iBrR3rSGpKY2QLMRjPBi7URF6Vs2kUyVHXuUbV07crzxxtzv9DpJM6u
	 cVu5S/csFLkRTkGkvC80QI4J3Kn8AxNKIbPTnzatU+zgkj1vDkGwgLWUr0RH7ze8N/b7L
	 2Wbq8wMwJlzTpHPI8Bw/yd2WqSu5ftE2r1vmdwyMmKmL7u2+siw5HO6FEOCB2e1Ac8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SisXDblnxLQKSyK2n1nquKFoQV7CGvEIBRZZCSqBZ9w=;
	b=rHTAlEZBMwN7OWpzOjqnYlomDpEYbE2TYP2Hw5Nt9nL6xs/RncA14KARIOQOzFDWWUqz
	 5417N3+0gnnWkrIpUEvdDBMcRCFRm4tcrei8K+BMyBQX30Pp+hCPC/51tTqmkeN+t+YQi
	 qoUPAMkqaNzFoiNXp7FxfrGLpjGW9F9DLuows/Ih2A0bmEVKcd/bg0b4UrwJZsVdeXsyN
	 twXjfanSyo3E8tsvuH5eFxfisShZeCCOYdNromiR+xrLNwe3msPNTtnj8m3vFY28k64kE
	 PCNJXz1kn8xLWGKKB/dWXxMH6UeT53j7kh0t2hUvwDdOa1Yz06/o25NAU9nmZ9nGA0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjBkPYvV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CA1606A31C;
	Thu, 26 Nov 2026 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjBkPYvV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35C51F000C4;
	Thu, 26 Nov 2026 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705241;
	bh=SisXDblnxLQKSyK2n1nquKFoQV7CGvEIBRZZCSqBZ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjBkPYvVdp7HrbjiqUcTXUy5OyiwZhe2rF2KFJybxXGapC8gX+XXrsyGCS50dTOos
	 E6BOY9hkKo4631eMUiUxwG9k9GYIivttTValw58fiwyLM4tyF0eP9N6a0TMsUkiiwS
	 CEm7snpfQamwmWjeOwtf2/tRE8/IcElm8yR5+pWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/319] ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length
Date: Thu, 26 Nov 2026 15:38:21 +0100
Message-ID: <20261126144009.748080401@linuxfoundation.org>
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
index 282d92c6f767e..c5ce4df945def 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3764,7 +3764,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 	if (bd_len != 0 && bd_len != 8) {
 		fp = (six_byte) ? 3 : 6;
-		fp += bd_len + hdr_len;
 		goto invalid_param;
 	}
 
-- 
2.53.0



