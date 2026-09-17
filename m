Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9AC39C63E;
	Thu, 17 Sep 2026 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670882; cv=none; b=iz4AGVFCRr6IzxjxyKtdCGsl+WVkhSykVzacxvs56DnI4Pqj0gLDfmMRAyZvfiSW7NhtO2ZnANPWOxlCnTdoeMovC9SEtxgq6db/hzeXmoWWxyBQY4x9JQLmirwBvo/rcEkFZEnNjmtBGF3bV4NFUA9pBopW0bONuu/EF+VEIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670882; c=relaxed/simple;
	bh=eQoAEx2ptvqMJGNA//zmapxyxtVQuNhg4gzvdS96zjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgF5NBHT//BRCvJpA2ulCHPDC9mK0SNaYOdHVbDHKcvrclSk+JPVVlOemP1QlclFb2D90pijG34ljZVXZeYF8qW2u8h16EQTDA7qIsW7snbNmI/IUb1bL+L6nh93Np5gNtRP/N6EQxLhV8HBlRdTFx76d/LrnOYNh+w9xsmQGoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhmBB99W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhmBB99W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1831F000FF;
	Thu, 17 Sep 2026 18:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670881;
	bh=n0WuJZkXxwq5LyGv1jI1Uf0vtkHcyBSQ4Cx37ITSIPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bhmBB99WPkWSnDofKoItOTLA+vX9qQIMSQC6jkneAFPleyKqqtq7qa4M9Hs/IuH4/
	 06KieYH7MC7SZZ0nsUP0hA9WCa1DNg5yTmPtRWVn3mAYz/qZGqE2oTx+/yQMLNdHA+
	 N95C2rdmJPtH2yD6qrBrRiYTlpJg0T1L83AOTE10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0763/1102] hwmon: (corsair-cpro) Remove debugfs entries when probe fails
Date: Thu, 17 Sep 2026 16:11:46 +0100
Message-ID: <20260917151559.592272641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4ee875c423c66c45d7ef7bbff403cd0e3971e0a2 ]

ccp_debugfs_init() registers debugfs files whose private data is the devm
allocated ccp.  If hwmon_device_register_with_info() fails right after it,
ccp_probe() returns without removing them: the HID core then frees ccp,
and ccp_remove() is not called for a failed probe, so the files stay
behind.  Reading one of them dereferences the freed pointer.

Remove the debugfs entries on that error path.  debugfs_remove_recursive()
waits for readers already inside the show callbacks, so ccp is no longer
reachable through debugfs by the time probe returns.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hwmon/20260708031612.BD7E61F000E9@smtp.kernel.org/
Fixes: 5997eb60f896 ("hwmon: (corsair-cpro) Add firmware and bootloader information")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260828061949.3151191-1-lilinmao@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 1eac947078826..bf7775a731fbe 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -642,13 +642,15 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 							 ccp, &ccp_chip_info, NULL);
 	if (IS_ERR(ccp->hwmon_dev)) {
 		ret = PTR_ERR(ccp->hwmon_dev);
-		goto out_hw_close;
+		goto out_debugfs_remove;
 	}
 
 	ccp_debugfs_init(ccp, fw_valid, bl_valid);
 
 	return 0;
 
+out_debugfs_remove:
+	debugfs_remove_recursive(ccp->debugfs);
 out_hw_close:
 	hid_hw_close(hdev);
 	hid_device_io_stop(hdev);
-- 
2.53.0



