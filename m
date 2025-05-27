Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4554226F469;
	Tue, 27 May 2025 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366238; cv=none; b=WLa+vmLfMQZ8zlXLaMz7sdEVhi4vmQ3uVQ4rBqtYV7RBNi3/eP17pgJ+dhtt7z+AmguRa+74Bi3zpLui7O4UIhBhKlJUsGro9PhjH4B6F4XzQOtbubllwg3tC31NnADgxd+6YoadlSryeZqK/Q0dM0qsMLjbALFHAHam6pFbZ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366238; c=relaxed/simple;
	bh=VKfQnCZBB4WUjDZJlvudb+mIvDr8W7ep4lRO+HsuwjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdPyYCv/9Q02/XD6R+z69RNzUsYMKtdbWHTg7CNhUVz0Rqfv1p4v864Oi3YyyI2c9oK46yRplCUibFPJ2QJbtn3JWTIAparZrzGVk5y+x96QfE8oJzr7DxCjwlKrXfXSvROq8zojWwu9bHCN2ERMfT6TVDF4xFQTSZe4A0lzZpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hcnu4QOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hcnu4QOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23C6C4CEE9;
	Tue, 27 May 2025 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366238;
	bh=VKfQnCZBB4WUjDZJlvudb+mIvDr8W7ep4lRO+HsuwjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hcnu4QOtsl4XFGZjDLVm6zX22aDcbVz0sweB4wqbK45QurQEl43IXRgmAjKLKO7gR
	 WbP+FqIlCTJu4OEuX2mY91JBbd+ijYo3nAkNLXty79WO5oS+0rAdX2mGAhDlvylzUF
	 a4tLzBJZZRerpePvsm9NZFRtV3xdiGIBRIQ77aV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Clayton <chris2553@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.12 615/626] gcc-15: disable -Wunterminated-string-initialization entirely for now
Date: Tue, 27 May 2025 18:28:28 +0200
Message-ID: <20250527162509.985363871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

commit 9d7a0577c9db35c4cc52db90bc415ea248446472 upstream.

From: Linus Torvalds <torvalds@linux-foundation.org>

I had left the warning around but as a non-fatal error to get my gcc-15
builds going, but fixed up some of the most annoying warning cases so
that it wouldn't be *too* verbose.

Because I like the _concept_ of the warning, even if I detested the
implementation to shut it up.

It turns out the implementation to shut it up is even more broken than I
thought, and my "shut up most of the warnings" patch just caused fatal
errors on gcc-14 instead.

I had tested with clang, but when I upgrade my development environment,
I try to do it on all machines because I hate having different systems
to maintain, and hadn't realized that gcc-14 now had issues.

The ACPI case is literally why I wanted to have a *type* that doesn't
trigger the warning (see commit d5d45a7f2619: "gcc-15: make
'unterminated string initialization' just a warning"), instead of
marking individual places as "__nonstring".

But gcc-14 doesn't like that __nonstring location that shut gcc-15 up,
because it's on an array of char arrays, not on one single array:

  drivers/acpi/tables.c:399:1: error: 'nonstring' attribute ignored on objects of type 'const char[][4]' [-Werror=attributes]
    399 | static const char table_sigs[][ACPI_NAMESEG_SIZE] __initconst __nonstring = {
        | ^~~~~~

and my attempts to nest it properly with a type had failed, because of
how gcc doesn't like marking the types as having attributes, only
symbols.

There may be some trick to it, but I was already annoyed by the bad
attribute design, now I'm just entirely fed up with it.

I wish gcc had a proper way to say "this type is a *byte* array, not a
string".

The obvious thing would be to distinguish between "char []" and an
explicitly signed "unsigned char []" (as opposed to an implicitly
unsigned char, which is typically an architecture-specific default, but
for the kernel is universal thanks to '-funsigned-char').

But any "we can typedef a 8-bit type to not become a string just because
it's an array" model would be fine.

But "__attribute__((nonstring))" is sadly not that sane model.

Reported-by: Chris Clayton <chris2553@googlemail.com>
Fixes: 4b4bd8c50f48 ("gcc-15: acpi: sprinkle random '__nonstring' crumbles around")
Fixes: d5d45a7f2619 ("gcc-15: make 'unterminated string initialization' just a warning")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[nathan: drivers/acpi diff dropped due to lack of 4b4bd8c50f48 in stable]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1001,8 +1001,8 @@ KBUILD_CFLAGS += $(call cc-option, -fstr
 KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-option, -Wno-stringop-overflow)
 KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
 
-#Currently, disable -Wunterminated-string-initialization as an error
-KBUILD_CFLAGS += $(call cc-option, -Wno-error=unterminated-string-initialization)
+#Currently, disable -Wunterminated-string-initialization as broken
+KBUILD_CFLAGS += $(call cc-option, -Wno-unterminated-string-initialization)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow


