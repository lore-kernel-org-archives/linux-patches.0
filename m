Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624016;
	b=biNPcRjPqac29i9vvnithBgRP3O5zVJ/zA6lBtnG++iG8hgU/GOn5nQxEC0rxblvnKOb
	 oAzQdd1yKuQbkpt7Kj6U5WmGi24ynq+CaR7hvpTC21lp1pY3MrDFGkueHi4od/iQbEfvN
	 uzBvMTBD/bp1KDR6kB30rAITQLLvzBGRgZwmJh+FMDmnWhN7Ea5bxd9AZEbpOqgUR0qNO
	 C9SLtB+4xxZIgcaGNTJQSq4WYyFG2vewDxxKxlne9UitGA06ysHTwD6pEIL3hcc40ZULF
	 y+uAzG77c6Q/bh2lLe9OK481TICIT2PV+nQqNsaOvhqs0gMnqugVgaRMRTyuVFt+BJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzrpDMTpz1TFt3jhU1WCq6JKDRBus56lgX/YRVnzyGo=;
	b=LrvXuckeS4SnBP9uDYbt2ZPHFPOzHKSlPrYrvxWOgkJoSHIfc6MhLC+sS13eC4JjTnRi
	 H4XSXLz3isHPhGZBRqFcey/BOgWVSAnzLk+q1SI84zuOtzmHavngYOEzHNQ/jJrkcn7AB
	 iGJsjqnK1IrtnofjaVUhxMj6D3wm9VktlMyDWeDHnY5yroWouDSLP8HlBjX3lEuoO3o78
	 H/Cd4MqnKdXjMTjOot5gTlJDlFFfBPnQF0pWGJjNb28KsuPwmt5azdOKSRlKTeA/PITni
	 oOZnSX5v3g28MRny9BinaUXeAYT7cUrWwNSaKRWLB5IWYYgs0OWbh6AWhjsW7xxveEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmTv962s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B49606A31E;
	Wed, 25 Nov 2026 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EmTv962s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F11F000EB;
	Wed, 25 Nov 2026 16:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624016;
	bh=VzrpDMTpz1TFt3jhU1WCq6JKDRBus56lgX/YRVnzyGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmTv962s8nZp14wx4jWw3CW/2UpxyUorD2tJLL8VMbElfvD0k/Gb5eavCN1V5UdmG
	 rX1dcoeXnjzRGHUMSnsATMM1QZ0dsHUuIhoGmxAn3Tlf2qsZp5fZkTCSG8k6vAyozq
	 Fh0dzz6VDGDxv06ShtJPmcb6rbvvUYeNGLiQ0A8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/816] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Wed, 25 Nov 2026 15:26:47 +0100
Message-ID: <20261125143850.584587863@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 9a2690eb4bbea8d7fbc3dfe478fca75fe956abb4 ]

The REQUEST SENSE length was taken from sg->len after the AHC_DMA_LAST_SEG
flag was or-ed in and the value converted to little-endian, so the 8-bit
field is 0x80 on big-endian hosts and the target is asked for 128 bytes
into a 32-byte buffer. Use the buffer size, as aic79xx does. On an SGI O2
with a Fujitsu MAX3147NC, the sense data of its CHECK CONDITIONs during
probe was lost.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Link: https://patch.msgid.link/20261013094253.2956-1-kaloz@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index d747d0b72a13a..989e8c9bda4ac 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1097,7 +1097,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 				sc->byte2 = SCB_GET_LUN(scb) << 5;
 			sc->unused[0] = 0;
 			sc->unused[1] = 0;
-			sc->length = sg->len;
+			sc->length = ahc_get_sense_bufsize(ahc, scb);
 			sc->control = 0;
 
 			/*
-- 
2.53.0



