Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073F71BDE7;
	Wed,  3 Jan 2024 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdktFonv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62325C433C7;
	Wed,  3 Jan 2024 16:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301012;
	bh=FcqkHgUKhwx6yTVg/1y05jx5zU+uxbS6ReGZNjYDZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdktFonv70cA8Fj4CflKmk4ddjFhp5/Umd5K3OCC+ziYWCWND9c3zz75t03uFV1Xq
	 Ri/ZRq2QuFJGbjBNNuadDeLPUgaDSTEavlHuUMt7lbbOQ8mLODke7sU2G7T+EgJe4X
	 IwSXKFkAm7Mwkm/OGVNpoVPClVApkWzMBuCCUXC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/100] ksmbd: Remove duplicated codes
Date: Wed,  3 Jan 2024 17:53:57 +0100
Message-ID: <20240103164857.433898748@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit 7010357004096e54c884813e702d71147dc081f8 ]

ksmbd_neg_token_init_mech_token() and ksmbd_neg_token_targ_resp_token()
share same implementation, unify them.

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/asn1.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/asn1.c b/fs/smb/server/asn1.c
index c03eba0903682..cc6384f796759 100644
--- a/fs/smb/server/asn1.c
+++ b/fs/smb/server/asn1.c
@@ -208,9 +208,9 @@ int ksmbd_neg_token_init_mech_type(void *context, size_t hdrlen,
 	return 0;
 }
 
-int ksmbd_neg_token_init_mech_token(void *context, size_t hdrlen,
-				    unsigned char tag, const void *value,
-				    size_t vlen)
+static int ksmbd_neg_token_alloc(void *context, size_t hdrlen,
+				 unsigned char tag, const void *value,
+				 size_t vlen)
 {
 	struct ksmbd_conn *conn = context;
 
@@ -223,17 +223,16 @@ int ksmbd_neg_token_init_mech_token(void *context, size_t hdrlen,
 	return 0;
 }
 
-int ksmbd_neg_token_targ_resp_token(void *context, size_t hdrlen,
+int ksmbd_neg_token_init_mech_token(void *context, size_t hdrlen,
 				    unsigned char tag, const void *value,
 				    size_t vlen)
 {
-	struct ksmbd_conn *conn = context;
-
-	conn->mechToken = kmalloc(vlen + 1, GFP_KERNEL);
-	if (!conn->mechToken)
-		return -ENOMEM;
+	return ksmbd_neg_token_alloc(context, hdrlen, tag, value, vlen);
+}
 
-	memcpy(conn->mechToken, value, vlen);
-	conn->mechToken[vlen] = '\0';
-	return 0;
+int ksmbd_neg_token_targ_resp_token(void *context, size_t hdrlen,
+				    unsigned char tag, const void *value,
+				    size_t vlen)
+{
+	return ksmbd_neg_token_alloc(context, hdrlen, tag, value, vlen);
 }
-- 
2.43.0



