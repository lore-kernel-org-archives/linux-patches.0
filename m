Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F081A3159;
	Tue, 27 May 2025 17:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367464; cv=none; b=MqRNxvhR/RJ8nk3X6G1BWjFqJfVLcGT0EmL+vlDb49RcfCMA9R5skcVPZKA/h5t49+OBfV4BSo+Op2z4kE8LvuSYpMXokLPpVCoUC5xPWF2hFOj9918hlMyyqu7MypHtuFhKTpUIvLg4DiTmaVqq0C3TIwYBdVptxRQVWLQJnLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367464; c=relaxed/simple;
	bh=nNheDCke1xwI/13xcJ+GGYAk2QluYfew6frzuJtPRG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoozTE2JK8KmPianSlmefVHbg+qABCnZO+ZY0416g/s5ezknqvCOwM4jFChcvvrNo0Sw0KIXE0/CfWxbg8I4B+JS2O701pjRQDVPqe+9o5c909Tr9bJUf0hBxps76mbBDePSP9s9AgrxAenUoKwOfw/P2+SNcLF5Lgvz1Esz86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB6N7h7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB6N7h7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7628C4CEE9;
	Tue, 27 May 2025 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367464;
	bh=nNheDCke1xwI/13xcJ+GGYAk2QluYfew6frzuJtPRG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB6N7h7abPRjxYFm8kpAaUaJI1DoFD5zuTQSTPOzbPai12XxSe24y2AOKJgjrUOa8
	 hNrWKGu508p4AwIVQB1+we4jUZrvTVv1O/QX21N8DNJiAVkOrM3d7DYMgqa1KXl4Vx
	 HWMWOQDKFLdbxM+sUYVgqheE/L6B3HmV6wdoVJjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 397/783] wifi: rtw89: fw: get sb_sel_ver via get_unaligned_le32()
Date: Tue, 27 May 2025 18:23:14 +0200
Message-ID: <20250527162529.260082120@linuxfoundation.org>
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

[ Upstream commit 2f9da853f4d848d23bade4c22931ea0f5a011674 ]

The sb_sel_ver is selection version for secure boot recorded in firmware
binary data, and its size is 4 and offset is 58 (not natural alignment).
Use get_unaligned_le32() to get this value safely. Find this by reviewing.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250217064308.43559-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 4727eeb55b486..3164ff69803a1 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -314,7 +314,7 @@ static int __parse_formatted_mssc(struct rtw89_dev *rtwdev,
 	if (!sec->secure_boot)
 		goto out;
 
-	sb_sel_ver = le32_to_cpu(section_content->sb_sel_ver.v);
+	sb_sel_ver = get_unaligned_le32(&section_content->sb_sel_ver.v);
 	if (sb_sel_ver && sb_sel_ver != sec->sb_sel_mgn)
 		goto ignore;
 
-- 
2.39.5



