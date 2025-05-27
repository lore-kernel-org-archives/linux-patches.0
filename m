Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F1A1FB3;
	Tue, 27 May 2025 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368015; cv=none; b=JwXNGQVq6VX8sQaTd/Tz74jkUsLKwUSCon2ZFUb9DhlKKE9yILVk6r9VI093DUm9iPu9pisWepqlTgxAr/zQZzD7LedD27RSXbdVHaBYgSrrvHWhEIt3tvj/u+4DjsV3rQfql/OAA0vUIIolwootyg7jCM7iUv/QW6SIwl9+RQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368015; c=relaxed/simple;
	bh=zv6zrrMS7vJUAONnOkj67AXibQOuQNAUZPJVtSblSb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boJhq1wlkW8Fx3z8i44q4z8Xpkg7b0u86Z+eLq2sWFbkMnRKfmTLv8c63EHeKt10CmU+LQUdFCS3xRfT/VpbxFSa3CX4fFgubvi6RqYxrRYWzDYoskFJLZT2Hq8gwUf39FVPa8YRMyoV4yD9lC86Gc3/EQazpBkRXPcTZoupeZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tf3o2KK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tf3o2KK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E30C4CEE9;
	Tue, 27 May 2025 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368015;
	bh=zv6zrrMS7vJUAONnOkj67AXibQOuQNAUZPJVtSblSb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tf3o2KK2v2+0y77GhrmHoSt/M3+8AkWTnpwnSX8+XVM10Ev0eRAUCvWGQPGdsYz/v
	 QLITqgOUVm/ICsdp3SLETOR1Qzr+s+s8o0sY4gFNIterVRB/oDu503mrYmGIauHdR9
	 ZpImFzdaJQR4mzvFSzQTdgU/wXjX/MSZrVvDJyRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 544/783] wifi: rtw89: fw: validate multi-firmware header before getting its size
Date: Tue, 27 May 2025 18:25:41 +0200
Message-ID: <20250527162535.312182341@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 2b8bdc5237014cc61784b3676cbaca5325959f3d ]

To access firmware elements appended after multi-firmware, add its size
as offset to get start address of firmware elements.

         +-----+-------+------+---------+--------------+ --
         | sig | fw_nr | rsvd | version | reserved     |   \
         +---------------------------------------------+   |
 fw 0    | cv | type | mp | rsvd | shift | size | rsvd |   |
         +---------------------------------------------+   |
 fw 1    | cv | type | mp | rsvd | shift | size | rsvd |   |
         +---------------------------------------------+   |
 fw N-1  |                  ...                        |   |
         +=============================================+   | mfw size
         |               fw 0 content                  |   |
         +=============================================+   |
         |               fw 1 content                  |   |
         +=============================================+   |
         |                  ...                        |   |
         +=============================================+   |
         |               fw N -1 content               |   |
         +=============================================+ --/
         |             fw element TLV X                |
         +=============================================+
         |             fw element TLV Y                |
         +=============================================+
         |             fw element TLV Z                |
         +=============================================+

To avoid Coverity warning when getting mfw size, validate it header ahead.

Addresses-Coverity-ID: 1544385 ("Untrusted array index read")

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250203072911.47313-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index f4b3438615541..aed0647955d8e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -601,12 +601,17 @@ static u32 rtw89_mfw_get_size(struct rtw89_dev *rtwdev)
 		(const struct rtw89_mfw_hdr *)firmware->data;
 	const struct rtw89_mfw_info *mfw_info;
 	u32 size;
+	int ret;
 
 	if (mfw_hdr->sig != RTW89_MFW_SIG) {
 		rtw89_warn(rtwdev, "not mfw format\n");
 		return 0;
 	}
 
+	ret = rtw89_mfw_validate_hdr(rtwdev, firmware, mfw_hdr);
+	if (ret)
+		return ret;
+
 	mfw_info = &mfw_hdr->info[mfw_hdr->fw_nr - 1];
 	size = le32_to_cpu(mfw_info->shift) + le32_to_cpu(mfw_info->size);
 
-- 
2.39.5



