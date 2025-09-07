Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C69722F74D;
	Sun,  7 Sep 2025 20:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275668; cv=none; b=kzoOjbGYr2/0h+rjvIINtasDN6XsnOSPQjfkF/lbNhHLpzHjV3huzrotlZTkjBHdnA5IOp1y2yudVzXzW1a0mKUHEKcftgvqd75P9Xn4GSIFANN6FjNrbNKBeNnStN9gifN1B9iWfE8GYGR6Ou/gVYUM9fAmsU5/AE1qe//7240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275668; c=relaxed/simple;
	bh=5trj6v4aER9nP5BpB28RMibGEOLw/Mdcvj8Dfne/kso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZOhF3URkpSHlDPrNbrl/5OUo3UBDiy9tzCvZW/VoJ/fhuN5XGRvjP/4RuvzqnomPwIbDRWNg5QR8Z2HQnf6oQx5BlHHuT/RgxSEb0316N73oMxMHlX2ohGL5DdL3SfLDw5mXcUcBNDmSIg8i1EsBZoYZ4yInXb/Zw6xW8nqFK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHau/+n2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHau/+n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD507C4CEF0;
	Sun,  7 Sep 2025 20:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275668;
	bh=5trj6v4aER9nP5BpB28RMibGEOLw/Mdcvj8Dfne/kso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHau/+n2mA5LODEPAgjrgrBOtZK9R+mVCeYgG/6JYeo+5JOTH3jx5oM7rOw8d/GC3
	 /WXCWyI2SUNEOYAlFCox3tpbFM4N5wcRgB/ybEJ3rNAJRbhnvyzMKFPSdPDUONqNtu
	 Y+e7bOB9gysHTY+AP2wkds/KhiW5bGe3EALTzT/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Wessel <post@mikaelkw.online>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 26/52] e1000e: fix heap overflow in e1000_set_eeprom
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195602.752505443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

commit 90fb7db49c6dbac961c6b8ebfd741141ffbc8545 upstream.

Fix a possible heap overflow in e1000_set_eeprom function by adding
input validation for the requested length of the change in the EEPROM.
In addition, change the variable type from int to size_t for better
code practices and rearrange declarations to RCT.

Cc: stable@vger.kernel.org
Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Co-developed-by: Mikael Wessel <post@mikaelkw.online>
Signed-off-by: Mikael Wessel <post@mikaelkw.online>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -559,12 +559,12 @@ static int e1000_set_eeprom(struct net_d
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
+	size_t total_len, max_len;
 	u16 *eeprom_buff;
-	void *ptr;
-	int max_len;
+	int ret_val = 0;
 	int first_word;
 	int last_word;
-	int ret_val = 0;
+	void *ptr;
 	u16 i;
 
 	if (eeprom->len == 0)
@@ -579,6 +579,10 @@ static int e1000_set_eeprom(struct net_d
 
 	max_len = hw->nvm.word_size * 2;
 
+	if (check_add_overflow(eeprom->offset, eeprom->len, &total_len) ||
+	    total_len > max_len)
+		return -EFBIG;
+
 	first_word = eeprom->offset >> 1;
 	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
 	eeprom_buff = kmalloc(max_len, GFP_KERNEL);


