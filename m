Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E8715EFC3;
	Mon, 27 May 2024 19:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837835; cv=none; b=Qr1EfAsGOqVYkkw3lDLoMl8SZvXsVmQ/QufFDMogF06rzFx43F+Bq0Qx7kaq/SyjUQB7VNg53/SBKrsihzT9vzSm5N579PXTfzRc7Lgbqibo3jXmI/jWZcWl8laA1qfAcqyFOlcZRzJmf6oZZjfURUF/15Lg/5mAdo2o0YdYdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837835; c=relaxed/simple;
	bh=beXH7DVFVzfU3oNGLok66jpL6CeNs0heUBSLX6MPFjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5n1CRIFH9mUFRgmOt3e0Puog+H+9n85T5wdpxJ/8X/zcpyx2L8zzp1y4nOGf+BWjnaxH3GC1UFA0MLkrFR9jf9fy0kT3R52JiP/HBAG7mvszfm8BgUQ+cnG2i+UoFvIdua1fTRmjy5CQ1a5PBwVKg0Hj9+NFJBHgyVPa2Dv800=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xsEaKB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xsEaKB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93BBC32781;
	Mon, 27 May 2024 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837835;
	bh=beXH7DVFVzfU3oNGLok66jpL6CeNs0heUBSLX6MPFjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xsEaKB/Zbtef9hV5rZxK4pceOr0u0lt2qeI63l3IAixEQEYRXesNQTxDMr/vhy56
	 7pRa3zmZxOtdlZQ91Pk2avAIz0wgA4bLd/4ZCH8YbisQhHnd50oawgvgFtuqCJIqIr
	 tMa5qUpseRuXn1X7Vrk7fTKa0h55tPDVca3IdHqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 162/493] wifi: brcmfmac: pcie: handle randbuf allocation failure
Date: Mon, 27 May 2024 20:52:44 +0200
Message-ID: <20240527185635.681925213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 316f790ebcf94bdf59f794b7cdea4068dc676d4c ]

The kzalloc() in brcmf_pcie_download_fw_nvram() will return null
if the physical memory has run out. As a result, if we use
get_random_bytes() to generate random bytes in the randbuf, the
null pointer dereference bug will happen.

In order to prevent allocation failure, this patch adds a separate
function using buffer on kernel stack to generate random bytes in
the randbuf, which could prevent the kernel stack from overflow.

Fixes: 91918ce88d9f ("wifi: brcmfmac: pcie: Provide a buffer of random bytes to the device")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240306140437.18177-1-duoming@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index d7fb88bb6ae1a..06698a714b523 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1675,6 +1675,15 @@ struct brcmf_random_seed_footer {
 #define BRCMF_RANDOM_SEED_MAGIC		0xfeedc0de
 #define BRCMF_RANDOM_SEED_LENGTH	0x100
 
+static noinline_for_stack void
+brcmf_pcie_provide_random_bytes(struct brcmf_pciedev_info *devinfo, u32 address)
+{
+	u8 randbuf[BRCMF_RANDOM_SEED_LENGTH];
+
+	get_random_bytes(randbuf, BRCMF_RANDOM_SEED_LENGTH);
+	memcpy_toio(devinfo->tcm + address, randbuf, BRCMF_RANDOM_SEED_LENGTH);
+}
+
 static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 					const struct firmware *fw, void *nvram,
 					u32 nvram_len)
@@ -1717,7 +1726,6 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 				.length = cpu_to_le32(rand_len),
 				.magic = cpu_to_le32(BRCMF_RANDOM_SEED_MAGIC),
 			};
-			void *randbuf;
 
 			/* Some Apple chips/firmwares expect a buffer of random
 			 * data to be present before NVRAM
@@ -1729,10 +1737,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 				    sizeof(footer));
 
 			address -= rand_len;
-			randbuf = kzalloc(rand_len, GFP_KERNEL);
-			get_random_bytes(randbuf, rand_len);
-			memcpy_toio(devinfo->tcm + address, randbuf, rand_len);
-			kfree(randbuf);
+			brcmf_pcie_provide_random_bytes(devinfo, address);
 		}
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
-- 
2.43.0



