Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE4A38F255;
	Sat, 12 Sep 2026 19:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242823; cv=none; b=C1IFkfxGvYbki5M7uIVYF7omnc2NdoVG2sHY7ofAfz5DmkXdXz1+aMWNeapafd1nZRRpLHAO9KZaXVwrIYT6F+W4/kyyOq+3TLPynUsIjDGsY5pjsLcSUPyCYR/3I3LbipUZhKm2OUoIyi5tPn45Hs1yHgxfQ3q588bpsQpuVR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242823; c=relaxed/simple;
	bh=xvfc5q4CGrkbrhE7BvrQV+FlfcK3AOfkHNi8G58yGO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQJZdcRzTRQXZ+gUZNYrOtLzm8oyz7dkW7ZlJv8RiEPl4cUpyFbZJzmg9e2iQ3H/FyOHQVESduaI1QZ6T4sKiDIhZYT8V0dmmoPeRBmGsJhHpmywbIgpxvLUyedhOo85AC0Lq4fLfHgv0BHy77NkHXfxl9s+PbGQM4MOPgJQQZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGxhBXct; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGxhBXct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0E21F000FF;
	Sat, 12 Sep 2026 19:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242822;
	bh=dHv259FVzWshS6YRAy14TyvO0bqlgDDwv266K0MOqHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rGxhBXctTeKJTUWVTEBNQEtv/1S4vN0Cc8DsoOI1qc5U3Mcb+QvD8hPIhVRVg17R4
	 G+2gRYf/fFdrkXxgBKqZdx61oOs9hnt5qb7cFw7Ci1Pk6ZmOElaMrBLqQv4i4DzK8y
	 3Y2RBOHQYKCnyw2LO7yMVdj9zsqYUTpk1ORXoOdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 540/798] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
Date: Sat, 12 Sep 2026 09:02:48 +0200
Message-ID: <20260912065529.505156213@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 3c2999d13eeb222ae56631aeb7ca248090f2b210 ]

In the last error path in rtl_pci_probe(), the cleanup functions are
skipped due to a wrong goto label. Moreover, the successful call to
rtl_init_rfkill(), ieee80211_register_hw(), rtl_debug_add_one() have to
be reverted. Fix this issue by updating the labels and adding the
relevant cleanup functions to the last error path.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260723120118.145383-1-nihaal@cse.iitm.ac.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 3058c8356c292..9272ac0095261 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2228,13 +2228,17 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_DMESG,
 			"%s: failed to register IRQ handler\n",
 			wiphy_name(hw->wiphy));
-		goto fail3;
+		goto fail6;
 	}
 	rtlpci->irq_alloc = 1;
 
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
+fail6:
+	rtl_deinit_rfkill(hw);
+	rtl_debug_remove_one(hw);
+	ieee80211_unregister_hw(hw);
 fail5:
 	rtl_pci_deinit(hw);
 fail4:
-- 
2.53.0



