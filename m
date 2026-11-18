Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021356;
	b=eiloedtRzrh5B0fm9deFsJaOeolWFelF+uwkdFOrUcgdSed7s6CqP8/SaAs6gtu3PwoG
	 Ei3KmY6FiBa56UUJ7q5A8VmcX8M+5hRWk3p58SvIi/Hr2ZbWEKg/v9cwjgxo2/jwHY/Hk
	 NcC3ceXm6R0W7x2ou103KiaUrPllEYoCoAzCe2r+PrXE3MZA4LlJeEDRVikYSohJ0wLY4
	 teiL+bdxMVwCDI6unI48pFiAyy4DfRtwsN1KIsZGvBy9leaxKK0DWhGYP/VL0bfkNCnah
	 YWGVCLG9DjgQOLXN/hERqxHAes2YeEHc+2U8NTWHL6w11NHHB9TKUUcjmRWu2IJfYxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOZGKkefp+Y2i+07YOQPTB5y8i9AjYn1MN0yK1IS3SM=;
	b=mfwNGU1oyq7aBHSyanbwQ8RNMkN64guFUw8goErVvc8mx6ZC0sFae1If4gu5i8GsTABj
	 zYle2D5ykrOZEi/RHXfOpdyE2ttCubaSFi+IS6RiIus6LLVMXG7BjRzDy6OzArFxoqYos
	 b1ed/BFn2GRyVIPRF86B8Rn8wrc9T27H7xlfiBkbWwZySCzXqJrU/3MA7gKn8OzJ2Uajw
	 wjjIJY12R2CQDcbR1FYkq/jDKcdMNajUu883WejrO7GgnMsccTc0/mLjANbuUq+URuEVq
	 bIMVksj1OM/zOJc6wwraj3TsN3KCL8VIT0ApSR540Y5XomOTaxCr/XWedoYb1ZsgX6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5ir8eIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718C606A32A;
	Wed, 18 Nov 2026 17:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5ir8eIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0E21F000C4;
	Wed, 18 Nov 2026 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021355;
	bh=WOZGKkefp+Y2i+07YOQPTB5y8i9AjYn1MN0yK1IS3SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5ir8eIHxeZ6I1M7dMMTsZteB1FS7uaf/zDevGFJzDbnzVj1eGvHXcAEIlOIB43sm
	 tREmK7uL69p8TCAguS+bcReqP5FX7vU7Ra4qEWc4QNC8B4rlGHCiagCMFqBbWfZcM/
	 jH9BlgKgfCZ4gGBNJ5GbiUjV2rFFV00Fk/yT4EEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	1sh1ro <yangguikun19@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2227/2651] ntfs: fix NULL dereference on index allocation open failure
Date: Wed, 18 Nov 2026 15:57:47 +0100
Message-ID: <20261118150405.725151950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9365c4a1357e2a5d7f1aff140429028ad292161f ]

ntfs_index_lookup() returns -ENOENT when ntfs_ia_open() fails to open the
index allocation. This error path leaves icx->ib unset, unlike a missing
key in an otherwise valid index, which returns an insertion context.

ntfs_ie_add() treats -ENOENT as a valid insertion position and dereferences
icx->ib when the lookup is not in the index root. A corrupt $I30 bitmap
attribute can therefore cause a NULL pointer dereference when adding a
directory entry.

Return -EIO for index allocation open failures so insertion aborts through
the existing error path. Keep -ENOENT for genuinely missing keys and
document that other errors leave no valid index entry.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Reported-by: 1sh1ro <yangguikun19@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/index.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/index.c b/fs/ntfs/index.c
index 580998990bc95..03de4c97c1620 100644
--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -812,6 +812,9 @@ static int ntfs_icx_parent_dec(struct ntfs_index_context *icx)
  * after the search @key, i.e. this is the position in the index at which
  * an index entry with a key of @key would need to be inserted.
  *
+ * If the index cannot be searched, a negative error code other than -ENOENT
+ * is returned and @icx does not describe a valid index entry.
+ *
  * When finished with the entry and its data, call ntfs_index_ctx_put() to free
  * the context and other associated resources.
  *
@@ -877,7 +880,7 @@ int ntfs_index_lookup(const void *key, const u32 key_len, struct ntfs_index_cont
 	/* Child node present, descend into it. */
 	icx->ia_ni = ntfs_ia_open(icx, ni);
 	if (!icx->ia_ni) {
-		err = -ENOENT;
+		err = -EIO;
 		goto err_out;
 	}
 
-- 
2.53.0



