Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F05731A7E9;
	Wed, 17 Sep 2025 12:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113292; cv=none; b=SKXFhNADryGOqYjxq6E9olxv/JsAIkiMBf2x59LSamNroKn2rZl4ZsP/Wmw93XNdVg4Q4IeSV/3IHpH1CYAJ/R0GrI7q3rs3MS1gotXdTBFQdRsM72r2GhNxQLJ+Ptw13aW6PIt1W6F+gqLK7E4UOMoLQSr4o1JIs94ZLDjP50g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113292; c=relaxed/simple;
	bh=phg9I8u7yzqBAaqn27JlMy555nhsEXchaoX6RvYO22A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMiCapTbdn2JBYIvCBdnhZNCnTzm92CMYrMBhBOQ/aoILrQTI8c0+VU6DioTGfiVQpTUJ6z4gurrlB0DY1BjXEc1uNUbT5daIfHL/MBORijNDufxxuuGWC2I33czWq8mJ+ycfExmxOKo3J8QW0oM7C8YuPu6TCzLyrmLHwp8Zwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V16N8lrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V16N8lrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D73C4CEF0;
	Wed, 17 Sep 2025 12:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113292;
	bh=phg9I8u7yzqBAaqn27JlMy555nhsEXchaoX6RvYO22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V16N8lrwdunUJx12XEKkISZKs5EvMX5AbmoQ2X09G9jiaMNfekaJyszb9Ln7aCqQj
	 5Wy45N05z5HyeNXMUAqi5oVba2B53LX8QqQI+LKx8dD9sQWjYHArlqYtZ4bvmzeAO7
	 5iIXi2Y3c3s5Sl9kWF/1dyVz81C50Hnb2DFZstIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fort <disclosure@aisle.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/140] bpf: Fix out-of-bounds dynptr write in bpf_crypto_crypt
Date: Wed, 17 Sep 2025 14:33:34 +0200
Message-ID: <20250917123345.333172747@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit f9bb6ffa7f5ad0f8ee0f53fc4a10655872ee4a14 ]

Stanislav reported that in bpf_crypto_crypt() the destination dynptr's
size is not validated to be at least as large as the source dynptr's
size before calling into the crypto backend with 'len = src_len'. This
can result in an OOB write when the destination is smaller than the
source.

Concretely, in mentioned function, psrc and pdst are both linear
buffers fetched from each dynptr:

  psrc = __bpf_dynptr_data(src, src_len);
  [...]
  pdst = __bpf_dynptr_data_rw(dst, dst_len);
  [...]
  err = decrypt ?
        ctx->type->decrypt(ctx->tfm, psrc, pdst, src_len, piv) :
        ctx->type->encrypt(ctx->tfm, psrc, pdst, src_len, piv);

The crypto backend expects pdst to be large enough with a src_len length
that can be written. Add an additional src_len > dst_len check and bail
out if it's the case. Note that these kfuncs are accessible under root
privileges only.

Fixes: 3e1c6f35409f ("bpf: make common crypto API for TC/XDP programs")
Reported-by: Stanislav Fort <disclosure@aisle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://lore.kernel.org/r/20250829143657.318524-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 94854cd9c4cc3..83c4d9943084b 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -278,7 +278,7 @@ static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 	siv_len = siv ? __bpf_dynptr_size(siv) : 0;
 	src_len = __bpf_dynptr_size(src);
 	dst_len = __bpf_dynptr_size(dst);
-	if (!src_len || !dst_len)
+	if (!src_len || !dst_len || src_len > dst_len)
 		return -EINVAL;
 
 	if (siv_len != ctx->siv_len)
-- 
2.51.0



