Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD7143897;
	Tue, 23 Apr 2024 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908554; cv=none; b=HCobpHS/AgpHJdOUJl9FcU20ZT6tiB2bDVqgesk3k9Z9Hyan8ipMWYjnS3l6fZD5SrqlixuOqCrarCF4CiL355p6EggWDZEKonEHbAmBXRFNXmChh6fmWN1aSsNmlPKx+liFfx0Xnl7d1AaDNiHda/E4lsTGTb0kLVOzqEQ2Jp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908554; c=relaxed/simple;
	bh=/YtTmdomJQWaL3IMJ1DvHIBPS7dd+HCSpc7F9gwNFG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lr+qvbN00/yOCsLlIpLEBKKKKIa5ZHxYhbpjcWxZlEQ8R/qEHfJ1ji8h4BAf4mXgQ78FaaHaUtv2lOyk5nzSZ6EQxMmH+gXduK3o18BTCJksb32EMtTG5aOMBAwfcuFd+naGxV3Y7uMf0ckupPBMCnz9RPJxbDnZ1df/zR9ISPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhYkXST+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhYkXST+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD2DC32783;
	Tue, 23 Apr 2024 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908554;
	bh=/YtTmdomJQWaL3IMJ1DvHIBPS7dd+HCSpc7F9gwNFG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fhYkXST+yZkSQec+w+ZdCLZ8JAsUAUZ4oW0lw7Cx3fABaZ161rZAnD0cB6yMXqldL
	 fWIT/AK31+i1MNzyzqNVGB2c6j1nx9XTnyHI0YyGQaq/ZCjTXEwNeaIAGE5iwxfnEm
	 zusIZaxhs5CFhAUuF0wj8vPonwdA+qmL+7FzjnzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 156/158] ksmbd: validate request buffer size in smb2_allocate_rsp_buf()
Date: Tue, 23 Apr 2024 14:39:38 -0700
Message-ID: <20240423213900.917808392@linuxfoundation.org>
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

commit 17cf0c2794bdb6f39671265aa18aea5c22ee8c4a upstream.

The response buffer should be allocated in smb2_allocate_rsp_buf
before validating request. But the fields in payload as well as smb2 header
is used in smb2_allocate_rsp_buf(). This patch add simple buffer size
validation to avoid potencial out-of-bounds in request buffer.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -535,6 +535,10 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
+		if (get_rfc1002_len(work->request_buf) <
+		    offsetof(struct smb2_query_info_req, OutputBufferLength))
+			return -EINVAL;
+
 		req = smb2_get_msg(work->request_buf);
 		if ((req->InfoType == SMB2_O_INFO_FILE &&
 		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||


