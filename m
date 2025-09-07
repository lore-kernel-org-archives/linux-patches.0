Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4307A1CDFAC;
	Sun,  7 Sep 2025 20:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276016; cv=none; b=pSCl/9gH8CFG5SOPF9dgthxuwKSu5YXiNA+aduoox1KPZ4hrv6TqKAYEmmn0dH8KOOF/N3No9217PxTkFjwDGazz7bMGgJmhX5voyNeQq5zipNRVphe8LRaf9NhD99PN+U1WkPmvPYNdW/QDylWfuv/5OwXaSOxpTcE21vEiumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276016; c=relaxed/simple;
	bh=ZeRYoxp85LaBoZb0wJZqWfA0SDdCkDjxz9Re5FAhe+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2tf5+BHyWM9K5L37W4XuHAmdHf+4IXCW/cxpk3Lh3/J2EhOC/lAP6kXG6iuA3g2o/FcserfEtdDU2YWkW3tZtxe5ewCOS65jGQKI7nRg1JAtCoHHODbfuCbfDIREkaiJkVuG+9qPV0i65JDmSaHN+YTB4oo4R30DA0diadYB3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDStG9VL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDStG9VL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76894C4CEF0;
	Sun,  7 Sep 2025 20:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276015;
	bh=ZeRYoxp85LaBoZb0wJZqWfA0SDdCkDjxz9Re5FAhe+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDStG9VL5SK1zDlXZ04GJtoIEi2XGEi/aBxu7DNo1Z1D1FdimHykZ0DhwRlmEKSxz
	 h4qDqSlt0EbcQbUIbamO1v3kUs2p3a03Q+2rV97Wux8TKGrp0+xIcjaakqUeM/n2NT
	 b3saZjUsPRadIRzsl96WOux4kGExXu0RmDQTmctk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Wessel <post@mikaelkw.online>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 37/64] e1000e: fix heap overflow in e1000_set_eeprom
Date: Sun,  7 Sep 2025 21:58:19 +0200
Message-ID: <20250907195604.427742160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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


