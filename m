Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6733150C287;
	Wed, 30 Sep 2026 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792430; cv=none; b=Xbx8KjJGI/ZD57q58eVAT7An9zkBkATsPhzgytdZl9TRHOdL3FcDt8Nn594hsmikkngXaEJJDn29jSyscaVuLVm4QvLf3t46ML/Vi5/m7zGqdxw9WedRfN9O/o/9J/TeZXjA3WpQHG4e0cUXM+L5yNXTEuMijZrpnyd6ZzHlHFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792430; c=relaxed/simple;
	bh=ItnZiDELWUIj/U2aLv3+ex1O5kb3/iWgY09aL9K5Ygk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqj7jMwJumwKTgCU8TUr113GCDU9qu5KkokVlsqInZln30W7jKDsB8/YUiI15XI+CHi78h6spa0cO4QmeMRQjbqwftmmB1vfPBFGqQb06qCTXnx2XU+TUVEMp6LS5CXP1chitP8kTj6JHACgATymO3JO9oYXkaLVOpcr39VjHEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oy74zMsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oy74zMsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01AC1F000FF;
	Wed, 30 Sep 2026 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792429;
	bh=xpq3XtfdPEUDCPUoxMvGg1yZW2wFp/CANO3UVqw/Ck4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy74zMsmmYfkoOOBd+ZenNzIFKSlN3a5m6hhuRPolVmmy8NX7TGUg/JnrTzI3CR0n
	 Ld6FdcGnFuytLdmk+xh12Hof6jJKMRePzKMGp+FIr+HkmlEZ3W5j7Ig8uJNvgLP3hE
	 stt1Z2QWkqp6g8SGNSon+g7FETMXuSCnBvJn51lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 650/752] nfc: st21nfca: validate received frame size
Date: Wed, 30 Sep 2026 17:28:40 +0200
Message-ID: <20260930152412.327247940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a653c01ce447f10c36b901646888c0330363af4f ]

st21nfca_hci_i2c_repack() trims a received frame at its EOF marker
before removing byte stuffing.  It then assumes the truncated frame
contains the LLC header and two CRC bytes, and it unconditionally reads
the byte after an escape marker.

A malformed frame can place EOF immediately after the start marker or can
end its data portion with an escape marker.  The former leaves too few
bytes for check_crc(), while the latter makes the unstuffing loop read past
the current skb length.

Require the minimum framing bytes both before and after unstuffing.  Use
separate input and output cursors while removing byte stuffing, and reject
an escape marker without its encoded byte.  This keeps malformed frames
within the received frame boundary before CRC processing.

Fixes: 3096e25a3e40 ("NFC: st21nfca: Fix incorrect byte stuffing revocation")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260715084405.41546-1-pengpeng@iscas.ac.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/i2c.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 7304013ab269c..d5461ddd9d5f3 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -290,27 +290,36 @@ static int check_crc(u8 *buf, int buflen)
  */
 static int st21nfca_hci_i2c_repack(struct sk_buff *skb)
 {
-	int i, j, r, size;
+	int read, write, r, size;
 
-	if (skb->len < 1 || (skb->len > 1 && skb->data[1] != 0))
+	if (skb->len < ST21NFCA_FRAME_HEADROOM ||
+	    !IS_START_OF_FRAME(skb->data))
 		return -EBADMSG;
 
 	size = get_frame_size(skb->data, skb->len);
 	if (size > 0) {
+		if (size < ST21NFCA_FRAME_HEADROOM + 2)
+			return -EBADMSG;
+
 		skb_trim(skb, size);
 		/* remove ST21NFCA byte stuffing for upper layer */
-		for (i = 1, j = 0; i < skb->len; i++) {
-			if (skb->data[i + j] ==
+		for (read = 1, write = 1; read < skb->len;) {
+			if (skb->data[read] ==
 					(u8) ST21NFCA_ESCAPE_BYTE_STUFFING) {
-				skb->data[i] = skb->data[i + j + 1]
-						| ST21NFCA_BYTE_STUFFING_MASK;
-				i++;
-				j++;
+				if (read + 1 == skb->len)
+					return -EBADMSG;
+
+				skb->data[write++] = skb->data[read + 1]
+						     | ST21NFCA_BYTE_STUFFING_MASK;
+				read += 2;
+			} else {
+				skb->data[write++] = skb->data[read++];
 			}
-			skb->data[i] = skb->data[i + j];
 		}
 		/* remove byte stuffing useless byte */
-		skb_trim(skb, i - j);
+		skb_trim(skb, write);
+		if (skb->len < ST21NFCA_FRAME_HEADROOM + 2)
+			return -EBADMSG;
 		/* remove ST21NFCA_SOF_EOF from head */
 		skb_pull(skb, 1);
 
-- 
2.53.0



