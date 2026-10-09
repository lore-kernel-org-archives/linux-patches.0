Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F74C6507;
	Fri,  9 Oct 2026 14:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557253; cv=none; b=EjOv/nYb1O6U3LZjB2xnU8dnFFZv4xBNYVr4O9WKYpfDBHg3y+uwbDxvJYLA8G2YRSOZ3UTrEM9SzGpgdYLTe49C/oSixCb8ZlbKMInP1PR8iT6KC5uZm3c0NeIG1LKyrRDbCr+a/4/Dq2CyanZo/T/tY41tskzqtUMTU7xMTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557253; c=relaxed/simple;
	bh=x5vHKuACRozad0kbm5D1s622L4lgdFmofIIG/d/0SNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwbVLBAcPd3KoquIu+qa7+nXY6b3Nj9i9PVRuMjIn8SezQ0loI0NUOM1OVLCDP/8nnHOEe7OUamHBuL5f4u/LA5hsbYVgC4VUzcs3OGD3Q90+RTsE3O6z4efB9GULUtnElf7tPraWNQFftwlPnmtxrMv7fbxLrDt1Wt8UxZS2qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgJ+vCmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgJ+vCmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23281F000FF;
	Fri,  9 Oct 2026 14:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557252;
	bh=+LT/GvsQOYIpIWDTgEOUCyqLGknUUjuZtbN7GwlXcMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgJ+vCmzrWKnH2xL/6DtZk4mu9PtlV+1clTRfXlQSTWVNr2RwTqABRMpzDNKXfHnd
	 tw9dFec25zNITBI/sdnrKXCHUkYsH3RZQA0JM4+X4IFbGGIv1ZF3gIZZWJpIJqZ/kk
	 5vFbRjg28ffc6CIIYgEY5SAbFJ52D4fg29ISRuVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 326/428] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Fri,  9 Oct 2026 16:11:03 +0200
Message-ID: <20261009140953.297030195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f8ebe286394c0bbb4a6dbacb182a34ab6376922d upstream.

il3945_pci_probe() calls il_eeprom_init(), which allocates memory for
the EEPROM data. The probe failure paths release this allocation with
il_eeprom_free(), but the remove path does not free it after a
successful probe.

As a result, the EEPROM data is leaked when the PCI device is removed.

Free the EEPROM data in il3945_pci_remove() before releasing the
mac80211 hardware structure.

This issue was found by manual code inspection.

Fixes: 073d3f5f1b3b ("iwlwifi: changing EEPROM layout handling")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260916073736.2952028-1-lgs201920130244@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3807,6 +3807,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


