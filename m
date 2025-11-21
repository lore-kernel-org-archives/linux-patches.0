Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268F6267AF2;
	Fri, 21 Nov 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733155; cv=none; b=DcJhjNekJQtzAEaHj12Wv1AAgu6rDh6tcRR9KogSec6+nZYLoR/zg0PGaIwIKMEVfVQNG/NVV0YkTMGA7NIygUyKIPSdhvNUaQU6glZJdGq5cSBtqa+AF8EKlMc8GLmwAap+zCxp+xkp0zGX/cSVy+PVwRgHLrT3tokLeGsm20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733155; c=relaxed/simple;
	bh=H4ef1xg5LmXM04WIZdtcUKQr3dShSkOgivzcmM0e5oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1TTsFRvjpoMzyZNM9NoOMr8PfDivdiv/BbT0YZ8QLl2yxVNzB5jVj38b1xq1qTP3Z3vhZDC0VTJXD1P7jxmU4F9ruyHXF1IqbHYpG+YQay98lViwhwvgGla6sjyClyjxCP8dnk4alqat7750nAqWaa/0mxsFTYkUBO9Zk37ixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvR6MK0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvR6MK0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF1EC4CEF1;
	Fri, 21 Nov 2025 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733155;
	bh=H4ef1xg5LmXM04WIZdtcUKQr3dShSkOgivzcmM0e5oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvR6MK0ogaozV6MncVIdbhh/Xem9fWT1K55i9WOTcaQzRE3wY3VLHUYLt0v3CsOHp
	 Q20AAbFYwgkf3o9XoegsmyUEhul67U0aT2GHmmE0UdqiVWNH2AJlADkceM4h2g2+OP
	 E4nZDDSxTt7ytqQWXgm6qzTYTr50lLVoNVpd4uMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 370/529] lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC
Date: Fri, 21 Nov 2025 14:11:09 +0100
Message-ID: <20251121130244.192074575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 2b81082ad37cc3f28355fb73a6a69b91ff7dbf20 upstream.

Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
for GCC unconditionally because clang-min-version will always evaluate
to nothing for GCC. Add a check for CONFIG_CC_IS_CLANG to avoid applying
the workaround for GCC, which is only needed for clang-17 and older.

Cc: stable@vger.kernel.org
Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251103-curve25519-hacl64-fix-kasan-workaround-v2-1-ab581cbd8035@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -31,7 +31,7 @@ libcurve25519-generic-y				:= curve25519
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 


