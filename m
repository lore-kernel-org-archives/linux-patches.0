Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341D481FAF;
	Tue, 25 Aug 2026 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664900; cv=none; b=bIAGlgNaW2jdG/7TxQkwJUS+gyfGuZqJqTcXpi67hSl8i0jYgNdR5cevYp0bbfp69FSB6I+m+6mQUSOAvVP4UGS4pk7/fdeoul5cQv7pXoy8yZdN3qYWu+IwaBTg77WhefD+djcuifaX50Ww3U0Lo6WHsOLIsMQEX2tqyetQKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664900; c=relaxed/simple;
	bh=pSYekUBsOa4K2qsWeOapulHVusG6QL1bztWWPK1xhvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkDFQUryBMdRqjO2oA4pXKGTlB9F6ZkzhB/VvkiB0Nd5AcrL4T0a3WRLG8PhOMo5fo5gt1u+oxvKovDpYyEBxikTGY/LQt2L2pJDlmXyeCm2ynSIlPcIVqq0PQhvkPBU1Royh+JKHrlm98yowJ8HLeWkPcdTCwZ1oj6T91N4jHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVfxQon5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVfxQon5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F11F00A3A;
	Tue, 25 Aug 2026 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664898;
	bh=JWbBgqAB74Y8QeZLrrj9nPLCqvaQkkGQYuJWT7lqCs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVfxQon5r98PAOaC4Uk2aZiZamFWQLI4veszBtCxek43VOkVECbDEY8WWPgN5PU5y
	 t641Ne9DGeaCPC/rkFn6HcVt44VUdkkIx8NIXwmQLo9Aucig0Ale1Oqa62J/5XdS2a
	 LqNCDTpPGN/2meFJtzhuFqP5HEpbodgNWByTYyYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.1 041/101] nfc: llcp: fix OOB read and u8 offset wrap in TLV parsers
Date: Tue, 25 Aug 2026 15:25:19 +0200
Message-ID: <20260825132543.625552610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit 78b20c8eeacd2e44a2d8a4cb5316d3c521d90911 upstream.

nfc_llcp_parse_gb_tlv() and nfc_llcp_parse_connection_tlv() contain
three related bugs in their TLV parsing loops:

1. 'offset' is declared u8 but tlv_array_len is u16. When TLV data
   advances offset past 255 it silently wraps to zero, causing
   infinite loops or double-processing of buffer data.

2. Before reading tlv[0] (type) and tlv[1] (length) there is no
   check that offset+2 <= tlv_array_len. A truncated TLV causes
   an OOB read of one byte past the buffer end.

3. After reading the length field, the value bytes are accessed
   without checking offset+2+length <= tlv_array_len. A crafted
   length=0xFF on a short buffer causes up to 255 bytes of OOB
   read past the buffer end.

Both functions are reachable without authentication via
nfc_llcp_set_remote_gb() which feeds remote LLCP general bytes
directly into nfc_llcp_parse_gb_tlv() with no additional
validation.

Fix all three issues by widening offset from u8 to u16 and adding
bounds checks for both the TLV header and value field before each
access.

Fixes: 3df40eb3a2ea ("nfc: constify several pointers to u8, char and sk_buff")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260622131802.239035-1-meatuni001@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_commands.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -193,7 +193,8 @@ int nfc_llcp_parse_gb_tlv(struct nfc_llc
 			  const u8 *tlv_array, u16 tlv_array_len)
 {
 	const u8 *tlv = tlv_array;
-	u8 type, length, offset = 0;
+	u8 type, length;
+	u16 offset = 0;
 
 	pr_debug("TLV array length %d\n", tlv_array_len);
 
@@ -201,9 +202,15 @@ int nfc_llcp_parse_gb_tlv(struct nfc_llc
 		return -ENODEV;
 
 	while (offset < tlv_array_len) {
+		if (offset + 2 > tlv_array_len)
+			return -EINVAL;
+
 		type = tlv[0];
 		length = tlv[1];
 
+		if (offset + 2 + length > tlv_array_len)
+			return -EINVAL;
+
 		pr_debug("type 0x%x length %d\n", type, length);
 
 		switch (type) {
@@ -243,7 +250,8 @@ int nfc_llcp_parse_connection_tlv(struct
 				  const u8 *tlv_array, u16 tlv_array_len)
 {
 	const u8 *tlv = tlv_array;
-	u8 type, length, offset = 0;
+	u8 type, length;
+	u16 offset = 0;
 
 	pr_debug("TLV array length %d\n", tlv_array_len);
 
@@ -251,9 +259,15 @@ int nfc_llcp_parse_connection_tlv(struct
 		return -ENOTCONN;
 
 	while (offset < tlv_array_len) {
+		if (offset + 2 > tlv_array_len)
+			return -EINVAL;
+
 		type = tlv[0];
 		length = tlv[1];
 
+		if (offset + 2 + length > tlv_array_len)
+			return -EINVAL;
+
 		pr_debug("type 0x%x length %d\n", type, length);
 
 		switch (type) {


