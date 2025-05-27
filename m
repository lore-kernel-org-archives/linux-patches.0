Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED4F1FB3;
	Tue, 27 May 2025 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367945; cv=none; b=eBDYJV5o+zaJ+FuwUjmbZAY/IWItGZVJ/aAGmlMPGaC9IWbxnIW9cACuAu3JGkvvLr+x5UCtz5H/77og40UMtBw39oiZceIrVyC8jJNy9jyg7xG29iD7ABFk8brGkBsvpAlUMv4uqpW3h9CvrrpNXqXJQ6n0dM++OPU660aZcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367945; c=relaxed/simple;
	bh=dYDldtsV7xwXvTj6nOKfCpzA1455KV1lr8LUmhzkkLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwkQRH4mv+xcOYmNPbEjYYgO1zBjlaO426Mf0KjfOZbbDU2BlHwzgLo+IjQV3Q6kpQdyDXG1a/1LGgWQMD+PG7dwP1310udaduLF0m/mCM05A6KS9Z9hmgOsIDmki7RuVSWdzgIhwCWNjOR8O8CWU8M1c0UiKZW5UalAe6XNf1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGn8emYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGn8emYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE6BC4CEE9;
	Tue, 27 May 2025 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367945;
	bh=dYDldtsV7xwXvTj6nOKfCpzA1455KV1lr8LUmhzkkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGn8emYrM4LIL5uhSWBttiGXo3um5pHadzhovwULmdNBcCo/H+L6eSXq3Z6CueVml
	 B/564KCyI+ZleYuHvZOUOoO79+qr9j9ASVJIAw3rKv1QcVxRDTzTEKizr4lXM0jlFL
	 IZy0ZcJmV8sdxDNY24M2c8y89SevjvVGzdVKP4Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 542/783] wifi: rtw88: Fix __rtw_download_firmware() for RTL8814AU
Date: Tue, 27 May 2025 18:25:39 +0200
Message-ID: <20250527162535.229709381@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 8425f5c8f04dbcf11ade78f984a494fc0b90e7a0 ]

Don't call ltecoex_read_reg() and ltecoex_reg_write() when the
ltecoex_addr member of struct rtw_chip_info is NULL. The RTL8814AU
doesn't have this feature.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/55b5641f-094e-4f94-9f79-ac053733f2cf@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index ea6406df42b3d..0491f501c1383 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -785,7 +785,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 	if (!check_firmware_size(data, size))
 		return -EINVAL;
 
-	if (!ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
 		return -EBUSY;
 
 	wlan_cpu_enable(rtwdev, false);
@@ -803,7 +804,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 
 	wlan_cpu_enable(rtwdev, true);
 
-	if (!ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
 		ret = -EBUSY;
 		goto dlfw_fail;
 	}
-- 
2.39.5



