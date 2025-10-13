Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D305273D6B;
	Mon, 13 Oct 2025 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366859; cv=none; b=KdsHhnyYVgfxu994CO95famiiJvo7aERHvo0OogaV2dK5IMIXGZr3R9QRrJx3LqkLfh+0xLGQHLGlZbmpf7BSAvaHLOCxEwy8MYnBdC7PzL1R+zDJkCMBrfFM0ZTBYZCg06aNUHTyvrCUhaqH8a3HbMUcd1nlT8J2uH2fnf57dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366859; c=relaxed/simple;
	bh=NOnedFGvdCd0oXHmveVDpO1fYdnBK/rQ8Vqv8O2bnTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9/2Xab31fFGsqEZdCdOYgg/ZaU5P8JlROTkqRXoAzJbz4wfnU8Uxzai/S/nrdzTZtNcDSRSONtI6qwokm/0KxlCod0lXcAto+egDw3DrI6eFK2K10Zrb2vAlKtkLklM6+6wIXemdIvqdx7Alqbywpk6AIZi1BoxKY3rxPjWqjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAdok2U9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAdok2U9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55392C4CEE7;
	Mon, 13 Oct 2025 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366858;
	bh=NOnedFGvdCd0oXHmveVDpO1fYdnBK/rQ8Vqv8O2bnTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAdok2U9zFq+XwoVHJfoCQI+hPppCzMauEbasq154RPWxrGdSR+ECjpQ5nzNmAAbu
	 e25D7LIT3/4YDPVywaGbfCWanI94WncomLmEX5cjqYE8AM5lgo2joVaIblbzqfIrOI
	 zVXAe0eSKKnRVsmWCAeE+XedJ4NQbSYMKwREEIXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 001/196] crypto: sha256 - fix crash at kexec
Date: Mon, 13 Oct 2025 16:42:54 +0200
Message-ID: <20251013144314.606419114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

Loading a large (~2.1G) files with kexec crashes the host with when
running:

  # kexec --load kernel --initrd initrd_with_2G_or_more

  UBSAN: signed-integer-overflow in ./include/crypto/sha256_base.h:64:19
  34152083 * 64 cannot be represented in type 'int'
  ...
  BUG: unable to handle page fault for address: ff9fffff83b624c0
  sha256_update (lib/crypto/sha256.c:137)
  crypto_sha256_update (crypto/sha256_generic.c:40)
  kexec_calculate_store_digests (kernel/kexec_file.c:769)
  __se_sys_kexec_file_load (kernel/kexec_file.c:397 kernel/kexec_file.c:332)
  ...

(Line numbers based on commit da274362a7bd9 ("Linux 6.12.49")

This started happening after commit f4da7afe07523f
("kexec_file: increase maximum file size to 4G") that landed in v6.0,
which increased the file size for kexec.

This is not happening upstream (v6.16+), given that `block` type was
upgraded from "int" to "size_t" in commit 74a43a2cf5e8 ("crypto:
lib/sha256 - Move partial block handling out")

Upgrade the block type similar to the commit above, avoiding hitting the
overflow.

This patch is only suitable for the stable tree, and before 6.16, which
got commit 74a43a2cf5e8 ("crypto: lib/sha256 - Move partial block
handling out"). This is not required before f4da7afe07523f ("kexec_file:
increase maximum file size to 4G"). In other words, this fix is required
between versions v6.0 and v6.16.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: f4da7afe07523f ("kexec_file: increase maximum file size to 4G") # Before v6.16
Reported-by: Michael van der Westhuizen <rmikey@meta.com>
Reported-by: Tobias Fleig <tfleig@meta.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/crypto/sha256_base.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -46,7 +46,7 @@ static inline int sha256_base_do_update(
 	sctx->count += len;
 
 	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
-		int blocks;
+		unsigned int blocks;
 
 		if (partial) {
 			int p = SHA256_BLOCK_SIZE - partial;


