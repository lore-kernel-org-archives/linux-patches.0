Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D7263899;
	Tue,  8 Apr 2025 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111889; cv=none; b=VTLamwPVu4yR/Nx6rFK+KhSckhmDDM2XbJTB5USt++OxABPXidovJnmgwQ+H4rIILwwgeW+ti5LWhK1BVlPZHzcXC/5z9B4XegP91+HvS+jUd0KAwULkQukhvWuDOoi8Dd6jSeMb/qQVDPZzp2OmEssvbxJoPXHheYguZVHR/ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111889; c=relaxed/simple;
	bh=J9z8d1eu7g55tSgYHNRT2/me1e/fjVM7UDhTgwvTFqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDt5QMSoOgCEZJT1saX8S4TNrJvIlTznbizEgKRsZlwATy3hQ0klR7RStAepTBEI+dLr2ckH9Nk6ai31/UAYOqsW/Ut7HHhGM+l+LL/iK/zccQgtspPBqv+aadgFgQV0pRQ5JllM/EKV1zq9+g5hssZFHhvbYONfWQxv+ceTGG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqncQGKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqncQGKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FC9C4CEE7;
	Tue,  8 Apr 2025 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111889;
	bh=J9z8d1eu7g55tSgYHNRT2/me1e/fjVM7UDhTgwvTFqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqncQGKL6E+5+dxteyPEaKDceLRroc4EJqwj8/OvQsKcSrlhGRvixRfyk0ZH0d/Fr
	 g4iWsqjhpd/q8mlAeJkTRf9QifdA5sjtVv2wbSOTgmq2+e1iwnd96e+rE/H0leL/NA
	 PRtSZYH/G+6ZlizRF2sZJGkhRio1tOwRdq3w6y7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 557/731] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue,  8 Apr 2025 12:47:34 +0200
Message-ID: <20250408104927.232232649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



