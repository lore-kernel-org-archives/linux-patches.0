Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A0AC433D2;
	Sun, 22 Jan 2023 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400891;
	bh=C8ElHUjdQeC2kVcCng3Vh2rLwiEFgfow98/Cq5Fhtcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZrxmSh3fPw6sfeyH8zTZeKARGgl5txp3ZJ53t9cdi41RRqfgQ9DSqsinujH3Rb2k
	 YO4UrKEp5ESpIkspmJlPpy23rZY5x0R3EQFQDJC61Z8p+B1uMh6AA/XWVGTIn2coVg
	 gqFAMt4ISjlFU3UrIhmKvIVnzh++wguqv/nv7XUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH 6.1 003/193] wifi: iwlwifi: fw: skip PPAG for JF
Date: Sun, 22 Jan 2023 16:02:12 +0100
Message-Id: <20230122150246.492734419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1c4c0b28b517d778d37900deedfe91088839f07a ]

For JF RFs we don't support PPAG, but many firmware
images lie about it. Always skip support for JF to
avoid firmware errors when sending the command.

Reported-and-tested-by: Íñigo Huguet <ihuguet@redhat.com>
Link: https://lore.kernel.org/linux-wireless/CACT4oufQsqHGp6bah2c4+jPn2wG1oZqY=UKa_TmPx=F6Lxng8Q@mail.gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221213225723.2a43415d8990.I9ac210740a45b41f1b2e15274e1daf4284f2808a@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index e6d64152c81a..a02e5a67b706 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -1106,6 +1106,11 @@ int iwl_read_ppag_table(struct iwl_fw_runtime *fwrt, union iwl_ppag_table_cmd *c
         int i, j, num_sub_bands;
         s8 *gain;
 
+	/* many firmware images for JF lie about this */
+	if (CSR_HW_RFID_TYPE(fwrt->trans->hw_rf_id) ==
+	    CSR_HW_RFID_TYPE(CSR_HW_RF_ID_TYPE_JF))
+		return -EOPNOTSUPP;
+
         if (!fw_has_capa(&fwrt->fw->ucode_capa, IWL_UCODE_TLV_CAPA_SET_PPAG)) {
                 IWL_DEBUG_RADIO(fwrt,
                                 "PPAG capability not supported by FW, command not sent.\n");
-- 
2.35.1



