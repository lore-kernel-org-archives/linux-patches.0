Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5B280331;
	Sat, 17 Oct 2026 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256668; cv=none; b=Du3WK2xQSR8Iyw/nYObAqBPuySeEpjPC8BawsTmcECbLwl/Yp4cjQzI+ngoMRIGgtsrTqfyNpWTReplRSRq3HKqfnuA+DFXrK65YmVwT5T2uKLo1ycSkdJjKBux7EFr6QoxtDD4BwVFtpL2gHTrG4UvTef/weqt/s1c+kS8igzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256668; c=relaxed/simple;
	bh=E9ZT6C11+0XZVGkhjIrEckczGCdvvbZPkfyD6KxgxDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcjRvrkAEXa5ZLqPNYiKk+C1jDfXadfO2DysXz8Wvejl8+KzVMx8SbZ/WbB0iN400sQwKKhOKqSmwUW1blJdYicAxvg35mFHO1iOd8nYF/njkGPo3/u1GMo673mRRRQRH1xP8bcEDaRlvv/FKweooPT6jl3Jsfw/m7wtoXYY5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDmlzHT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDmlzHT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C276E1F000C4;
	Sat, 17 Oct 2026 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256667;
	bh=ZW9uopkEmemBo+jKTfFtqzUIBvdQq8QknS/kHf8QDuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDmlzHT9FYj3NcfHrr+K10sdQoDW3TFsJFVlAEqi/gB+cJLdBTT9UIAQ8PFGijNbd
	 mSoL9JdSuoWhFnaG8tcKmjRWIi4G73wsiqpwKzvINp4WbmuiD2BlLHRos2Uw4RtbUT
	 HaS1r3PixQ48fSqx1Yw3+1q+hc9fBw+nU+58Emnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0313/1674] wifi: iwlegacy: 3945: free EEPROM data on remove
Date: Sat, 17 Oct 2026 17:43:05 +0200
Message-ID: <20261017160439.154032151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -3840,6 +3840,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 
 	il_free_channel_map(il);
 	il_free_geos(il);
+	il_eeprom_free(il);
 	kfree(il->scan_cmd);
 	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);


