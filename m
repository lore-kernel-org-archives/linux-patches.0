Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620941;
	b=kYy1xAimxewjc8DOMufGoNUoMjkZTwDL0zE0Rmwi0FL1aQBrIMSajyIVeDyHD/sZrB+a
	 lUDQrtrZfcZCWL0kIHhYYngbcGOUz+bNW/JjTANbkwq93/iUsMFx+T16djyhSxsD5hhod
	 3E+j0Q8X1UbwFdHpbima77bHVnpooeB+NSiF8b4xDIiedDD9hMFsiuUqQWgE1ZedwqlJc
	 p1uVv02sUAGtsuxdxjvapE0yp1S41qKbJz4/DP2tnnHPKKiXS6AMJdgChqu790PAMh8us
	 Poq8GjkYVW9awjfQ6FjZAKXhs48iYavnWcdJJlgznz0e1zoG3Dp/NbFROE3GwzTT6Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJiRbogZM0vM9+/beWMNYopaLwELBlrCaBoad3lGhjg=;
	b=e0QDt6StbcXu48VamPlmS4AnSPC/T0EVccxx8mxGou8W/weoM9hEBjXfKqAWA0rD0QRZ
	 DcNhPd8+bELHpZjwQYCAX4ULXSsSgy27PzgvfZbFmfBkCw5bLYgy3rUBs22dPvHX8jmX/
	 QnMXdp2Egbj6CPWxNU1oEd0PTB8Ef9tuqHPBVTDElUhLR2qQGAHDr5Z/5E1fO3/cO7zFJ
	 TdJKYRvl6J+gcRrajmYhoTgcMi16iE2x/E+3bnTgrrOCJteePrUA23d12g5JvqEHtYLn5
	 YsIk+IdXx0l/RkQe0qtiuCuBrBRuqsfVJmuMjeWbD/I24nRfamjbAwG5yswhb4lRw0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYjmzKrc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBBB60A2627;
	Wed, 25 Nov 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYjmzKrc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182831F0093E;
	Wed, 25 Nov 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620940;
	bh=VJiRbogZM0vM9+/beWMNYopaLwELBlrCaBoad3lGhjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYjmzKrcShqiKsiKhGRz/nEPEMff/qp8aKd7zpSylWPqGzLLDx4QhIBaUe7Kkvrln
	 ldifCNCRUTCgmkMAJ0BBpIIAy+4iVkXpyi3TfylZU6jSzVEcUAOcb1SgKSJWGs3Mmy
	 KM54f1Jy5/s2ggioYl0bwbFdCUsNPmQNScBQCMU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/990] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Wed, 25 Nov 2026 15:23:59 +0100
Message-ID: <20261125143823.774416400@linuxfoundation.org>
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



