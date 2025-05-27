Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0F13A244;
	Tue, 27 May 2025 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365617; cv=none; b=RIixcJ2uIteOABMeHxv8BEugWblgWxDkDJfxkFtEZamgbIrefhrBp+PJyu4JdpN/MEqtyz8ZtMbJE1NIkQzk0QQRJBJBmcS8Al9Lx+pubwShRR+Pff4pqIq3Fn92r2dMF9urYGXXftZtLHXUmhMvh62zcAnK6bIWdN7wVNuauQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365617; c=relaxed/simple;
	bh=3feGEgM/5sGheNW3fHJigG8Yij+0F28aOu/fS/6h3E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0o+iH7JwY7jpj8ExMoYu1nQHo/mjNJWBm3DfdqluvFsw/aMw/+J9UPgzJkdxg172KcHMSH77QIBcz6GutbXyOZyJuqO0ory77OkudYM1RgKr2Tje15L4ctQ6WAg3u09wmj/IE/9NnZfuai3b50n4nzH/59Kv+S9CKKzODVh5AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/3K7eY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/3K7eY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE9BC4CEE9;
	Tue, 27 May 2025 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365617;
	bh=3feGEgM/5sGheNW3fHJigG8Yij+0F28aOu/fS/6h3E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/3K7eY0qIRzFtjMQR3/UgGR897iT0UMJsW97kjusWAH1JhzfGD0klFUeZb9yG+is
	 AqKvfhTNPUo9/Q2QIVjA1NBNhMlg4/zysN/JBVm/HIOwhTHZwkH4aFcDOlug03tAkY
	 rERZ6qzrZiPpdjUfuHiC+PnQGVfEkZqS5bnJ+7eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/626] wifi: rtw89: fw: validate multi-firmware header before accessing
Date: Tue, 27 May 2025 18:25:27 +0200
Message-ID: <20250527162502.641232019@linuxfoundation.org>
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

[ Upstream commit 1f0efffd597893404aea5c3d4f1bdaa1c61d4434 ]

A firmeware file contains multi-firmware with a header to represent
contents. The mfw_hdr->fw_nr is to define number of firmware in file.

         +-----+-------+------+---------+--------------+
         | sig | fw_nr | rsvd | version | reserved     |
         +---------------------------------------------+ --
 fw 0    | cv | type | mp | rsvd | shift | size | rsvd |   \
         +---------------------------------------------+   |
 fw 1    | cv | type | mp | rsvd | shift | size | rsvd |   | mfw_hdr->fw_nr
         +---------------------------------------------+   |
 fw N-1  |                  ...                        |   /
         +=============================================+ --
         |               fw 0 content                  |
         |       (pointed by fw0 shift/size)           |
         +=============================================+

To avoid Coverity warning, validate header is in range of firmware size,
and also validate the range of actual firmware content is in range.

Addresses-Coverity-ID: 1494046 ("Untrusted loop bound")

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250203072911.47313-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 35 +++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 520dc0bc01956..e5c90050e7115 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -501,6 +501,30 @@ static int rtw89_fw_hdr_parser(struct rtw89_dev *rtwdev,
 	}
 }
 
+static int rtw89_mfw_validate_hdr(struct rtw89_dev *rtwdev,
+				  const struct firmware *firmware,
+				  const struct rtw89_mfw_hdr *mfw_hdr)
+{
+	const void *mfw = firmware->data;
+	u32 mfw_len = firmware->size;
+	u8 fw_nr = mfw_hdr->fw_nr;
+	const void *ptr;
+
+	if (fw_nr == 0) {
+		rtw89_err(rtwdev, "mfw header has no fw entry\n");
+		return -ENOENT;
+	}
+
+	ptr = &mfw_hdr->info[fw_nr];
+
+	if (ptr > mfw + mfw_len) {
+		rtw89_err(rtwdev, "mfw header out of address\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static
 int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 			struct rtw89_fw_suit *fw_suit, bool nowarn)
@@ -511,6 +535,7 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 	u32 mfw_len = firmware->size;
 	const struct rtw89_mfw_hdr *mfw_hdr = (const struct rtw89_mfw_hdr *)mfw;
 	const struct rtw89_mfw_info *mfw_info = NULL, *tmp;
+	int ret;
 	int i;
 
 	if (mfw_hdr->sig != RTW89_MFW_SIG) {
@@ -523,6 +548,10 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 		return 0;
 	}
 
+	ret = rtw89_mfw_validate_hdr(rtwdev, firmware, mfw_hdr);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < mfw_hdr->fw_nr; i++) {
 		tmp = &mfw_hdr->info[i];
 		if (tmp->type != type)
@@ -552,6 +581,12 @@ int rtw89_mfw_recognize(struct rtw89_dev *rtwdev, enum rtw89_fw_type type,
 found:
 	fw_suit->data = mfw + le32_to_cpu(mfw_info->shift);
 	fw_suit->size = le32_to_cpu(mfw_info->size);
+
+	if (fw_suit->data + fw_suit->size > mfw + mfw_len) {
+		rtw89_err(rtwdev, "fw_suit %d out of address\n", type);
+		return -EFAULT;
+	}
+
 	return 0;
 }
 
-- 
2.39.5



