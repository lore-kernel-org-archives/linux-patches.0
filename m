Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13335962;
	Fri,  3 Oct 2025 16:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507693; cv=none; b=AJ0cgYjfYHXB8OdlyHfA9Bi1B1Sbjt890OF8yLiyi7TvW73UHQoPeX4KJbgO+nEBgy6xjQZuHKi0iOzVE+G5G+4uvH1fxlX67IkT0DXAAVWQUOv2ogGy18y/uOiIYr0d06gA735KjD9My7E1b2OVhav9CAgxw7FiW74HmCxV/fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507693; c=relaxed/simple;
	bh=ZUUiLPJ3c+xgSXUwgj/CK9MveF4AoPt+UXCHtU4niHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNLC7tcPktAdf97+cvU9T7GlnuQedb6jWxHEn6gj83Cxy24ryNsDz6aL2pAiAWDPUE12yaNhAtjfFUwKIFa8KSv5ws+2aMhTqqjKWh2WFqINzcWsazRUs9jA5SnSSBwCurGKdAqrdvQdBzrP+xF5qTrufyVa+0O68PA0Uwh9d2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btq8XavA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btq8XavA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3883AC4CEFB;
	Fri,  3 Oct 2025 16:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507693;
	bh=ZUUiLPJ3c+xgSXUwgj/CK9MveF4AoPt+UXCHtU4niHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btq8XavA24HyS6bgezOTIREzrsoOYvq62pq3SnRjruHm6OWZPGYmld+vvvxnoTS3G
	 uQRptEVtFdpovJDv6gItPhBTm4/Q6A4z9bOSLQ9qLy5R0ZPNK4E3Ft8WPAD7OKYDi0
	 AGdh0cedFR5aD569LR/wMxowy6VXxh63qxAsgBig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 01/10] crypto: sha256 - fix crash at kexec
Date: Fri,  3 Oct 2025 18:05:48 +0200
Message-ID: <20251003160338.506948730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160338.463688162@linuxfoundation.org>
References: <20251003160338.463688162@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,7 +44,7 @@ static inline int lib_sha256_base_do_upd
 	sctx->count += len;
 
 	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
-		int blocks;
+		unsigned int blocks;
 
 		if (partial) {
 			int p = SHA256_BLOCK_SIZE - partial;


