Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3763E8C46;
	Mon, 17 Aug 2026 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975356; cv=none; b=bcpKO2E9D10nk+1ww8y0HiKE+8z8xUiLb/CCJv83996GW4hstFZEcQu1RAqgwnPB/0czgnTgfftRBdX5A9cTvlGEBUUdvY1yw5jOBMS5Uv75iHcef9ButYqPBFUl1rfAOdUx8g/EymaVjYCUsn53Q5YPzG0yhRNnNRsUdHzvaKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975356; c=relaxed/simple;
	bh=JYntlPeloHdcvwZ+fy0T3+8qcHqL47Pz5B4swgwHmsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeiAap/K7MLhELLAwlXM9fo7cZOfNkLaFbVCMEDoYrPx4UnP3aoflWUlNce6zNV6yQk8xBW2f2AYBQrIeUh9fJZ9NJ3ZD1KTA949R+sEYviXb6H+S6dE9DOQZy+oOCbeNFjI58JE6LzNtrvFyhS99NqFEW4y2oxaIFwU4OxYLFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h40K79pG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h40K79pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEE91F000E9;
	Mon, 17 Aug 2026 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975354;
	bh=OKUIjlIubDq7nS0V5icUod4hyQNdjmXIp1b7Ltqknh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h40K79pGlkD9sDMrKpflo6Od9EEuyEmgsSrgPUjKVvF9Mf3K6hGs8BxSJs2MQJ6S+
	 IBE1MdzInuaOtJB/Z9b2rh4tyVttXVYp/Y1OklshuYJ7fkaAAKsTvCJzsEPCpMOdkJ
	 xpL6V5sFcBChIldjaEGj2ECF5WcJ66eeeqkOW1Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 6.18 241/250] fsverity: Fix silent truncation in bpf_get_fsverity_digest()
Date: Mon, 17 Aug 2026 15:33:22 +0200
Message-ID: <20260817132546.336853334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 7c68ed5c5ad4c185ea9654f5d8ee36560277b7dd upstream.

bpf_get_fsverity_digest() silently truncates the digest if the provided
buffer is too small.  This is a footgun, and it doesn't match the
semantics of the equivalent UAPI (FS_IOC_MEASURE_VERITY).

Change it to return -EOVERFLOW instead, matching FS_IOC_MEASURE_VERITY.

Fixes: 67814c00de31 ("bpf, fsverity: Add kfunc bpf_get_fsverity_digest")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803181232.14743-3-ebiggers@kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/verity/measure.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -144,14 +144,15 @@ __bpf_kfunc int bpf_get_fsverity_digest(
 
 	hash_alg = vi->tree_params.hash_alg;
 
+	out_digest_sz = dynptr_sz - sizeof(struct fsverity_digest);
+	if (out_digest_sz < hash_alg->digest_size)
+		return -EOVERFLOW;
+
 	arg->digest_algorithm = hash_alg - fsverity_hash_algs;
 	arg->digest_size = hash_alg->digest_size;
 
-	out_digest_sz = dynptr_sz - sizeof(struct fsverity_digest);
-
 	/* copy digest */
-	memcpy(arg->digest, vi->file_digest,
-	       min(hash_alg->digest_size, out_digest_sz));
+	memcpy(arg->digest, vi->file_digest, hash_alg->digest_size);
 
 	/* fill the extra buffer with zeros */
 	if (out_digest_sz > hash_alg->digest_size)


