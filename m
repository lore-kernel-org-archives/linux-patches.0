Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704407;
	b=vEJKMMQ5SnF4AO9CAEqEJNB524xaphcqubq5xlqy8VikDiDRKdqZUS3IFELjpcum4tH2
	 BiJyQNl+m8yJibvmYfEnBApSPmwmwnmSKAGrNM5fcDPkjYnQAdDy+hx0Osue+yenWEMiz
	 pFRKAzXBgak5dKCqw5b0Cty4KhwnZKl3jcUIip887CpwkrcSNoxmLGrgX12iL6FlqiptA
	 UQ1T52TVZ55kD+1W+wx3lSci7B9qpuGPCc4JpTEU0JaopQj4ZBqvWaHLAtJHi79pE04x5
	 tCp5tMW0FDI4ZB/1h9J3oEOfRn0aemoVxZhnC86SDLFNZqZIdnri0y15Jldq8eCMdSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nfXmUMEJ1P2g/PdVkckxu4ie6V99oMHIAX6lL4fNkIc=;
	b=1EgSl/GZkDyNdqE2H8iQMh+NNzIRTeqC49/kYIbGYraMaqJbOSl4+8Gxws1t9Oprqe6s
	 ZT5oKa5bJgX9kqODHfGe43e8GTy3mrD26TQBudtwcW/MAp9i1Mp9CqEkcV05eem3Xb2NZ
	 1dCRlm4rxBynLTawuPgTaHbxRulFED6pjkLJ08Q4LYitBFCzhUmv6E33Ywt+zVJHm50T6
	 3YznKUYFX46Ux63Bmpe7qjNepQUvF3LNZ85cCgO9qVeyeb8KR7YJZJ+U3kQRV0ndD/yVE
	 9XxNMS7HfrcWscbDMmkDVcrp7g+qGxllwc5zyphvNO269LJcRqbySb0eflXrFCiXnOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c55EfjIN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61855606A31C;
	Thu, 26 Nov 2026 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c55EfjIN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93211F000C0;
	Thu, 26 Nov 2026 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704407;
	bh=nfXmUMEJ1P2g/PdVkckxu4ie6V99oMHIAX6lL4fNkIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c55EfjINf8oXOuX/8iEsK8vtUrseMHRYBE+u7tGpFuZNs8jaNxJyRO/tXo2ggsaXF
	 Nk5hlykfakI7aZp5EoWF8HNAMTZhD0gZiDRkmybIZRIc3r8adQIJlRFDITkXbhJl5U
	 04+L3P/tTXnQodG0oWCLQSuECbttileMQYjGOVHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/265] ata: libata-scsi: fix MODE SELECT field pointer for block descriptor length
Date: Thu, 26 Nov 2026 15:37:24 +0100
Message-ID: <20261126143612.996779242@linuxfoundation.org>
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
index 4112017105d7a..aab7b7950b6aa 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3810,7 +3810,6 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 		goto invalid_param_len;
 	if (bd_len != 0 && bd_len != 8) {
 		fp = (six_byte) ? 3 : 6;
-		fp += bd_len + hdr_len;
 		goto invalid_param;
 	}
 
-- 
2.53.0



