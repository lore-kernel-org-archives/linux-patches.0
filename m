Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A0E143C52;
	Tue, 23 Apr 2024 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908670; cv=none; b=TEJunpPdX9QunL44EwLVKqEpNoco/yo5YtJ0l4JLZbrBfwqQ5dgDwVNiMw0OCWu64nssrnCpftIxNujrV/V42BsPmQhkS0JqD5PucjTMctU753cf0N2i9QD4qU+wfiJpPBrVWRV8BMz39fHS5fBCKBp8DaeeO8UVB8pqN/8Gg+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908670; c=relaxed/simple;
	bh=K6dVU5uq5b638KbyFZKryJwHcJow2bM5X5eCqFpqih8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSj7EkTVB1oFEvlYFnbGuY4eL9DxjsKnVkNh6q7BTOSa8gPMnRMtvF3FIn7J61qwchzGlkIDFG0gfsUcukLVDnWgVOJYSCZBtY6Ae2Cpu3CBGSX4pMiBl1pFnk9U8UkCmeH65pYCTfa5RnbIrameAaeY4rGP9QxD3WaYp9i76gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCZtRNzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCZtRNzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD86FC116B1;
	Tue, 23 Apr 2024 21:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908669;
	bh=K6dVU5uq5b638KbyFZKryJwHcJow2bM5X5eCqFpqih8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCZtRNziEyJEteZF0xb/tN+ES6BvXoVbdFPOBC3sFp52ExT1yIAN3zox6yEvp4GWN
	 vgpojgJuXLCx6fIgC8dgivgqut3qVbt1BKZt0i5raFi5DC0rBfb6OOi45/5RAGXHwP
	 vX54mHQYkQjFdGmk73wcJKU6RDPwAvHC2x3W4d4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 157/158] ksmbd: common: use struct_group_attr instead of struct_group for network_open_info
Date: Tue, 23 Apr 2024 14:39:54 -0700
Message-ID: <20240423213900.757117776@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0268a7cc7fdc47d90b6c18859de7718d5059f6f1 upstream.

4byte padding cause the connection issue with the applications of MacOS.
smb2_close response size increases by 4 bytes by padding, And the smb
client of MacOS check it and stop the connection. This patch use
struct_group_attr instead of struct_group for network_open_info to use
 __packed to avoid padding.

Fixes: 0015eb6e1238 ("smb: client, common: fix fortify warnings")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smb2pdu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -700,7 +700,7 @@ struct smb2_close_rsp {
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
-	struct_group(network_open_info,
+	struct_group_attr(network_open_info, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;


