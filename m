Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E8B1F76CA;
	Tue,  3 Dec 2024 15:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238563; cv=none; b=cq0JvGJMnqdo/tMYq4/KZnSSCgHxMUOAYWYqAQwVYehKb70bqVXcN9P8AtNTczOAitbtGkkx4kucd7AhSPKKWxF+HjtzR/8RYCBKcXDaMR+jSmP2f0R/dxkdsZgJFV/V+015tBHUuo2jLpWK/pnGVzVocWdahRo6xa8kzRsQYRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238563; c=relaxed/simple;
	bh=L/33UZ92W2W14930ugjSgG/UpC96lIzscLTVE76Sphk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTr0vQQXz+PvaTjbAj/qPhtl95pwoi5jSM5mJR2LJg85oZkf0MSHxrVnSExbqprbobKWmwqR5oqlibgBeB6IhyDDlfhG1iyhap1syN9Kru88nopT7Ttb32rQDWLgY27/+cbFjiJJOvefrSGWa2LiFWCihu0JCvoyxl+CKWhsaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUVHjpB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUVHjpB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8BAC4CECF;
	Tue,  3 Dec 2024 15:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238563;
	bh=L/33UZ92W2W14930ugjSgG/UpC96lIzscLTVE76Sphk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUVHjpB7MJgIWrThgZeCrSwjy5Tz3kKXSbDTiiM3UeLh6Qb1c6DwiI/u5+lbNSrb5
	 N717ZN4FLMxnSKBiM2wWFz657WYj/+fIsxjrzarTjsa4Kdojh72L3imj2zM7h4HIVY
	 kN48rImFSUuY0zcA9azYSliYWu4aQaF65yCdS5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 321/817] wifi: rtw89: coex: check NULL return of kmalloc in btc_fw_set_monreg()
Date: Tue,  3 Dec 2024 15:38:13 +0100
Message-ID: <20241203144008.348423734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 81df5ed446b448bdc327b7c7f0b50121fc1f4aa2 ]

kmalloc may fail, return value might be NULL and will cause
NULL pointer dereference. Add check NULL return of kmalloc in
btc_fw_set_monreg().

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: b952cb0a6e2d ("wifi: rtw89: coex: Add register monitor report v7 format")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/516a91f3997534f708af43c7592cbafdd53dd599.1730253508.git.xiaopei01@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 24929ef534e08..3f4754b7c9d09 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -2449,6 +2449,8 @@ static void btc_fw_set_monreg(struct rtw89_dev *rtwdev)
 	if (ver->fcxmreg == 7) {
 		sz = struct_size(v7, regs, n);
 		v7 = kmalloc(sz, GFP_KERNEL);
+		if (!v7)
+			return;
 		v7->type = RPT_EN_MREG;
 		v7->fver = ver->fcxmreg;
 		v7->len = n;
@@ -2463,6 +2465,8 @@ static void btc_fw_set_monreg(struct rtw89_dev *rtwdev)
 	} else {
 		sz = struct_size(v1, regs, n);
 		v1 = kmalloc(sz, GFP_KERNEL);
+		if (!v1)
+			return;
 		v1->fver = ver->fcxmreg;
 		v1->reg_num = n;
 		memcpy(v1->regs, chip->mon_reg, flex_array_size(v1, regs, n));
-- 
2.43.0



