Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142C5012A7;
	Tue, 13 Oct 2026 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895229; cv=none; b=KhTLE1/mmWtHnBRlSrAUNo/WNj5m4NYc7btRgRtERbSu3Emcclcl7fjXt2DZQAxvyihpOW95EpVBOwK/MsFekTBuKFuatzAYMjTAxyfxoRiuSzMRi3Rfx33ZE4cISR7GgvQZwRefOuqdnhztKOSVEP8J6c9vNLvvftvaNW8uBTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895229; c=relaxed/simple;
	bh=fSm5+qSmHBL7D/BRfTQm0FuLTDOBgpwjn0mSrOdCx7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7Iby+Tsa78hjRiVQcfrOdTI+8Bm593r9+VBpE7cjw3La7H+M+Rg2DRnMUF0WLlMzXDegMZ5ibDH9yvno/iczjkcbrXC2Q7i3IuOcIQCT78INvnE/WNohn6WwCfUUWk4v4L0vISS7OPtp++MMJfwleJA12m4Q7L1Zwrx5sEHftk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ0DeY75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ0DeY75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895821F000FF;
	Tue, 13 Oct 2026 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895228;
	bh=ewpVQBDr5GKy/zYlINzGliBMJCbT/4wYaGZJenpou1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ0DeY75Y5iqUhzAB9KONLzRkRqSWbAMS3ezfI9VAKN9DZdlXueS4vI6rU7MzVEir
	 5phDx7KfBN7deX5FzBpOSqa7jQi5W6sxb0865ZypPN0sl1SWaxhefCGQhDIXq+mpVd
	 wM/tz8WLBjEobAZ6VY7SuYIecW5gSCuW8PZDbhdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 204/497] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Tue, 13 Oct 2026 13:36:11 +0200
Message-ID: <20261013112912.732758980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3844,6 +3844,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


