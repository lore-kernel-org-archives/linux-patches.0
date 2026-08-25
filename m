Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC125481A86;
	Tue, 25 Aug 2026 13:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665719; cv=none; b=JWNNaZ7BT+viv/yKMS5ej4AjX4C1eMYEkBXXXBqiEIBlmelffEKy5d/XSLcWqz2wfdeb/EZbsLE9ddAOsDZjfItK1HpAEDYzCGR++u3te5LYJJpY8iVGnZlMO/+uHKS3Ub1xDOSGmQvQHy8T3YRLgYKx3xewMfTDaVwdy8gONRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665719; c=relaxed/simple;
	bh=aayPvqE7ZWzC4Nu00YlvCpmjjHAghTYuEnk05p0QglM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmeVP1QEjmzr3zXKoeXw1k3BpCrHy7V/gysMKNORbMULKRHrtf2CHZEN17misdYTiRyLiK8f94a+Ib+PbRWP0G6wNpq+bbn5kdLBt+1LeoeVdH4mBKOMM00FEvOqoyltVc7w/qkvz+7+RvRcv56jNYQiDStjJZIJ8BX4gRa5DDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSvaqVYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSvaqVYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F9A1F000E9;
	Tue, 25 Aug 2026 13:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665717;
	bh=T3JvO7Jf9oHXKb+Rwevu1c3fZF8U5MQFZoFbeyEraCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSvaqVYfhiHUX5UT5SVqSZ8ZbwsvQbbnxkhAsNL5spPQmOZ3NA2PNlpJL5Sp6IxtE
	 j4u+mSwVS6P//9tuGGioIW8rBBEBJJZSOfGFi760qaswoU7FRk/wAA4Qrr8F0pCyAh
	 gjPV2Gfl31Ml/g/pVzWMIpBMcZ1bDk0gN7qei5Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.6 42/87] nfc: llcp: fix OOB read and u8 offset wrap in TLV parsers
Date: Tue, 25 Aug 2026 15:26:05 +0200
Message-ID: <20260825132543.500251917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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


