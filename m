Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A03419D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdGjEnln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53332C433C8;
	Mon,  9 Oct 2023 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859149;
	bh=onaXuYdTjSvG7AzGael1uwn/NwzGqdwVeEzgs7AZX7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdGjEnlngbpn3sQt7t+Kcr3SDCUi0njlITvE0fCJJybM16RN1f7MgVmiy43zG2QKP
	 TTNGulRviTU6eUYf9Iq4MO4eBBJeLv+gfSNgoOngJwnytwSMY4Liy7lvTvcUK0CadD
	 76tQ6RYKyoS1mLH+rSnU77uT5cesMx0h8M0Aft5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/226] wifi: iwlwifi: dbg_ini: fix structure packing
Date: Mon,  9 Oct 2023 15:02:28 +0200
Message-ID: <20231009130131.506997372@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 424c82e8ad56756bb98b08268ffcf68d12d183eb ]

The iwl_fw_ini_error_dump_range structure has conflicting alignment
requirements for the inner union and the outer struct:

In file included from drivers/net/wireless/intel/iwlwifi/fw/dbg.c:9:
drivers/net/wireless/intel/iwlwifi/fw/error-dump.h:312:2: error: field  within 'struct iwl_fw_ini_error_dump_range' is less aligned than 'union iwl_fw_ini_error_dump_range::(anonymous at drivers/net/wireless/intel/iwlwifi/fw/error-dump.h:312:2)' and is usually due to 'struct iwl_fw_ini_error_dump_range' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
        union {

As the original intention was apparently to make the entire structure
unaligned, mark the innermost members the same way so the union
becomes packed as well.

Fixes: 973193554cae6 ("iwlwifi: dbg_ini: dump headers cleanup")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230616090343.2454061-1-arnd@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index cb40f509ab612..d08750abac953 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -334,9 +334,9 @@ struct iwl_fw_ini_fifo_hdr {
 struct iwl_fw_ini_error_dump_range {
 	__le32 range_data_size;
 	union {
-		__le32 internal_base_addr;
-		__le64 dram_base_addr;
-		__le32 page_num;
+		__le32 internal_base_addr __packed;
+		__le64 dram_base_addr __packed;
+		__le32 page_num __packed;
 		struct iwl_fw_ini_fifo_hdr fifo_hdr;
 		struct iwl_cmd_header fw_pkt_hdr;
 	};
-- 
2.40.1



