Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01641A0BFD;
	Sun,  7 Sep 2025 20:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277210; cv=none; b=PLLtrP7cOZjAs5LVy8mdsoQaXH4uau+PH+SV0gSgcIvbIlQu1Ii9EVzeFcDL7hYZ/LREKYqphown+SMW55sU+ypqE5BGEwr0Py+ugc9ovJgbTmm7GXrHUVYtIqosdzEqeXq3/T7GzPxIcPVNmZzY8QBq1E+Tu4T5jQjeuPMuhhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277210; c=relaxed/simple;
	bh=LpBpWtQ+J0lXpM0geiBAJAHLT+IGWuBKX64nabaIRIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTpG8dP9yNSD4Ivh5wT0ZfZopkmFOR84xGjJ9WKnuNm7bXphH3/MtHttuMdfn4TGXwu7fS46jItc0/PAvBTwBKQ5LY2uleWPsREte2pKszrB4eaHmYN9fozZB16jLRVlDITYkLhjj82FcTO94LUXA6+OQP3Wo9oFQhdnYVOqEK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDwc+RD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDwc+RD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD85C4CEF0;
	Sun,  7 Sep 2025 20:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277210;
	bh=LpBpWtQ+J0lXpM0geiBAJAHLT+IGWuBKX64nabaIRIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDwc+RD8eRke0j+SsGYl2KwC2s7LiRDL9ZxY9i7h9zJlPBkrWWLoC5bgByQeWQ+md
	 q1CqGM8AX+lrg/vzi6Qr8mPOsfcMjLEKBbtrx/Na260rp0d9J35zrjNW1fXC/mVQRQ
	 ThGzTPYJcGGnc2i9jAnlner8BTJk8DGtfHv6EhJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikael Wessel <post@mikaelkw.online>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.12 119/175] e1000e: fix heap overflow in e1000_set_eeprom
Date: Sun,  7 Sep 2025 21:58:34 +0200
Message-ID: <20250907195617.673884480@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -549,12 +549,12 @@ static int e1000_set_eeprom(struct net_d
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
@@ -569,6 +569,10 @@ static int e1000_set_eeprom(struct net_d
 
 	max_len = hw->nvm.word_size * 2;
 
+	if (check_add_overflow(eeprom->offset, eeprom->len, &total_len) ||
+	    total_len > max_len)
+		return -EFBIG;
+
 	first_word = eeprom->offset >> 1;
 	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
 	eeprom_buff = kmalloc(max_len, GFP_KERNEL);


