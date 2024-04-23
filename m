Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86793143897;
	Tue, 23 Apr 2024 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908555; cv=none; b=HxLc+6fAVmHgDsXIfFM4c71FjZFHdEojj7K7qHPfl0oq1CW0YTonMWeLSRfyPrpJhAi5hbxqoMuEKcdMsiP/nWzHRrOeg7CjJpoKkpYUsa5xVhoiXXBYfT+E+mHRiBJFQi5auIq9LP5Ec7FI7wVLeusxKsWlvyCXgy5Rw6wRwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908555; c=relaxed/simple;
	bh=gAYqPg2jEEEm/Pm1UXV7qxZdCyDa2xv57vIeASnhTxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfUzskSGTwkt1ub5mAFtxq8d6tv1k6dp6HhUfYu5WuSZgA/sjA+SFIAb1GHWr/CzVGLMUGVGziKSdJkphT6UBfSAdRf4kTNLh+E1Hd1GiKcZgpZbwt7F5nFaxF+9MvW3XOsEyh2JDqEpZmS/cpsUvbjp985eGTZKMiQSsiqBUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayRPhrMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayRPhrMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD3BC32786;
	Tue, 23 Apr 2024 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908555;
	bh=gAYqPg2jEEEm/Pm1UXV7qxZdCyDa2xv57vIeASnhTxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayRPhrMtKT/HVd6jG47ZEsNLGfz3Emo+rbn3GuXCxihsMLrDMEV561tCaEYDdSjYx
	 MH3ETVN+H/8GFSV6/hIzqEf3HMRw9vP+ZsigteKJJB4A9w+Q/WKL/VrikFO1b0spYe
	 4H8Kd3xDUKUXNUhiO8SvBaDm82EpXj9rpQ+nXW7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 158/158] ksmbd: common: use struct_group_attr instead of struct_group for network_open_info
Date: Tue, 23 Apr 2024 14:39:40 -0700
Message-ID: <20240423213900.974796333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -702,7 +702,7 @@ struct smb2_close_rsp {
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
-	struct_group(network_open_info,
+	struct_group_attr(network_open_info, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;


