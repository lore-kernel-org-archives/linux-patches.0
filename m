Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B52737EB;
	Mon, 23 Mar 2026 15:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278478; cv=none; b=BNfQmXcsgUGWe8e6mjPoYDrnZmbUK7kJW8YDVhZe22Pb6e5VUedxYS7/pfQspp5K3NKgdmd8GwKbSs9RuED9eMTdRsQCwTCkL8+QXwWEkoX0rlF2mn9W7kjqt+CGNT8CipyjTDKAVChJEx7BUQySMLNEQrUktS5gQRDyrQ8VJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278478; c=relaxed/simple;
	bh=vLy3rpb6dcEgjU57YBxcxDFPJQIJDiLqAzXE4C08hjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETX6n+1jKOOfZUEbhDAwhQyJp64Hg3NUj6In7nkQ/B5ZCHXcfrBvCgoUqJ+w40TVhNH4gq/knWLr21bCk4KbpCVnYtzJzK7jnv7K8sRT1z96I7xe7retvuQTZFpfyGSjw/Qfhfh6aK6riAGFqpn6GTPpjgQdWitrUzd+erRkAug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQY1HzAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQY1HzAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E78C4CEF7;
	Mon, 23 Mar 2026 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278478;
	bh=vLy3rpb6dcEgjU57YBxcxDFPJQIJDiLqAzXE4C08hjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQY1HzAf9IRnKxj4pCQSOJiS0J6b166Bk866WyFghy+owbQdtppSPDpW9rQSw7JWb
	 C3c1SwJSq8UJuxUv5E1o591Vbhdk5lG4e9b1YlnZxqKekF4heMQ9TbImSULMIhdzpJ
	 WAYA9ohfprJXEKzgbsCL2In3BHFAl8JzYfblsu4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Staniszewski <jakub.staniszewski@linux.intel.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.6 318/567] ice: fix retry for AQ command 0x06EE
Date: Mon, 23 Mar 2026 14:43:58 +0100
Message-ID: <20260323134541.697091180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Staniszewski <jakub.staniszewski@linux.intel.com>

commit fb4903b3354aed4a2301180cf991226f896c87ed upstream.

Executing ethtool -m can fail reporting a netlink I/O error while firmware
link management holds the i2c bus used to communicate with the module.

According to Intel(R) Ethernet Controller E810 Datasheet Rev 2.8 [1]
Section 3.3.10.4 Read/Write SFF EEPROM (0x06EE)
request should to be retried upon receiving EBUSY from firmware.

Commit e9c9692c8a81 ("ice: Reimplement module reads used by ethtool")
implemented it only for part of ice_get_module_eeprom(), leaving all other
calls to ice_aq_sff_eeprom() vulnerable to returning early on getting
EBUSY without retrying.

Remove the retry loop from ice_get_module_eeprom() and add Admin Queue
(AQ) command with opcode 0x06EE to the list of commands that should be
retried on receiving EBUSY from firmware.

Cc: stable@vger.kernel.org
Fixes: e9c9692c8a81 ("ice: Reimplement module reads used by ethtool")
Signed-off-by: Jakub Staniszewski <jakub.staniszewski@linux.intel.com>
Co-developed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://www.intel.com/content/www/us/en/content-details/613875/intel-ethernet-controller-e810-datasheet.html [1]
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c  |    1 
 drivers/net/ethernet/intel/ice/ice_ethtool.c |   35 ++++++++++-----------------
 2 files changed, 15 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1611,6 +1611,7 @@ static bool ice_should_retry_sq_send_cmd
 	case ice_aqc_opc_lldp_stop:
 	case ice_aqc_opc_lldp_start:
 	case ice_aqc_opc_lldp_filter_ctrl:
+	case ice_aqc_opc_sff_eeprom:
 		return true;
 	}
 
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -4045,7 +4045,7 @@ ice_get_module_eeprom(struct net_device
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	bool is_sfp = false;
-	unsigned int i, j;
+	unsigned int i;
 	u16 offset = 0;
 	u8 page = 0;
 	int status;
@@ -4087,26 +4087,19 @@ ice_get_module_eeprom(struct net_device
 		if (page == 0 || !(data[0x2] & 0x4)) {
 			u32 copy_len;
 
-			/* If i2c bus is busy due to slow page change or
-			 * link management access, call can fail. This is normal.
-			 * So we retry this a few times.
-			 */
-			for (j = 0; j < 4; j++) {
-				status = ice_aq_sff_eeprom(hw, 0, addr, offset, page,
-							   !is_sfp, value,
-							   SFF_READ_BLOCK_SIZE,
-							   0, NULL);
-				netdev_dbg(netdev, "SFF %02X %02X %02X %X = %02X%02X%02X%02X.%02X%02X%02X%02X (%X)\n",
-					   addr, offset, page, is_sfp,
-					   value[0], value[1], value[2], value[3],
-					   value[4], value[5], value[6], value[7],
-					   status);
-				if (status) {
-					usleep_range(1500, 2500);
-					memset(value, 0, SFF_READ_BLOCK_SIZE);
-					continue;
-				}
-				break;
+			status = ice_aq_sff_eeprom(hw, 0, addr, offset, page,
+						   !is_sfp, value,
+						   SFF_READ_BLOCK_SIZE,
+						   0, NULL);
+			netdev_dbg(netdev, "SFF %02X %02X %02X %X = %02X%02X%02X%02X.%02X%02X%02X%02X (%pe)\n",
+				   addr, offset, page, is_sfp,
+				   value[0], value[1], value[2], value[3],
+				   value[4], value[5], value[6], value[7],
+				   ERR_PTR(status));
+			if (status) {
+				netdev_err(netdev, "%s: error reading module EEPROM: status %pe\n",
+					   __func__, ERR_PTR(status));
+				return status;
 			}
 
 			/* Make sure we have enough room for the new block */


