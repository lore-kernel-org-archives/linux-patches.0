Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1579B48788;
	Wed, 20 Dec 2023 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzwfhkh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55958C433C8;
	Wed, 20 Dec 2023 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088839;
	bh=lDwjWk81w3q6Ts9nrifdAKbaAlO7QZ3msDlCjBpiwjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzwfhkh7uxrmrvuKVJAXzrPvSKUaIMHBEj3WTXMKlsfCw2kOvDm12mKDUBQLfbchl
	 vdGTmX7/NAIxu8D549eS/7EA9Qu5GJEhpByP08dai0A0c29rdPVagroWohiEGqNPpA
	 OCuySPgBu0laqiFsZw/sp65CoZ+OH6dxS2x5vAtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Lihua <441884205@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 078/159] ksmbd: fix wrong signingkey creation when encryption is AES256
Date: Wed, 20 Dec 2023 17:09:03 +0100
Message-ID: <20231220160935.012171393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 7a891d4b62d62566323676cb0e922ded4f37afe1 ]

MacOS and Win11 support AES256 encrytion and it is included in the cipher
array of encryption context. Especially on macOS, The most preferred
cipher is AES256. Connecting to ksmbd fails on newer MacOS clients that
support AES256 encryption. MacOS send disconnect request after receiving
final session setup response from ksmbd. Because final session setup is
signed with signing key was generated incorrectly.
For signging key, 'L' value should be initialized to 128 if key size is
16bytes.

Cc: stable@vger.kernel.org
Reported-by: Miao Lihua <441884205@qq.com>
Tested-by: Miao Lihua <441884205@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -730,8 +730,9 @@ static int generate_key(struct ksmbd_con
 		goto smb3signkey_ret;
 	}
 
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
+	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
 	else
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);


