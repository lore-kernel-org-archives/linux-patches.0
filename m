Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41883145B14;
	Tue, 23 Apr 2024 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908766; cv=none; b=VHAiBetMDiF0/xofo2KD+yvBfoTPOsa0kdvCg+PyuYTk8oi5PGiO0gRrd/O3FCnlbGNiT8RfTnDf4eSuKBrPucI1CZalHJLf33bNlPCkjaHPjdaEPtJMXckHU+h0toRYNCpqW1W9EI+RCXHU919fZPHARSp7TrAbioO1Bqs75HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908766; c=relaxed/simple;
	bh=oFY/Mb3YlbCm6X3GDVfTH7KcsT+Ql7Xf1jzuaILk5nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POlxqTEtd3h5wI/RbYN7JaQkcEJQYh+1wbur/xQcM3jc/mCmqB8Hc1W3JBueRo6uhf+tDBCKa/GcYUCfpmHbDZ6O1R5xXyzInWa0/dinPm1bxLKMiTKF/42VL/ejX9X15R9Xpfr+YvUhGVoVV7DObwiam/LWJ6V95qGrbGI4AWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=003oD9ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="003oD9ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6175C116B1;
	Tue, 23 Apr 2024 21:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908765;
	bh=oFY/Mb3YlbCm6X3GDVfTH7KcsT+Ql7Xf1jzuaILk5nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=003oD9niqACAAqXkzVq9yQ5p+r7xKTKA2GbkaV5APMVbMgpqSPav9iXC09P6MY3Do
	 AHZOnT/jWjwpdqcYlBAhCiaoZTlvZjKl7Y1A9dmLR5eJwK0p/CApKm57kc/f62d0XS
	 eWelQ5wRH1C/WtU9POf3n0XFp1TDY5tld2uovldg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 140/141] ksmbd: common: use struct_group_attr instead of struct_group for network_open_info
Date: Tue, 23 Apr 2024 14:40:08 -0700
Message-ID: <20240423213857.758001962@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -699,7 +699,7 @@ struct smb2_close_rsp {
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
-	struct_group(network_open_info,
+	struct_group_attr(network_open_info, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;


