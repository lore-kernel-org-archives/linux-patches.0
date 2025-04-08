Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471CC148;
	Tue,  8 Apr 2025 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116692; cv=none; b=pbg0nZNDFTKaXQRI3DlgxgQmeIVIYOpeg/5n9ETxG/cEqaJ3ww+6+i+4yWh+szuVb17btOJSHA4M/287chpAjteaG0BvbYVTt2rJlyb1rn4chEVKge7xLH7JHRoEKxd7gPWYure3ZOvyw93vK3DSXaJeKgcI4sWA3v78GFMM6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116692; c=relaxed/simple;
	bh=NG/8mxazQVWPibNvyV/KO3Y0/HPO4+abcNSLLthMlEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8FGOg89GlOsGHPQecAgjtj+zK2abZNAn4sWk+d2eakwdaMYtqKEwNRhM6oYUyXf+BTZxjeuUkaUPs2Rtra2pbD5ycswVXlF7tB03/YQt8l+znw8Ica4fd7YHLMweh1G2B4GN7wUSA0SbD4urTugu+lK6oscBrNmQ88R1sDgK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjzdKcVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjzdKcVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBF4C4CEE5;
	Tue,  8 Apr 2025 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116691;
	bh=NG/8mxazQVWPibNvyV/KO3Y0/HPO4+abcNSLLthMlEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjzdKcVfLssx43Wq/n+IBxNNG3a3QPSnjfyIu08bCfDcqXpKCyfMOlcMJnaYX+iZA
	 TmoYeHA9zHMWaW9S1pAPJtOBJxcGeQQhIagtoQ8d42rQa1PWoalzshvB/LYD0WEwtr
	 rQ1a9c9W83kib0otfvbEHCIkV+LlIoOwrpeavwMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/423] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue,  8 Apr 2025 12:49:20 +0200
Message-ID: <20250408104851.178011868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8892177e500f1..0d458742b7074 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1217,7 +1217,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
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



