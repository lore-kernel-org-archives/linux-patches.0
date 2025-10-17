Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DF53370F7;
	Fri, 17 Oct 2025 15:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714658; cv=none; b=r9XD5P0vnmNf+tmNJTJSi7FrgrT0GoyjU2KnlmVFpYO1+YtqQtOB1xAk2DPq5fDp3ZlLcjJ00DkfWTYLUdwwI5oL6Vo9wgPsshQcEeUVym8AKd+MKTsLIDrvmiDQS9NUD5rh/aF26QdX5M8a8U8ZL6JletJVGUa9SFAT5D3MpSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714658; c=relaxed/simple;
	bh=vwpDbTYrijwp6m5Ue7XT0w0UVM8s3eNPo3j9w/x0exw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGWeYSqC1XnAB41C1BFlVrIxONtC55k5XzR5PwzAWObIqHZfUn6V/Waz33TaJ+38Kh4qMlg/6rypbtlq0WSgBAmVdhsO3EBZIycoRh5rARe70nhCinXluQnHZvudREzgoLse1S4ENnr7WvUuRLzIQx/ur66opBjfCEiu9ZAoCOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peeWxfcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peeWxfcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFD7C4CEFE;
	Fri, 17 Oct 2025 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714657;
	bh=vwpDbTYrijwp6m5Ue7XT0w0UVM8s3eNPo3j9w/x0exw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peeWxfcOgTzLJemaQcTu3JT1vgY1oQnh+W3jUstJy5Gu0aoBbL+f7Y8i9zm2NRPJJ
	 JL74LHtqUY3KXdcvMWWFig5L++7ibTc1jUPTmukpMBIFHJdz3kcoV1OwUqBGzvzvq2
	 EriYzVNgPAFidoILj81TMmCe6OvoevRRtTO4c8Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 6.12 222/277] lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older
Date: Fri, 17 Oct 2025 16:53:49 +0200
Message-ID: <20251017145155.233091203@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 2f13daee2a72bb962f5fd356c3a263a6f16da965 upstream.

After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
allmodconfig builds with clang-17 and older show an instance of
-Wframe-larger-than (which breaks the build with CONFIG_WERROR=y):

  lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (2336) exceeds limit (2048) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
    757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
        |      ^

When KASAN is disabled, the stack usage is roughly quartered:

  lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (608) exceeds limit (128) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
    757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
        |      ^

Using '-Rpass-analysis=stack-frame-layout' shows the following variables
and many, many 8-byte spills when KASAN is enabled:

  Offset: [SP-144], Type: Variable, Align: 8, Size: 40
  Offset: [SP-464], Type: Variable, Align: 8, Size: 320
  Offset: [SP-784], Type: Variable, Align: 8, Size: 320
  Offset: [SP-864], Type: Variable, Align: 32, Size: 80
  Offset: [SP-896], Type: Variable, Align: 32, Size: 32
  Offset: [SP-1016], Type: Variable, Align: 8, Size: 120

When KASAN is disabled, there are still spills but not at many and the
variables list is smaller:

  Offset: [SP-192], Type: Variable, Align: 32, Size: 80
  Offset: [SP-224], Type: Variable, Align: 32, Size: 32
  Offset: [SP-344], Type: Variable, Align: 8, Size: 120

Disable KASAN for this file when using clang-17 or older to avoid
blowing out the stack, clearing up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: "Jason A. Donenfeld" <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -33,6 +33,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENER
 libcurve25519-generic-y				:= curve25519-fiat32.o
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
+# clang versions prior to 18 may blow out the stack with KASAN
+ifeq ($(call clang-min-version, 180000),)
+KASAN_SANITIZE_curve25519-hacl64.o := n
+endif
 
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519)		+= libcurve25519.o
 libcurve25519-y					+= curve25519.o


