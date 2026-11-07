Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063364;
	b=okJtnsQIHcuUHymiWbhUZDoMmCisCqzlT8N+MrT6MZoqL7ve7GDh650PPJyq/40IoseX
	 C47ymyyAO1AHzea201G1N6Lm365AQTihoj7dpgPP3jxgYpqhupSIcG2r5R97hZKKCAEaw
	 5yTkL7o//49Yn7l3wra+pfcikNGocUjPQonfd77cxQQl+0+rLf7LY7nAHK8+YoJD7kTBH
	 YQ9D9OoV1Py2/yAQa7DFJgxadHQ/oAHImcjpdW/rGAFIlrd/73GmlInWU9iPa9HNTu25a
	 /OvZjCzM+kh0nNdfJhIUKXAAeuIQ4sNL0lW5mBfbVloC/b2EgFf0EBIF3jaJerEEXrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s3L+OJiZXs56tzMxiZdSFBQUQ6+P8S/tmhQjbpVfJwY=;
	b=EoGW3zhP5DM0FMJ8JaXsC2HKg3LeDLbHGhgeZI9bpSxweI6iBJQlBpi1lkODhqn+HOtY
	 APMzOD4x3S/0InUlRadZtBX9DtMOjWXbRzi8uUCA6TW4glAlUf5Ly87Xjc07nKs6ATJ1f
	 IxA09NPUOZJfggOIKMHYyg4+T62ysOuWR9Yn1jKpcPCr7RXWEysSIFlw3xwawdOcP1z1k
	 rspYODFWcBqCu9hlaSKRSiFH1KwDVzS4OHHjUIhGY/3xGZYl0UGPeJaC0iEZ+s1fdfS85
	 skWQkYZaIyd5i1Qhj48LazGn2WcSQSEuG9jdeY+AzqaDfKYJS30esHTE0UulFs78fmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kctN/VlU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD143606A330;
	Sat,  7 Nov 2026 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kctN/VlU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696F71F0089F;
	Sat,  7 Nov 2026 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063363;
	bh=s3L+OJiZXs56tzMxiZdSFBQUQ6+P8S/tmhQjbpVfJwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kctN/VlUHwKsm+gf8kL2f3DjUYeoTe3qKWqsTTbwG9JiQ4+LxSXow+bT1yWqikzo8
	 fu+DxR3Hw5eHLDKa4BSdlg11nL2cOpSaZ8vkTx80symdx8VpXH5dpOa0fcbLhglc3b
	 r589udQyapOrjVCQOAZJlT1KLEvKLAED9EC3Fppk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 541/869] ALSA: cs46xx: fix unit mismatch in DSP code area bounds check
Date: Sat,  7 Nov 2026 08:53:43 -0500
Message-ID: <20261107134911.758570280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit fd65108f5001ffb416dc9bd37ec1893f55cff24a ]

ins->code.offset and code->size are measured in 32-bit words, while
DSP_CODE_BYTE_SIZE is the size of the DSP code area in bytes. The
check ins->code.offset + code->size > DSP_CODE_BYTE_SIZE in
cs46xx_dsp_load_module() therefore allowed up to four times more code
than the code area can hold.

The shadow buffer ins->code.data is allocated with
kmalloc(DSP_CODE_BYTE_SIZE), i.e. it holds DSP_CODE_BYTE_SIZE/4
words. A firmware file with a code segment larger than
DSP_CODE_BYTE_SIZE/4 words (28 KiB) passed the check and caused an
out-of-bounds write in shadow_and_reallocate_code() and an
out-of-bounds read in snd_cs46xx_download().

Compare the sum in words against DSP_CODE_BYTE_SIZE/4 and cast it to
u64 so that the sum cannot wrap for large code->size values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Link: https://patch.msgid.link/20261014102619.16415-1-arefev@swemel.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/dsp_spos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 3d34575a0e8f6..ba290f3a50e43 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -395,7 +395,7 @@ int cs46xx_dsp_load_module (struct snd_cs46xx * chip, struct dsp_module_desc * m
 		dev_dbg(chip->card->dev,
 			"dsp_spos: module got no code segment\n");
 	} else {
-		if (ins->code.offset + code->size > DSP_CODE_BYTE_SIZE) {
+		if ((u64)ins->code.offset + code->size > DSP_CODE_BYTE_SIZE / 4) {
 			dev_err(chip->card->dev,
 				"dsp_spos: no space available in DSP\n");
 			return -ENOMEM;
-- 
2.53.0



