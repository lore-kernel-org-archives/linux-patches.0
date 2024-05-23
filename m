Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00D013A897;
	Thu, 23 May 2024 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470789; cv=none; b=M3PotMcU3zYmWHXsg6tYXvUdmmsPZJk9+83mgpjHJr8JKz8GqNmUxsTcG1ebpaPbLA2CMd5OJOOEroXr1ucAs0Pa/RSyGTq4WuQbNdMT4GsbSp10fjr0AXQran/vCH3fAEhxAVQjfbPRjzDtVkWQGKf0ANx5Be8DGmEgvO0UESU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470789; c=relaxed/simple;
	bh=bwq/qULzK88RzKtW+1dSISYttKoA6BwKU1zZPDKqI8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPDLHbtbwRkaa7q8cRucRYzQqeVEvjkMBsBVnXFnWxAWmj4dhJI06D1LwsLj02HT/GBs0X8KXIZHw67yPcziIAHfFiyY151ZQiTAeHdaoktb0sVDHIw+l+W7bxmUOhv7Gf39+nqjhrTubAkMDm5KvkLbOac89rwe64/+iU9mmZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUYJMvi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUYJMvi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD5AC3277B;
	Thu, 23 May 2024 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470789;
	bh=bwq/qULzK88RzKtW+1dSISYttKoA6BwKU1zZPDKqI8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUYJMvi6GRyT4M3Fe70jwpZ943PHKmPf9SrduXH9mYNgEaaywsN9okge64xKYm6te
	 kaQlgrdw34HdAuZAlCQjFnrSBVQdoAabjfc3XQUV94iQLuLSk5VSPRDDTNQiwgOP4O
	 /hdX/QMtxrlcw5vr+atMNJjPg4/rVTusvIuAQPAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/102] smb: common: simplify compression headers
Date: Thu, 23 May 2024 15:13:23 +0200
Message-ID: <20240523130344.656424262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 24337b60e88219816f84d633369299660e8e8cce ]

Unify compression headers (chained and unchained) into a single struct
so we can use it for the initial compression transform header
interchangeably.

Also make the OriginalPayloadSize field to be always visible in the
compression payload header, and have callers subtract its size when not
needed.

Rename the related structs to match the naming convetion used in the
other SMB2 structs.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 45 ++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 10a9e20eec43f..61c6e72ccddc4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -208,36 +208,43 @@ struct smb2_transform_hdr {
 	__le64  SessionId;
 } __packed;
 
+/*
+ * These are simplified versions from the spec, as we don't need a fully fledged
+ * form of both unchained and chained structs.
+ *
+ * Moreover, even in chained compressed payloads, the initial compression header
+ * has the form of the unchained one -- i.e. it never has the
+ * OriginalPayloadSize field and ::Offset field always represent an offset
+ * (instead of a length, as it is in the chained header).
+ *
+ * See MS-SMB2 2.2.42 for more details.
+ */
+#define SMB2_COMPRESSION_FLAG_NONE	0x0000
+#define SMB2_COMPRESSION_FLAG_CHAINED	0x0001
 
-/* See MS-SMB2 2.2.42 */
-struct smb2_compression_transform_hdr_unchained {
-	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
+struct smb2_compression_hdr {
+	__le32 ProtocolId; /* 0xFC 'S' 'M' 'B' */
 	__le32 OriginalCompressedSegmentSize;
 	__le16 CompressionAlgorithm;
 	__le16 Flags;
-	__le16 Length; /* if chained it is length, else offset */
+	__le16 Offset; /* this is the size of the uncompressed SMB2 header below */
+	/* uncompressed SMB2 header (READ or WRITE) goes here */
+	/* compressed data goes here */
 } __packed;
 
-/* See MS-SMB2 2.2.42.1 */
-#define SMB2_COMPRESSION_FLAG_NONE	0x0000
-#define SMB2_COMPRESSION_FLAG_CHAINED	0x0001
-
-struct compression_payload_header {
+/*
+ * ... OTOH, set compression payload header to always have OriginalPayloadSize
+ * as it's easier to pass the struct size minus sizeof(OriginalPayloadSize)
+ * than to juggle around the header/data memory.
+ */
+struct smb2_compression_payload_hdr {
 	__le16	CompressionAlgorithm;
 	__le16	Flags;
 	__le32	Length; /* length of compressed playload including field below if present */
-	/* __le32 OriginalPayloadSize; */ /* optional, present when LZNT1, LZ77, LZ77+Huffman */
-} __packed;
-
-/* See MS-SMB2 2.2.42.2 */
-struct smb2_compression_transform_hdr_chained {
-	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
-	__le32 OriginalCompressedSegmentSize;
-	/* struct compression_payload_header[] */
+	__le32 OriginalPayloadSize; /* accounted when LZNT1, LZ77, LZ77+Huffman */
 } __packed;
 
-/* See MS-SMB2 2.2.42.2.2 */
-struct compression_pattern_payload_v1 {
+struct smb2_compression_pattern_v1 {
 	__u8	Pattern;
 	__u8	Reserved1;
 	__le16	Reserved2;
-- 
2.43.0



