Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BDB189903;
	Tue, 10 Sep 2024 09:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961882; cv=none; b=aW/9xGsZ58EyeZ3rsSi/J9XY7ZtUTE5RBzAvsbF2HE3MDf5thtiiLwtWUMczzYoYx1UGOrqM/LXn1zDd1w/r/eso8mscee9mUDAkBX6o1gNKETcqLmJt/4a3ZX9emgu4wX/giYTGQsoA58rmHp5M/T4p5qDWC6/uT8RhrQW3Og8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961882; c=relaxed/simple;
	bh=mPosmE1xKCXOMSia38omA/wHm9oZhKgOD8CKqt4qixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSsQ3jJk/JGO1Evsmci4ieRa7I6FkC0zZkeRRXJedshZUTRHrtq7cXjJ7vK9BbsvFGSxy0rmlShZddms7Nd0Aa/1sXYJAHK5xh6zhqKDtxYTtt6jFFLR2IdxQRRwkGtTvJjTCTW/VHNZ6Q3e4MnCSZgiF0GoET1zLc1hBBAYssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7fwnko/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7fwnko/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E79C4CEC3;
	Tue, 10 Sep 2024 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961881;
	bh=mPosmE1xKCXOMSia38omA/wHm9oZhKgOD8CKqt4qixA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7fwnko/7Cj2gDZ5I3KftBG6O+67DLsPBirc6T13EcqDAxEDusDxNNa/23M/zwrRj
	 oOrWF3KCz6DoTzK4cGbLBqlpMOwJgwS8g/VLgiiVt4xik79Iwxewm3ne6kdX/Z4YR0
	 Q6wSEAhzE3TGKO1kI6lDreSwrEQqzV+S+GIBHsVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 193/375] r8152: fix the firmware doesnt work
Date: Tue, 10 Sep 2024 11:29:50 +0200
Message-ID: <20240910092628.984019536@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 19df1cd9f072..51d5d4f0a8f9 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5177,14 +5177,23 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
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



