Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF271442134;
	Thu, 30 Jul 2026 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425665; cv=none; b=RCjK7tf6jmyUG270tI/U5UPvg1HHxET9EhzmQGx/QnA2KtpD6IN/fbKl/9yG4sgPp1yrCD6PMca1giDZVq0zyZMoEOrxWmpa0++fRSamDDR4al0vDRZaJrg7nbV6Dlm3I1EmGxlI2tHzimv0quFB5j4VAmHPd+HtbBITlNo5uzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425665; c=relaxed/simple;
	bh=fOyasd9fKs4V/8AZNoPg5nNPLSxhTj1FqEhfybYdko4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpsQRZy/Z7LWZITWJPb5FQKQkzb7xL28pkB9Fe1gSuLxVODdotaOUVIM0NTtfgj/7LKOATttT/jUfOJvWSp1N5SdOIsu3XXUaQ9e1FDBaqs4CMkJIL6TmlTP0zTBb+r17X39D2TNysVr5mATxvBsGUu4wLjbQfBrwwkSLeIDwPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnitc3yw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnitc3yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262F51F000E9;
	Thu, 30 Jul 2026 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425663;
	bh=4R8Uhav5VgkZ/amQZHPhYdhcgO7KQGZG+D0aaZSa2dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnitc3yw1HhcrgBWHFlS+2tBS55Fdb9HPnASQ7hz3hGsUKOL/GjN9MOtQTjL8ke9o
	 qrpkVblx55iOurjHa692OoVwp35+AxBup88T8DlUof6IgjmAo8M4FqHY0ml7Zywsj7
	 A7vrbjVJ5t3Q42XMHFoyUqH7xoy7mUmNvutQOLTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/602] wifi: carl9170: fix OOB read from off-by-two in TX status handler
Date: Thu, 30 Jul 2026 16:09:01 +0200
Message-ID: <20260730141439.109771738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit a3f42f1049ad80c65560d2b078ad426c3134f78d ]

The bounds check in carl9170_tx_process_status() uses
`i > ((cmd->hdr.len / 2) + 1)` which is off by two, allowing
2 extra iterations past valid _tx_status entries when the firmware-
controlled hdr.ext exceeds hdr.len/2. Fix by using the correct
comparison `i >= (cmd->hdr.len / 2)`.

Fixes: a84fab3cbfdc ("carl9170: 802.11 rx/tx processing and usb backend")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=5c1ca6ccaa1215781cac
Link: https://patch.msgid.link/20260421134929.325662-3-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 0226c31a6cae26..8280d264d5e2e8 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -693,7 +693,7 @@ void carl9170_tx_process_status(struct ar9170 *ar,
 	unsigned int i;
 
 	for (i = 0;  i < cmd->hdr.ext; i++) {
-		if (WARN_ON(i > ((cmd->hdr.len / 2) + 1))) {
+		if (WARN_ON(i >= (cmd->hdr.len / 2))) {
 			print_hex_dump_bytes("UU:", DUMP_PREFIX_NONE,
 					     (void *) cmd, cmd->hdr.len + 4);
 			break;
-- 
2.53.0



