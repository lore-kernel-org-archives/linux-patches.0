Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC488171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D005C433EF;
	Mon, 22 May 2023 19:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783236;
	bh=dR4nFbugv7TJ1HO3JKI8Fa1rD5eHjG3p6arlaF/QN3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oi24rlTIB9IcO2nmrr03smFio8/An/dt4Z/s8BvvWLP3ZpFZxNM0GwseDj+iC6/a7
	 cHydj2rgSrXNClWFLNgQ6RxUtCJIVNl+C3zVgcOMY3fokT6fQOSQZ8AevYst7Icikm
	 hilufn7tokdiRvuLvqfs4IlrqLl5LWzKuoR/ios8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 156/203] igb: fix bit_shift to be in [1..8] range
Date: Mon, 22 May 2023 20:09:40 +0100
Message-Id: <20230522190359.294059792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit 60d758659f1fb49e0d5b6ac2691ede8c0958795b ]

In igb_hash_mc_addr() the expression:
        "mc_addr[4] >> 8 - bit_shift", right shifting "mc_addr[4]"
shift by more than 7 bits always yields zero, so hash becomes not so different.
Add initialization with bit_shift = 1 and add a loop condition to ensure
bit_shift will be always in [1..8] range.

Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/e1000_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 1277c5c7d0996..7be0c7ce9394b 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -426,7 +426,7 @@ void igb_mta_set(struct e1000_hw *hw, u32 hash_value)
 static u32 igb_hash_mc_addr(struct e1000_hw *hw, u8 *mc_addr)
 {
 	u32 hash_value, hash_mask;
-	u8 bit_shift = 0;
+	u8 bit_shift = 1;
 
 	/* Register count multiplied by bits per register */
 	hash_mask = (hw->mac.mta_reg_count * 32) - 1;
@@ -434,7 +434,7 @@ static u32 igb_hash_mc_addr(struct e1000_hw *hw, u8 *mc_addr)
 	/* For a mc_filter_type of 0, bit_shift is the number of left-shifts
 	 * where 0xFF would still fall within the hash mask.
 	 */
-	while (hash_mask >> bit_shift != 0xFF)
+	while (hash_mask >> bit_shift != 0xFF && bit_shift < 4)
 		bit_shift++;
 
 	/* The portion of the address that is used for the hash table
-- 
2.39.2



