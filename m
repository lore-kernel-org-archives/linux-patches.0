Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDE3AD51A;
	Sat, 17 Oct 2026 16:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255189; cv=none; b=c9OH10TV9vVGBBSMyqyjppXyelA+yjQ9QJ1aHwQ72i2rRV0TfCKitJar/V6UubB4o7fCCe4gLNMDK9wsEJKFS1+xRGHF7gg9KYUUxln4Oy9G7x+TU5QC9wQhAKrYr5RWtcNx4DmETgieVrp3vpZ0L8tIl0MdMzvt18RsbTteb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255189; c=relaxed/simple;
	bh=H8g0kZ6ut+9bQDyHC6UY4YUB4Q4Rc+4/Qet/K67wy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBl3V+Lz3YPpz7O7YRTe+E8ZpnBUJXaTqijaUjeu5Evyb3V2LS2SKzIhBYLT7e/QC4eU48Z61JLykB3c+grOW9RlZd3jqLA9vPc/hps0LU9iDjz44Krm3HYn+PNhb1Q9Pf5M021UlDuK05j7pd7dwH60oobVCCtG9mQSmqouuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0PQRgYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0PQRgYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54751F000C4;
	Sat, 17 Oct 2026 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255188;
	bh=BTSdv0gNCH40E6YzBloNUFJfKSfttb2WaUQnxGr0MoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0PQRgYJX04n9Mq/EbkByZT+LvIeUclcPpyyySDN/gPur4tfx/W7X0BwbV18ktM+n
	 ++rkQ82AN4RKYMPgHmob4lskCbBzNdzaFZm8m7SP18vOYr5wiuMysOnbmYN/6NlyTM
	 cqLZ2JQhned4qC7SN96qq7iIqKdON+PUlU3ZQ9/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 692/869] scsi: ufs: core: Validate string descriptors
Date: Sat, 17 Oct 2026 17:58:53 +0200
Message-ID: <20261017160054.714169148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 6c94300783e1d..20cd42d00e362 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3749,7 +3749,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 {
 	struct uc_string_id *uc_str;
 	u8 *str;
-	int ret;
+	int ret, uc_len;
 
 	if (!buf)
 		return -EINVAL;
@@ -3774,11 +3774,19 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
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
@@ -3790,7 +3798,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
 		 * we need to convert to utf-8 so it can be displayed
 		 */
 		ret = utf16s_to_utf8s(uc_str->uc,
-				      uc_str->len - QUERY_DESC_HDR_SIZE,
+				      uc_len / sizeof(*uc_str->uc),
 				      UTF16_BIG_ENDIAN, str, ascii_len - 1);
 
 		/* replace non-printable or non-ASCII characters with spaces */
@@ -3800,11 +3808,17 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
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



