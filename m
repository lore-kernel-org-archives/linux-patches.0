Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD67399CE9;
	Fri,  9 Oct 2026 14:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556623; cv=none; b=RgaIzHe+nTiOFksDU8fE6Jo0MZhagHCQnMyVXmMlQby+rB3vQZVL6pgnWfckWpqSyyxQWiPoOdbjI12glJ9hXo7BsXfUgFYODXTcesNR+Cm4oGDn9woYrC6JwaGphPT+uSA0YCbBNzjIQri1vglXk/zjXtbSbLLsyrgvtba/eRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556623; c=relaxed/simple;
	bh=ro4qg8tdF/fTduhaCDYks1TLe8SzQKU8GRpfqJidnvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz65flufAzK9SSO9d0zn0GrtpCMylozB1ibBO00+xgTuM64wsnkqz/YfJmaA1eUrO9LwE+WdZGuuTZWORMVkGXsq2fBSkxEl3/LjsRCG1//+jBXN9cC+UNG2Z526bKiVphbQ3Oxq2jwM+xPBMn6XxfYd27rHBC9+WQAp1ffMjNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hN4gQne0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hN4gQne0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB8B1F000FF;
	Fri,  9 Oct 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556622;
	bh=evdYZ/Yi0YbqCZdIi1zjjieIvS84DrgD/4yE6gU/yO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hN4gQne04+wo2pFE+bB5qGN5/FjDMtRydkcKS99jmKRjBzPiCjJ613pg0AS6+r2kn
	 GxaeVrsZfqsljU2m3ITh8vQIccm10E1X19jq2dJ92jP9YxeXPERfUfDHEGp4dU3JfB
	 hwEs/NChXcvWdn3jvK/nEp+AHxfSBB67Z7d6HdUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 265/403] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Fri,  9 Oct 2026 16:10:26 +0200
Message-ID: <20261009140958.374754154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3806,6 +3806,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


