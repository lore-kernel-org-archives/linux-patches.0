Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E2A26A0DD;
	Tue,  8 Apr 2025 12:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114915; cv=none; b=CfWAo6R56CT3jkXFR+JBI8zs1yFHoolXUy53DdAQsrJCqaeyimAAThP0bnmCSIcnXEJDgOMB90suHZN9Ir5+gaG1w984RjjbbvPPomlDstNJdF+4O1CFIdrgDbFaOnIZH9MsmQLL+OQQTgjMRE6p8thxSdLwC95BNjvZY5hIaMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114915; c=relaxed/simple;
	bh=OUTgoHamnwBGQLQM8Z2a2U0hrYnQApAziLat5N+145c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlQGPIIitVJGap/CWpTMJ02mcFpTtbOhQHASuw9mnSqgvMDdWu3MeQrcAh7iQP4r74vQPm0lJs1DLDHg/x+Q0+H4Fe5ZGFPSI21gRRsmXrwozMoCBB9ByP/e5xhBfzXxoAZMZvqoU47+kVn8NH4W03693tx9j5NYU/hb3+8QTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp5M3KLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp5M3KLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92FC4CEE5;
	Tue,  8 Apr 2025 12:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114915;
	bh=OUTgoHamnwBGQLQM8Z2a2U0hrYnQApAziLat5N+145c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp5M3KLxIJSdPqXZJGev/DtIkA2DGvIzaqjszD9roGFhq873x+26C1S+xy6JGyB7A
	 +dQqg2lAJWEYX+6Ou3Ol+Waz2ev7zsGXGJmJReMhcJBcHKF8I6oQUWEPIX0IxT1N/C
	 7MY7C256dZJ/uS4IUonx5Mt/qI9V1fizeg5k41rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 281/499] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue,  8 Apr 2025 12:48:13 +0200
Message-ID: <20250408104858.225140122@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2a5b4a96bf993..00b31cf864627 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1218,7 +1218,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
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



