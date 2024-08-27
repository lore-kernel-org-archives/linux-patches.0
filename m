Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104D815F41B;
	Tue, 27 Aug 2024 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770104; cv=none; b=rh8EG9s4po1IxtAWT//ognUzxdY3SrLiYwj8PS7W1ASpRfWn4uroK12YTN6253FwqCiRV0KVwbQDzuEKEHyn3lqs2mm6kTyJ8TsTdOXtwKHURmRVnDf+t2fDi9Uk8tRlU0A6InWKibb2qiDNusVrOWn9uarinHOX9rgfqhctdNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770104; c=relaxed/simple;
	bh=LF57fYmxzq5SzGca3b0NMPztE5XUpVzt/e8hWtWmGyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SP7jUloVeS/ZlLn36/yjpsudvoBNZUVuyYF/2fr6GNd2OBMK3Ol8dtb5DnAtRTJxO376Uvd7tucD49Q5JP4xbQdK1ksE4KS49NbEzzPJVB1Us98xxnfbHIrI0gqOLrIw+7atCR2z21A9DOhq3gF0PQVaeWPenvtxQ3kvVk0LyNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2sbm/Yn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2sbm/Yn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0163C61047;
	Tue, 27 Aug 2024 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770103;
	bh=LF57fYmxzq5SzGca3b0NMPztE5XUpVzt/e8hWtWmGyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2sbm/Yny2lfa/ddHP7zUlu0mz6BMRka0Ub5o3Dz/aZWsEOUxdFpAk56gOv49vn+P
	 h1Db5Pe65Gv9uYJ3rzeVMR+2joF5sZ9SS+XB0/LlAMJJ35DASGISsHUBZPWVtrwJh2
	 dYqfyKPWVPVTJpOT+ZXTSWpa1T76KMmgtDfk1HPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/341] wifi: iwlwifi: check for kmemdup() return value in iwl_parse_tlv_firmware()
Date: Tue, 27 Aug 2024 16:36:00 +0200
Message-ID: <20240827143848.325576605@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 3c8aaaa7557b1e33e6ef95a27a5d8a139dcd0874 ]

In 'iwl_parse_tlv_firmware()', check for 'kmemdup()' return value
when handling IWL_UCODE_TLV_CURRENT_PC and set the number of parsed
entries only if an allocation was successful (just like it does with
handling IWL_UCODE_TLV_CMD_VERSIONS above). Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231009170453.149905-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a56593b6135f6..47bea1855e8c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1304,10 +1304,12 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 		case IWL_UCODE_TLV_CURRENT_PC:
 			if (tlv_len < sizeof(struct iwl_pc_data))
 				goto invalid_tlv_len;
-			drv->trans->dbg.num_pc =
-				tlv_len / sizeof(struct iwl_pc_data);
 			drv->trans->dbg.pc_data =
 				kmemdup(tlv_data, tlv_len, GFP_KERNEL);
+			if (!drv->trans->dbg.pc_data)
+				return -ENOMEM;
+			drv->trans->dbg.num_pc =
+				tlv_len / sizeof(struct iwl_pc_data);
 			break;
 		default:
 			IWL_DEBUG_INFO(drv, "unknown TLV: %d\n", tlv_type);
-- 
2.43.0



