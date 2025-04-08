Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6C8269801;
	Tue,  8 Apr 2025 12:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115949; cv=none; b=pu744R33SeOb5GE5JyZfzrq53sT+Oyh8r6kNTDfeqIWnrVOieuk8r9RZppPlWqJpj1Sl6duqV34lm8IaMUW8VMqfFbzl9v8VRylW7nmLqIY0Tl9TX9U9liFH5oa5qBEQzYcFN3BpWjEaZpM0RNQSFdmFM7w9I+TziXP3rEt42fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115949; c=relaxed/simple;
	bh=UlhvLk5FlU9u6fbjGuWAFkA3d5eiv0xPvoY9KE1WTL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmIC+DqwtjDYSeScOWxWTcG0KMDBwszmYDCGLpMNzOS5Bre/0iDQdolH4cqgQMwTPbGUcy7fI3wnysc4MVU9a9oVHB3Z58qsYV3ZJ6Pcxid7nhy5wq1pjdzVblWD5pLt+s76KvwvTl6NHyxdvS1x/HJVC5qE93PUPP/Y1jswbZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQkQswoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQkQswoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9C4C4CEE5;
	Tue,  8 Apr 2025 12:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115949;
	bh=UlhvLk5FlU9u6fbjGuWAFkA3d5eiv0xPvoY9KE1WTL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQkQswoRD27gTIN3jJxGaP4POVEsvlyBz4ichktLgo++mE2MvxNppmqYD+emgXDml
	 9UtYbBXh7wNMFwa9hAhXlBVvcY0mASVPAgOEoXDlOuEfuD4VLJSsbCMgFKL520tiYv
	 0HLh7/Q3I4GicnOF1ODrxDmxPNCPl8/0AIYdUp1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/204] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue,  8 Apr 2025 12:50:45 +0200
Message-ID: <20250408104823.695867831@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 6171063e9d046ffa46f51579b2ca4a43caef581a ]

Use aead_request_free() instead of kfree() to properly free memory
allocated by aead_request_alloc(). This ensures sensitive crypto data
is zeroed before being freed.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 8e24a6665abdb..c34b30642bfdd 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1211,7 +1211,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 free_sg:
 	kfree(sg);
 free_req:
-	kfree(req);
+	aead_request_free(req);
 free_ctx:
 	ksmbd_release_crypto_ctx(ctx);
 	return rc;
-- 
2.39.5



