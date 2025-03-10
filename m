Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3910B1C5D6F;
	Mon, 10 Mar 2025 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630842; cv=none; b=egasfizTXAtgUR7Uwr8JzIFhC++3C1AG8lXvhmTHDdp7aiVAf1i/aZifjZO7XetiqMvVQCK8uh6/Kg5dPF5F1nnaWBDL0LRQrCcFMvAFLe5ogeVk9TuKw6QuRs1AwyX2GzbEUjB1TlTsfFAtT1dbCos0c9phDDHN+92XuJRFPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630842; c=relaxed/simple;
	bh=vmyymX6mrwJeiBDePQhSVHQfTBZ6IJIGVcnBD8c1CIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6nF2/y+FXYOhEqgQemr5/FfBfPEDmnEZrXCXowguCqFZEPuoGBmu8jqoSurCX54/8YZHH25lPg1tw3DobrbNtIGg2r086EIduyBf48zT5rhmyNfyGteBMyBkzUN8AZhqJ9AGbxXsqbAmN0HkwOwm9zaPncfcYqU0OKlB6/OnmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxkBfGmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxkBfGmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88426C4CEE5;
	Mon, 10 Mar 2025 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630842;
	bh=vmyymX6mrwJeiBDePQhSVHQfTBZ6IJIGVcnBD8c1CIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxkBfGmpNzjCRVLO27tMopuSdYU7ZnVZ/M7KH6rnR3d2dJ/wNRHYmdBFFVEQeef00
	 4QdgSTpsvQegGHAYiodqJPT9dhtRyy3BdTEngzFUNjZziMQlSgg6eUyzYJs7p7IfLI
	 7YABtZBTO5XVZGdT10nI/14P1KZ2VrQj1Jbu7NoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 552/620] wifi: iwlwifi: limit printed string from FW file
Date: Mon, 10 Mar 2025 18:06:38 +0100
Message-ID: <20250310170607.332503939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e0dc2c1bef722cbf16ae557690861e5f91208129 ]

There's no guarantee here that the file is always with a
NUL-termination, so reading the string may read beyond the
end of the TLV. If that's the last TLV in the file, it can
perhaps even read beyond the end of the file buffer.

Fix that by limiting the print format to the size of the
buffer we have.

Fixes: aee1b6385e29 ("iwlwifi: support fseq tlv and print fseq version")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.cb5f9d0c2f5d.Idec695d53c6c2234aade306f7647b576c7e3d928@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index afa89deb7bc3a..144aa1825286e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1071,7 +1071,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5



