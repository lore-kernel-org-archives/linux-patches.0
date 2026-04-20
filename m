Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD4E33F586;
	Mon, 20 Apr 2026 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700259; cv=none; b=fz1TAvGxzgpuYAWiEw5G9P0h3ZyEcltduO6vnWN/8at76QoCkMyuTCX47ygT1otDWi5grrJ+pIt4qxk/dE3/p7pckJ1VBcKv7K8O0kDZoEbXrl/8zAG/gG5w4ZsnmKt9RFjlOB5E5lsKMhBx3WiGO9DwD43xFH1E55L/44WOng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700259; c=relaxed/simple;
	bh=RP9wwhHEyM83k2VsQ23rKCrndKsTiGKa/nfgIZjQ5Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALMJU0JiVrkEd8Sac3UYuEZ3z8nSzRvnnVQM70pizkRD8Pf2gRghIFZ34CVQCqBAJ4I1eaiz49BpzSEhDlDyTUnAR352GyXPoOwa6O21rs7a2A3rBhCZ6F3WG049SbqjFhmm/3uSdtnJ1nwgDxo556fyHpMhRv6A46PBWujyXvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiFcx8Nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiFcx8Nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC2C19425;
	Mon, 20 Apr 2026 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700258;
	bh=RP9wwhHEyM83k2VsQ23rKCrndKsTiGKa/nfgIZjQ5Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiFcx8NvyYMJqkzfrjEllfRAvHaYzNexCDrBX8wCiAbRaAn9gu6Z+abCcK7yLKU3K
	 LymzGKRiYSwxVRcW2jVTcUklIkCCxDVqFKa8fZcHKfegOsXwevtHT30Ayon5jgO9Wr
	 51a78X9kXLOIv0bLMeXGsKui+BTGZpiIonevD7t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iskhakov Daniil <dish@amicon.ru>,
	Agalakov Daniil <ade@amicon.ru>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 101/220] e1000: check return value of e1000_read_eeprom
Date: Mon, 20 Apr 2026 17:40:42 +0200
Message-ID: <20260420153937.672435960@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Agalakov Daniil <ade@amicon.ru>

[ Upstream commit d3baa34a470771399c1495bc04b1e26ac15d598e ]

[Why]
e1000_set_eeprom() performs a read-modify-write operation when the write
range is not word-aligned. This requires reading the first and last words
of the range from the EEPROM to preserve the unmodified bytes.

However, the code does not check the return value of e1000_read_eeprom().
If the read fails, the operation continues using uninitialized data from
eeprom_buff. This results in corrupted data being written back to the
EEPROM for the boundary words.

Add the missing error checks and abort the operation if reading fails.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Iskhakov Daniil <dish@amicon.ru>
Signed-off-by: Agalakov Daniil <ade@amicon.ru>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 726365c567ef3..75d0bfa7530b4 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -496,14 +496,19 @@ static int e1000_set_eeprom(struct net_device *netdev,
 		 */
 		ret_val = e1000_read_eeprom(hw, first_word, 1,
 					    &eeprom_buff[0]);
+		if (ret_val)
+			goto out;
+
 		ptr++;
 	}
-	if (((eeprom->offset + eeprom->len) & 1) && (ret_val == 0)) {
+	if ((eeprom->offset + eeprom->len) & 1) {
 		/* need read/modify/write of last changed EEPROM word
 		 * only the first byte of the word is being modified
 		 */
 		ret_val = e1000_read_eeprom(hw, last_word, 1,
 					    &eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto out;
 	}
 
 	/* Device's eeprom is always little-endian, word addressable */
@@ -522,6 +527,7 @@ static int e1000_set_eeprom(struct net_device *netdev,
 	if ((ret_val == 0) && (first_word <= EEPROM_CHECKSUM_REG))
 		e1000_update_eeprom_checksum(hw);
 
+out:
 	kfree(eeprom_buff);
 	return ret_val;
 }
-- 
2.53.0



