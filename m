Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056169;
	b=UsHGKbZRQfzzdE2c0tXxzi6USvXVkfh0NwM7zLfS4NjhkBu+Tr+h7W3CLPFQvaPTTBLq
	 QFZlPvcP95IiGUGwtoGldcalKoK5bEA7CvaXWjB46E3nNkpWV91C72meezKlJ65bOD+f9
	 yLhXsrhsCmLIe42yXLR3QuYOffENS+nV2HRdZSV/UKbKg6kogOfokekkCZ0oT9S9ezrdr
	 oekDgWDtj0yoTPRgz8kz8Jx1osdDDlhmoAk6jDzf+oDmTuTWrhqz4rNkCZtnpN/+65k3t
	 1lfBVXUTADE6ptUMntfMcw9gzB6g9j4Cx4cPONwfFOHhxpYpdQtpOnx0C10K+2imd6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXxmlpZy/Mx3DVEZ5h8/kdCPFtDHUajzmC5I6ld7FRs=;
	b=gXOTY1wwvKxasMurTGM7UrNd7SpFF2YPPbY17fy4UCzF/7PKuPbAkOmvcrWXOkvrYSQ/
	 hZ7S3V1MWFQ4Em1d2Y/5jE8kCB09m1NyG1AidrYFHDmjnw1Hy29npxydVA6XB3Rnmf374
	 NbqywF1KPTYkfHD1Pa4RkpRybMr5ceO8GhkhEGKBQAxlaJSXdbpJurfVwOovBmt7R9pHY
	 rnYV9Em2XpvcwYNV+mA9IGU5Gu9n7CIV2RXQn5cTgUVd6dpUcrlxAy5adAgxdy4ML1lw0
	 jdvKqiqfJ+mEEzbGXY7DJ2nevWvYD5mzLC832f4TlWgnSpEiHiCwrl6bqGIYSulkVNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibzQZipU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B11D606A320;
	Thu, 19 Nov 2026 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibzQZipU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C3C1F000C5;
	Thu, 19 Nov 2026 02:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056169;
	bh=eXxmlpZy/Mx3DVEZ5h8/kdCPFtDHUajzmC5I6ld7FRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibzQZipUo3bIH+ihWEvuezMS+SyJMb6NPBq4kC1axi56cJ1HnskfTWkxKinLT1O5t
	 t7O9tE6YIzAS6xlx+2tq9JqJQ/MtPI5ozwO3KfzG03mA1lZW+9OICbsdrhWdDl8irI
	 Blp/i+lC0EFCxwbcOBFfN6C0aTaslqCXafOU+ZKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1891/2214] ASoC: amd: renoir: Fix acp_pdm_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150126.848277916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a92571113ef297840270e4d8d4263a842302c9c4 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_pdm_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 4a767b1d039a ("ASoC: amd: add acp3x pdm driver dma ops")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 6f4953a758013..22c470ca81d91 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -227,7 +227,7 @@ static int acp_pdm_dma_open(struct snd_soc_component *component,
 
 	pdm_data->acp_base = adata->acp_base;
 	runtime->private_data = pdm_data;
-	return ret;
+	return 0;
 }
 
 static int acp_pdm_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



