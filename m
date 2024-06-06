Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E60199386;
	Thu,  6 Jun 2024 14:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683214; cv=none; b=cwt8DdpP0b05i4X3Ul9BJ4DgrCwPdUi+d2mL+sNqo9Vttqa2n7OmzxnPjoofUCFXtlPwjAvwda/0Tyqa4JeW/3mzT6MU0U/xdmATQOfhlKNc55uKDEzFNPskS4DX5hbclCrzqAK1+gO/OeKj7XaNth13mKOvIVPkMpfWFNaDgqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683214; c=relaxed/simple;
	bh=pc4TepDZRifszbojm5BKJOcmwLI4MaT4+/vIh+5KqQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pw6TDwna811vVoVugDgMHYiRxTPIf+jGPFvKGhM30vVM1edGRBEZJfEoXx3IReljFFyePWxtmsAyB404j04AeuaadEi0Hm60M8dtWGrWqe+oBrNXYGUedTj0G1ne4Tp5Wfxp5GhP2fdTAU0OpBo3LyfKoy6mCXYyeJCAQ6fg+N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyU0rQm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyU0rQm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8672C32782;
	Thu,  6 Jun 2024 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683214;
	bh=pc4TepDZRifszbojm5BKJOcmwLI4MaT4+/vIh+5KqQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyU0rQm1jdq5Yl4QPs+5Vh2bfh29F23yTYltq0vz5QQd3MJqaQNJvJoMGNp1idzTv
	 jnhRvzekh1r0MbFKah1JTuPhblRJzxq8O/o91MMKyvcIXXNBfFzp3e2snv2tAGFxLZ
	 +QmjWyzhxWu6PQ9dMLU/VAInQ5aiEg1KUt61cAhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/473] wifi: brcmfmac: pcie: handle randbuf allocation failure
Date: Thu,  6 Jun 2024 16:00:20 +0200
Message-ID: <20240606131702.920586186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3b1277a8bd617..99cc41135473a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1640,6 +1640,15 @@ struct brcmf_random_seed_footer {
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
@@ -1682,7 +1691,6 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 				.length = cpu_to_le32(rand_len),
 				.magic = cpu_to_le32(BRCMF_RANDOM_SEED_MAGIC),
 			};
-			void *randbuf;
 
 			/* Some Apple chips/firmwares expect a buffer of random
 			 * data to be present before NVRAM
@@ -1694,10 +1702,7 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
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



