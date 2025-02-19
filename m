Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522E1F7586;
	Wed, 19 Feb 2025 08:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954861; cv=none; b=mJaZTrzTpBwaCPvEUZw+Jb5bag4Wex/XcTjSKU114lCD8fWKkGl6dOSl0+N+ghM8VJRbaEDZVwt9Rnfen9XCQj1ocvt76ZF62TvCEI8STLgoZmxp8veh8Y+yA1q+C6R/slWoXdq9FXOL/7NIjy/OgIrQAaGkgWjKRHx8NCLZKik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954861; c=relaxed/simple;
	bh=Jt/gROSNTXpyHV4PPHtqCBMRzDG9FbxyS1ARks2Dm0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2MW64aCeDqxHGy7QSNEjPX9+Ny6X7wexeW0EutrsKb+8sKqJP2LkfZ9TCYjKvQ7NE2TbXfbs2524sL3iixCTft2lepeqA8TUV3OBRs39d/np4EFKjBN1G8e5+PaDxax60JxjXQTuc9TGRmVcpMZ7kVfu6jch3cWWwPT83f5g28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLslolqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLslolqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A134C4CED1;
	Wed, 19 Feb 2025 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954861;
	bh=Jt/gROSNTXpyHV4PPHtqCBMRzDG9FbxyS1ARks2Dm0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLslolqHDlmAy7f+K9DxoqeDkU85QnTqXNV3QDNP/W5e96M89zf4XWD5IWlloep4Y
	 yxsrZxPtRYtgq5H7E+guKj3So+nzUwectIuIRhfPpN180gV1x2otdQoxb+WZIgpxXM
	 0yOiuWgKZ8wiaCSSArfj2PXIAL7ckeL+/V9/fZNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/230] LoongArch: csum: Fix OoB access in IP checksum code for negative lengths
Date: Wed, 19 Feb 2025 09:25:44 +0100
Message-ID: <20250219082602.769780001@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit 6287f1a8c16138c2ec750953e35039634018c84a ]

Commit 69e3a6aa6be2 ("LoongArch: Add checksum optimization for 64-bit
system") would cause an undefined shift and an out-of-bounds read.

Commit 8bd795fedb84 ("arm64: csum: Fix OoB access in IP checksum code
for negative lengths") fixes the same issue on ARM64.

Fixes: 69e3a6aa6be2 ("LoongArch: Add checksum optimization for 64-bit system")
Co-developed-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/lib/csum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/lib/csum.c b/arch/loongarch/lib/csum.c
index a5e84b403c3b3..df309ae4045de 100644
--- a/arch/loongarch/lib/csum.c
+++ b/arch/loongarch/lib/csum.c
@@ -25,7 +25,7 @@ unsigned int __no_sanitize_address do_csum(const unsigned char *buff, int len)
 	const u64 *ptr;
 	u64 data, sum64 = 0;
 
-	if (unlikely(len == 0))
+	if (unlikely(len <= 0))
 		return 0;
 
 	offset = (unsigned long)buff & 7;
-- 
2.39.5



