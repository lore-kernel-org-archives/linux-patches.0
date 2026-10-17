Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1743CDBAA;
	Sat, 17 Oct 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260200; cv=none; b=Sa3da91QFAdf+AkqNJ58YcccpXJb1NIZ3fZyZOFuxYBAQphMxnYUH4MfYa9Odne2LA9ps42JaWbkxHryJILCDuHNEGNbzlKrQZsYadPXyvGpWxSCY+jRSHMBVK6pYJkxE5gu1WRPV/0vCUXZ4pkwX/+uQxkOAagB+M9wU8GhCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260200; c=relaxed/simple;
	bh=3qu03CZd8HfaQJDa2RWPU7/PvCp4EyesXNFbUewT28Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnXQ76RA1GgO6/CK3RYJfbt6tUp16GHlM2f28tpQP3zmJ2uH7bBAIvGOsInv/3nIf2wxqw0vK0QxCT4uGAf92ZwClZVTI9Bw5zMnM4ptszQPS8j/mcv5B6Pznzw5sy3SRUZVU4AIScHewGcwVe2q9TZesnv4zAKQ2NfMkqkR3kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2eG/bmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2eG/bmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337631F000C4;
	Sat, 17 Oct 2026 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260198;
	bh=aHAfb7u7jaRVm12Zo/urdMIIsRh3AYIAOg+sxcO09bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2eG/bmKh6jdgydwx+R8GtP13rbix6HKftAGzgxfXKpcqnxw46EaOkqTBf16HS3VC
	 XkFs1M+Tt7q6c4DyRvS+nSx8/FYQ2qdVQbkaHmvXuOU1vD5umCUyY/7hcg5/hgDw4o
	 D7Xb7sBO//VbbFkEd72iuJjs1BHpmRP609F2KjAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1467/1674] scsi: ufs: core: Validate string descriptors
Date: Sat, 17 Oct 2026 18:02:19 +0200
Message-ID: <20261017160508.824692755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit d96e83d028d7d8762e424e49c671d49ac2ecf14f ]

The string descriptor length includes a two-byte header while the UTF-16
payload starts after it. utf16s_to_utf8s() expects a count of UTF-16 code
units, not bytes. Passing the payload byte count can make it read beyond
the descriptor buffer.

Validate that the payload has an even byte count, pass a code-unit count to
the converter, and allocate sufficient UTF-8 output space.

The raw string buffer starts after the descriptor header but its size is
bLength. Copying bLength bytes from that pointer can read beyond the
response buffer.

Allocate a zeroed bLength-sized buffer and copy only the UTF-16
payload. This preserves the raw buffer size consumed by the RPMB device-ID
ABI while avoiding the overread.

Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
Fixes: d794b499f948 ("scsi: ufs: core: fix incorrect buffer duplication in ufshcd_read_string_desc()")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260717153914.26321-2-liqiang01@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2873df557db27..55de8d4a5eef1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3683,7 +3683,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
-	int ret;
+	int ret, uc_len;
 
 	if (!buf)
 		return -EINVAL;
@@ -3708,11 +3708,19 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		goto out;
 	}
 
+	uc_len = uc_str->len - QUERY_DESC_HDR_SIZE;
+	if (uc_len % sizeof(*uc_str->uc)) {
+		dev_err(hba->dev, "String Desc has an odd UTF-16 payload length\n");
+		str = NULL;
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (fmt == SD_ASCII_STD) {
 		ssize_t ascii_len;
 		int i;
-		/* remove header and divide by 2 to move from UTF16 to UTF8 */
-		ascii_len = (uc_str->len - QUERY_DESC_HDR_SIZE) / 2 + 1;
+		/* Allow up to three UTF-8 bytes per UTF-16 code unit plus a NUL. */
+		ascii_len = uc_len / sizeof(*uc_str->uc) * 3 + 1;
 		str = kzalloc(ascii_len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
@@ -3724,7 +3732,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		 * we need to convert to utf-8 so it can be displayed
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
-				      uc_str->len - QUERY_DESC_HDR_SIZE,
+				      uc_len / sizeof(*uc_str->uc),
 				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
@@ -3734,11 +3742,17 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		str[ret++] = '\0';
 
 	} else {
-		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
+		/*
+		 * Keep the bLength-sized raw output for the RPMB device ID ABI.
+		 * The two bytes beyond the UTF-16 payload are explicitly zeroed
+		 * instead of being read past the descriptor buffer.
+		 */
+		str = kzalloc(uc_str->len, GFP_KERNEL);
 		if (!str) {
 			ret = -ENOMEM;
 			goto out;
 		}
+		memcpy(str, uc_str->uc, uc_len);
 		ret = uc_str->len;
 	}
 out:
-- 
2.53.0



