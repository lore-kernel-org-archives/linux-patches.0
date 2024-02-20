Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6673151CC3;
	Tue, 20 Feb 2024 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463018; cv=none; b=TktaCIBX1qzoVnYBH54koTympTrBquwkLG3VCJdXLN6wMwo+MI36fwCahLUlghbKJqfBBPXcR/mNLeF85EJjdsjObsMACgKWxc7vSU8k9sUU9JTCBdYcAb/GkcIjF+knPbA6ISGuedCCx3uk9hgQ7UMqOfupuiUj+BFMrkocSVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463018; c=relaxed/simple;
	bh=2OEAkvLUi12YUFQUXGv0osLG8kXdc2TvQQwM0NangNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELf5lfvfycZr8zHreM6AkwHEa9HROckO5LbIugi9T8igK201vGHVvSXb1JGu0riyniXOOzbm9898b8CMO53s9U26TyaicZ2caf/Tzbfobldqhdcv/pFO3MQpG24TqvbAqtLD5DIoMaYRqWfd3JZUUkQDltopWdiDBpgwB6bG/Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjNxEdoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjNxEdoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2A0C433C7;
	Tue, 20 Feb 2024 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463018;
	bh=2OEAkvLUi12YUFQUXGv0osLG8kXdc2TvQQwM0NangNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjNxEdoBnGUdIPX9+RDMK0HVj7gU+qehs/AlFvkikDA5V4vYUPL3+JIAP1iBqaQ96
	 sBMn1f01X+qIexUyweriSavcpgS/uoXHlzp+nI5VgEILOVl4svYul+KSWCkfwdDONr
	 OXcRv6KtZHLHkvvxTFqf6I6FR/Hac1k91+OWfB8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 110/197] ksmbd: free aux buffer if ksmbd_iov_pin_rsp_read fails
Date: Tue, 20 Feb 2024 21:51:09 +0100
Message-ID: <20240220204844.373670044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 108a020c64434fed4b69762879d78cd24088b4c7 upstream.

ksmbd_iov_pin_rsp_read() doesn't free the provided aux buffer if it
fails. Seems to be the caller's responsibility to clear the buffer in
error case.

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6171,8 +6171,10 @@ static noinline int smb2_read_pipe(struc
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 					     offsetof(struct smb2_read_rsp, Buffer),
 					     aux_payload_buf, nbytes);
-		if (err)
+		if (err) {
+			kvfree(aux_payload_buf);
 			goto out;
+		}
 		kvfree(rpc_resp);
 	} else {
 		err = ksmbd_iov_pin_rsp(work, (void *)rsp,
@@ -6382,8 +6384,10 @@ int smb2_read(struct ksmbd_work *work)
 	err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 				     offsetof(struct smb2_read_rsp, Buffer),
 				     aux_payload_buf, nbytes);
-	if (err)
+	if (err) {
+		kvfree(aux_payload_buf);
 		goto out;
+	}
 	ksmbd_fd_put(work, fp);
 	return 0;
 


