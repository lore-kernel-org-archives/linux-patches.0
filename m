Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210B13B7AE;
	Thu, 23 May 2024 13:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470582; cv=none; b=VZvAOQKYyb2Av8oYWbW1lTziNQcbJl4zyDgKHMdzrT3oE5fz5h/thwQyfyAim6XgTiTbcafM/kHKvVz+M7sWB9x8vG99ojADyfXMH9nKw6hElUmDD+ntMeRWCm9zdjdN/D3dI8j76STWT2Nj1Dy+5dvutp61GbrgxPAd3XCKt4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470582; c=relaxed/simple;
	bh=Vh3or43PNBwdb2fgoGEglzIdVY4zXSDDCgRUVuip/wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1be8xtSLhCRkkxmlmxh/yP954It5f2igauI2fzYRbQsaA+/rOA5hr1+FMeh/NUiWebvB8AbFduU9FkArwn1gJTHy7D/B3UdB1e/XV3uP0T3ngp/X2RXgXr9myau4mguC1AUMiD6qznp10ajIBFkxFQgn0ELJMsUGiVubEW++2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3N38VOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3N38VOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90370C32782;
	Thu, 23 May 2024 13:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470581;
	bh=Vh3or43PNBwdb2fgoGEglzIdVY4zXSDDCgRUVuip/wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3N38VOhz5KFBfDnceaAWykiQ0VXgm0Nmyd+oZINHX3FCe1pV1OdF9hx5uyjxQkWn
	 JgIsz13kiF18p2Waph3YaspPWjeGthNSpnSu2DTbbcu+yf+QluUysa2WmaLQwppTY+
	 bw2/iv2KmH6WOFiOx1JSykMkZVJFmKNXKZanYoos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/102] smb: use crypto_shash_digest() in symlink_hash()
Date: Thu, 23 May 2024 15:12:29 +0200
Message-ID: <20240523130342.631252419@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 783fa2c94f4150fe1b7f7d88b3baf6d98f82b41b ]

Simplify symlink_hash() by using crypto_shash_digest() instead of an
init+update+final sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 6c4ae52ddc04f..3ef34218a790d 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -42,23 +42,11 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 
 	rc = cifs_alloc_hash("md5", &md5);
 	if (rc)
-		goto symlink_hash_err;
+		return rc;
 
-	rc = crypto_shash_init(md5);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md5 shash\n", __func__);
-		goto symlink_hash_err;
-	}
-	rc = crypto_shash_update(md5, link_str, link_len);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
-		goto symlink_hash_err;
-	}
-	rc = crypto_shash_final(md5, md5_hash);
+	rc = crypto_shash_digest(md5, link_str, link_len, md5_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
-
-symlink_hash_err:
 	cifs_free_hash(&md5);
 	return rc;
 }
-- 
2.43.0



