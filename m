Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D0E154A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDA2C433D2;
	Mon,  8 May 2023 10:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540492;
	bh=SXPu0ZK+xVCHUr18bqc5J5bNBEsYhCD0P47GsAePr9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlX6ItXqm7guuimeGtuD7Wb2OeSSXzGvNq6YlFp41y9xvU1Uz57knzzBeQuSQlKHZ
	 JxOze4C4knHzf0rifcmU6Q7kurfr2ScFGEx3x2VqpmfC8xT1EZTuxj0GFbP+8WY9cP
	 tXhn+bO904F9Dm/PpZSvnTLTpdLzUIAOgdERLesc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 354/611] wifi: iwlwifi: yoyo: skip dump correctly on hw error
Date: Mon,  8 May 2023 11:43:16 +0200
Message-Id: <20230508094433.907645348@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 11195ab0d6f3202cf7af1a4c69570f59c377d8ad ]

When NIC is in a bad state, reading data will return 28 bits as
0xa5a5a5a and the lowest 4 bits are not fixed value.

Mask these bits in a few places to skip the dump correctly.

Fixes: 89639e06d0f3 ("iwlwifi: yoyo: support for new DBGI_SRAM region")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413213309.df6c0663179d.I36d8487b2419c6fefa65e5514855d94327c3b1eb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index abf49022edbe4..bde6f0764a538 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1038,7 +1038,7 @@ iwl_dump_ini_prph_mac_iter(struct iwl_fw_runtime *fwrt,
 	range->range_data_size = reg->dev_addr.size;
 	for (i = 0; i < le32_to_cpu(reg->dev_addr.size); i += 4) {
 		prph_val = iwl_read_prph(fwrt->trans, addr + i);
-		if (prph_val == 0x5a5a5a5a)
+		if ((prph_val & ~0xf) == 0xa5a5a5a0)
 			return -EBUSY;
 		*val++ = cpu_to_le32(prph_val);
 	}
@@ -1562,7 +1562,7 @@ iwl_dump_ini_dbgi_sram_iter(struct iwl_fw_runtime *fwrt,
 		prph_data = iwl_read_prph_no_grab(fwrt->trans, (i % 2) ?
 					  DBGI_SRAM_TARGET_ACCESS_RDATA_MSB :
 					  DBGI_SRAM_TARGET_ACCESS_RDATA_LSB);
-		if (prph_data == 0x5a5a5a5a) {
+		if ((prph_data & ~0xf) == 0xa5a5a5a0) {
 			iwl_trans_release_nic_access(fwrt->trans);
 			return -EBUSY;
 		}
-- 
2.39.2



