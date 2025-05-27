Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E492110E;
	Tue, 27 May 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365614; cv=none; b=cWVrwwwE25AxzcKOQNtkRGEh9jul09oproWEshQ6ImynROihPlAvT3aByC8x9EksFO8Atow/D2EAADhaqJC3x/pcV1pLufQ9Ws7nUa+XIRDmQJ/u8QTN7YNNZqr/1b5j9jt+R9kR7aZNbpm4uhAhVZNCg06NK++MwlOofxqX5NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365614; c=relaxed/simple;
	bh=m7TpcE+Q7DcreXngDGj6XXCNqkb7jXWpzYfzg3aqaNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui+4iU6VibwipYVZJFQhBpKZat9UGuWvjp9ZEzGViiPoPUHGW/THSZieAMXORTDI0k3YI6vdkde9fKCtx4kDdtkAstccAc6axVbyM7IeY64Ku2q9eksdb72RHRflRYiNom/+UfnxlwF9Ge9F4LaS4Lalq4RLsdWahgcXrnkOLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soiMa/tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soiMa/tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C5CC4CEE9;
	Tue, 27 May 2025 17:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365613;
	bh=m7TpcE+Q7DcreXngDGj6XXCNqkb7jXWpzYfzg3aqaNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soiMa/tjH4kbvRNyLxjWzfphUDkHLA4A4WGTGcGb9PLDO3xbNj8eMeKnL3CtOsjbG
	 dJFOjkcSDmJEfLa+6EGbRi6IoYwcm5evpeivDvXtIN8dY00tqKei/COr0jmUvXKo2w
	 hhsGIZLLdXV879fAtUBg3waKeHXcZQxTsy1CRE4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/626] wifi: rtw89: fw: validate multi-firmware header before getting its size
Date: Tue, 27 May 2025 18:25:26 +0200
Message-ID: <20250527162502.601648532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 9346fe082040c..520dc0bc01956 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -563,12 +563,17 @@ static u32 rtw89_mfw_get_size(struct rtw89_dev *rtwdev)
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



