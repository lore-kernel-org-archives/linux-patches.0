Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A2118E778;
	Tue, 10 Sep 2024 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964291; cv=none; b=Vm0Snnrr8NIT08UJBl76+XH0J5KLN/VSfdWFwD3hDEd0XUB6AccqyGOfJgbx+nuVpx0k89UXs5pqaw6Ks3n+6JYMtgf3s5UsJsgryPl+PLbfhENZhikeV9G04Bbwx0N01DPhgpOv1F3zKjRsLR76U5nSgEpskzQ6oPaa/NTNnxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964291; c=relaxed/simple;
	bh=1CaxLtajIta/91re0kqawbv1Sg76zilPrs+xEpqL/qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZVFM29PVqerEJajgyzcLxDY3sqRCPbpRBlh9yygwqyQzcDKNjnfuc1G7IWdbBnewWL7+lFrZfYZfL3uiOBNRzdh5hnjxNZLfT8VfjqIc2T6ULhY2Bj4IKVLm/IndsAQO+ZHedgyeLGAQeuenJgfcOVsj10BXyzfS4euopzczlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIuD9Ih/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIuD9Ih/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9768EC4CEC3;
	Tue, 10 Sep 2024 10:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964291;
	bh=1CaxLtajIta/91re0kqawbv1Sg76zilPrs+xEpqL/qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIuD9Ih/V7YM7a8jobe1fCkjwXjVU7pNgr8KQ8No6/e7rPKjNfSZJZFEQMc2Oyecb
	 YI41i9se//9surl9Dr6WH8VfvECVNAJXT4Caf7LMx/usqygZwg1l/FvizhKbYJsE93
	 ULJgZIcHCi4gPPhWWiutt5oqvS2hY0nJgu8hxsCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/269] r8152: fix the firmware doesnt work
Date: Tue, 10 Sep 2024 11:32:00 +0200
Message-ID: <20240910092612.945297230@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 8487b4af59d4d7feda4b119dc2d92c67ca25c27e ]

generic_ocp_write() asks the parameter "size" must be 4 bytes align.
Therefore, write the bp would fail, if the mac->bp_num is odd. Align the
size to 4 for fixing it. The way may write an extra bp, but the
rtl8152_is_fw_mac_ok() makes sure the value must be 0 for the bp whose
index is more than mac->bp_num. That is, there is no influence for the
firmware.

Besides, I check the return value of generic_ocp_write() to make sure
everything is correct.

Fixes: e5c266a61186 ("r8152: set bp in bulk")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20240903063333.4502-1-hayeswang@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 127b34dcc5b3..ce19ebd180f1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5143,14 +5143,23 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 	data = (u8 *)mac;
 	data += __le16_to_cpu(mac->fw_offset);
 
-	generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length, data,
-			  type);
+	if (generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length,
+			      data, type) < 0) {
+		dev_err(&tp->intf->dev, "Write %s fw fail\n",
+			type ? "PLA" : "USB");
+		return;
+	}
 
 	ocp_write_word(tp, type, __le16_to_cpu(mac->bp_ba_addr),
 		       __le16_to_cpu(mac->bp_ba_value));
 
-	generic_ocp_write(tp, __le16_to_cpu(mac->bp_start), BYTE_EN_DWORD,
-			  __le16_to_cpu(mac->bp_num) << 1, mac->bp, type);
+	if (generic_ocp_write(tp, __le16_to_cpu(mac->bp_start), BYTE_EN_DWORD,
+			      ALIGN(__le16_to_cpu(mac->bp_num) << 1, 4),
+			      mac->bp, type) < 0) {
+		dev_err(&tp->intf->dev, "Write %s bp fail\n",
+			type ? "PLA" : "USB");
+		return;
+	}
 
 	bp_en_addr = __le16_to_cpu(mac->bp_en_addr);
 	if (bp_en_addr)
-- 
2.43.0



