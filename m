Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704155;
	b=gyGAtWMcOOTPV+JyaRxxs8l0lWxd3Y+6cIOb9dmTwEEwhP2ra3CkmwgNwm3Yw9tywPDh
	 QLImC6Fd4TZ8R1gXu79AggrM0vVq92WsR+fyus8Ebirg59JCbDdk1AH7K5aalHwnXcjja
	 fUfkY/gkCmhrcVFlAJHVa5jEM1ovRUuhgJkhJaOXZ+jlG6QHebx0K457Pw2AMyloDXlu4
	 tR85MVdOrK/JrBGDLh0nBLrJ8NrPnsbHLSVUw8zT/e4bNtjyfHXBti93cknSDDOhA4NEn
	 +C62iXiYF5ZtSJPNHDF7pr9nv/KCD/PWjSClYtAlYP5tL0GKsIXMFPtMbDh1U22cipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+zhuZqq/+ahClyJW0b+N6APkmJNtRsR/M9j5N1vGBg=;
	b=qDFDr3H49wKGuIBfiBnGeV7pPAgSXXAgmDdaA19n+V2jQ81LbbeWtSFJuarYS7gVBuKa
	 sxvZjVuEr8QyXVzn8v7TgeHPCm8PSsH4qMyx/4LTx26g4uG3zfxr6kmIP40IbiaILlVAw
	 2Vrrp07QF+YpNZCuDe2ylbVNROl5kI/2jeBzWBq8o3t1YMMBssvCpecYbl6c+MRtarEsh
	 6CZPP/R9yXPpPgwekxrqSjml1+eVruFWWSPP2WQQJkVa2bvTuXaJIYyTD/njKXhyLCqrq
	 onb7N2QrZMgNHZHj3/RlYBnIPK9jeweMy9bnwTq0I2HVXMk8hr93a95f8RFO/S9xfqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cotNyyuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4798606A31C;
	Thu, 26 Nov 2026 14:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cotNyyuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC481F000CA;
	Thu, 26 Nov 2026 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704155;
	bh=F+zhuZqq/+ahClyJW0b+N6APkmJNtRsR/M9j5N1vGBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cotNyyuLHInBAcwsMzqMSKziIHew4dWFd9Iq+kgXf8119yvCWfAxx/H0OvqS5baDA
	 FKOpe/hCb8Ybe5II703g+MLktAW2H2ByPrcAfZojVl9ZgxJp4W4tmVD3BqPTv7D1EW
	 gDmz2JpHn1rs9C/IYB6zjyrY/addNjZ00vmtWydk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/265] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Thu, 26 Nov 2026 15:35:55 +0100
Message-ID: <20261126143606.844958477@linuxfoundation.org>
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
index a6b18547df7d7..769d28be09d4c 100644
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



