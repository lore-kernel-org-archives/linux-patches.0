Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A40156C5E;
	Wed,  5 Feb 2025 14:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765384; cv=none; b=tHUsqF/z2PXn2btXEgWcWoo1xlvzqq/zBOjdegY0tzQN555MKwysE14dLocpsdskTCCzgjNQVZvFOWboKa1SjmjvK1Xwn2Y+LNTSBNL5aBzupY36xKLNSefOO2smBAlharZow5IkLc/LoxPrjfNkXZsp8gD/zPm7urnqILOJX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765384; c=relaxed/simple;
	bh=0VGwlqZrHu2kRZovX8cLzAMLAYYDG3bCG6FRDGw3vJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnUVEvN4MMblTzL0GQTWzaLgIXyu3rCUQRfIMdtFkNkmT3PgwsZjLm3YYWhLibcIhnokBUhE9W/HR40n4eBLVhubgpHFAXZj2gG76wHhhYTgkA0AaW7s5drMHxkg/80h4pVREH/7Xiv6o1jVxtjAvw3B1TLOFV38DKZg11h29VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFt9XI+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFt9XI+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916AEC4CED1;
	Wed,  5 Feb 2025 14:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765384;
	bh=0VGwlqZrHu2kRZovX8cLzAMLAYYDG3bCG6FRDGw3vJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFt9XI+VuCKckGDi9M6f0pa6zPcLsJPqtnxTbvEOlDtcnNKnr5LdL4efs6lhFHVCW
	 lx+blrKW5dOMaZsALecgrhg757FB8IpbIoT42BwvV1SelG70hGROAanP1M2vaCiqKq
	 8taTYJKzB8DXBSZMOYjZy1q2coOfe6D1CUSrESLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Lu <alex_lu@realsil.com.cn>,
	Max Chou <max.chou@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/590] Bluetooth: btrtl: check for NULL in btrtl_setup_realtek()
Date: Wed,  5 Feb 2025 14:39:30 +0100
Message-ID: <20250205134503.512547485@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Max Chou <max.chou@realtek.com>

[ Upstream commit 3c15082f3567032d196e8760753373332508c2ca ]

If insert an USB dongle which chip is not maintained in ic_id_table, it
will hit the NULL point accessed. Add a null point check to avoid the
Kernel Oops.

Fixes: b39910bb54d9 ("Bluetooth: Populate hci_set_hw_info for Intel and Realtek")
Reviewed-by: Alex Lu <alex_lu@realsil.com.cn>
Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 0bcb44cf7b31d..0a6ca6dfb9484 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1351,12 +1351,14 @@ int btrtl_setup_realtek(struct hci_dev *hdev)
 
 	btrtl_set_quirks(hdev, btrtl_dev);
 
-	hci_set_hw_info(hdev,
+	if (btrtl_dev->ic_info) {
+		hci_set_hw_info(hdev,
 			"RTL lmp_subver=%u hci_rev=%u hci_ver=%u hci_bus=%u",
 			btrtl_dev->ic_info->lmp_subver,
 			btrtl_dev->ic_info->hci_rev,
 			btrtl_dev->ic_info->hci_ver,
 			btrtl_dev->ic_info->hci_bus);
+	}
 
 	btrtl_free(btrtl_dev);
 	return ret;
-- 
2.39.5



