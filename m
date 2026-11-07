Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060856;
	b=21TAozu7NSVsKoIrlV7Snxm6LJLhtWigSlbdT51auu/etnPPMGCvwp+0KN0OTsdVvUIr
	 Cw7wU/rvkkeCy6URjqzvv6FpuVUwGhjTJzWIrnyrH6RKaK6p80cCTYYaxLPSwQ2l5G0Wp
	 4Vt8IqdxtiMF48Zb2whkCSzU/hKQFYHasZJYlAMiFeNJMcRGiVc06XGUpQR0pth5A/l1p
	 FxfmNvLbMXLIbfKhy37CJrgeaJs/gvwEMgfk99NnkmtxFbM5KZKoOCkC4vZ51SF6g1BuY
	 TBMUM3X46g7P3m5bl3vmFvE+P3O3ijOGUYG2exDqQahBNeEQknAs16R5Avru4DOSVfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vo3Vw54tJVCF1E75b4x60phq7cbrQ51xIFcCna3AgTk=;
	b=utKM4yo7CAsxIzuIuPARcwWYTuXSuuY0HK2ywIaZedOLrAedlBNioSXen8CsiUAV99y4
	 ahWsxjuus360sZBtVD91yQLbV0w3XeDHr8r0sEWYfdFXlzbMjH4QLBausmVI0nS814Ovq
	 FAqIIFB9PqERBH/XxhT5la1I6cT2fvLcYu9uTOa25HQ/IaFt9SNg5A+vv/ipm7yMvn+2N
	 rU/Dd4JxRaM5nNUcB14BJyR6FI/K+/2zmQj0z57pyz5rX8SB6R42xW5Elostl3no14Y/g
	 +IWuXRwPR2RHdpsmC/wlFC7BSH0eL4uZI2bxSmOUbRCxajT2+1cg91rxa7qYhYrWPaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh0oNqVA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D751606A330;
	Sat,  7 Nov 2026 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh0oNqVA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ACA1F0089F;
	Sat,  7 Nov 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060856;
	bh=vo3Vw54tJVCF1E75b4x60phq7cbrQ51xIFcCna3AgTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sh0oNqVAEV6p7TF/ijoPJn31I9OA5wpxVTo0nMYOhcWRbkQEuZp22dg1tpiOndJ7S
	 AQayTP3LNnE/bDxmcMwLLZZqwhnqu5VHlNo3vff+8RH2h6hqakbDkGc5v9fexkixW0
	 SED9YSFiQobngspx09FxvZvguWro58cKOuSbGYzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0240/1536] nvmem: brcm_nvram: fix out-of-bounds access on malformed flash data
Date: Sat,  7 Nov 2026 08:37:36 -0500
Message-ID: <20261107135004.414131899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a67e2c323a47a2254ed3472b5e4c53abac20f116 ]

The length check in brcm_nvram_parse() validated header->len against
priv->nvmem_size (the full partition size) instead of priv->data_len
(the actual allocated data buffer). A malformed flash partition with
header->len between the two would pass the check, causing
brcm_nvram_add_cells() to read and write priv->data[len - 1] beyond
the heap allocation.

Also add a minimum bound: len < sizeof(*header) could underflow the
data[len - 1] access.

Fix both bounds by rejecting len outside [sizeof(*header), priv->data_len].

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260729094647.111468-14-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/brcm_nvram.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvmem/brcm_nvram.c b/drivers/nvmem/brcm_nvram.c
index 6a142f8feac39..3e85b6e6447ca 100644
--- a/drivers/nvmem/brcm_nvram.c
+++ b/drivers/nvmem/brcm_nvram.c
@@ -192,9 +192,13 @@ static int brcm_nvram_parse(struct brcm_nvram *priv)
 	}
 
 	len = le32_to_cpu(header->len);
-	if (len > priv->nvmem_size) {
-		dev_err(dev, "NVRAM length (%zd) exceeds mapped size (%zd)\n", len,
-			priv->nvmem_size);
+	if (len < sizeof(*header)) {
+		dev_err(dev, "NVRAM length (%zd) too small\n", len);
+		return -EINVAL;
+	}
+	if (len > priv->data_len) {
+		dev_err(dev, "NVRAM length (%zd) exceeds data size (%zd)\n", len,
+			priv->data_len);
 		return -EINVAL;
 	}
 
-- 
2.53.0



