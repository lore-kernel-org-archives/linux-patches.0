Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE7B26F469;
	Tue, 27 May 2025 17:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366235; cv=none; b=N5J2dWXlQwDrByyQSxzYXvs7CLcpnM9stN9IRvP/PHMm+yxg9UhTPaa/CsdgH5McabO8DNqh+23NB4XeZNPfNxiqDWG529wPtC6vsdjocuMJi7wvH9gnNAV/wKkq9cXaYMC28YYSOfagm3p+niVCnJf4xaCHsXB2Jk07XUQO5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366235; c=relaxed/simple;
	bh=P0gNpGR6UwjWYVlKlhWn5yMcHI/qOG2TRimj+/h6eGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=roRh5nU9tZtQpPHViDmuaOvH2MsmB492kkPsvL9dJKgc7FJRwbzZEQ1FJaLFsy9zc3WtnxwbtC0pgWxeqsi0cfbMwYdTx7p8RZdxeVhsod+6yokTr6QpNswTs8pkk6uf5r5mXZF5++ggJfWCM5JjV6Py2U9VkFn6zs68KCHRGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlA3/0ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlA3/0ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FE6C4CEE9;
	Tue, 27 May 2025 17:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366235;
	bh=P0gNpGR6UwjWYVlKlhWn5yMcHI/qOG2TRimj+/h6eGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlA3/0eamaJVbiqL4QkkzgusCbdlW0BLkki+UNWCYCLVaIdoXW2HWBsOO0o8lCg5b
	 RGxlEicRXqBrejUOT1rXydoKgjefdk4MfQWjJbjoXzUqfLzbXs6O1uTRQDiELduStz
	 cWlrrUJoONy0x5p99+TT1gWGbwEoHvY9afrY/P00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.12 614/626] gcc-15: make unterminated string initialization just a warning
Date: Tue, 27 May 2025 18:28:27 +0200
Message-ID: <20250527162509.945880114@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d5d45a7f26194460964eb5677a9226697f7b7fdd upstream.

gcc-15 enabling -Wunterminated-string-initialization in -Wextra by
default was done with the best intentions, but the warning is still
quite broken.

What annoys me about the warning is that this is a very traditional AND
CORRECT way to initialize fixed byte arrays in C:

	unsigned char hex[16] = "0123456789abcdef";

and we use this all over the kernel.  And the warning is fine, but gcc
developers apparently never made a reasonable way to disable it.  As is
(sadly) tradition with these things.

Yes, there's "__attribute__((nonstring))", and we have a macro to make
that absolutely disgusting syntax more palatable (ie the kernel syntax
for that monstrosity is just "__nonstring").

But that attribute is misdesigned.  What you'd typically want to do is
tell the compiler that you are using a type that isn't a string but a
byte array, but that doesn't work at all:

	warning: ‘nonstring’ attribute does not apply to types [-Wattributes]

and because of this fundamental mis-design, you then have to mark each
instance of that pattern.

This is particularly noticeable in our ACPI code, because ACPI has this
notion of a 4-byte "type name" that gets used all over, and is exactly
this kind of byte array.

This is a sad oversight, because the warning is useful, but really would
be so much better if gcc had also given a sane way to indicate that we
really just want a byte array type at a type level, not the broken "each
and every array definition" level.

So now instead of creating a nice "ACPI name" type using something like

	typedef char acpi_name_t[4] __nonstring;

we have to do things like

	char name[ACPI_NAMESEG_SIZE] __nonstring;

in every place that uses this concept and then happens to have the
typical initializers.

This is annoying me mainly because I think the warning _is_ a good
warning, which is why I'm not just turning it off in disgust.  But it is
hampered by this bad implementation detail.

[ And obviously I'm doing this now because system upgrades for me are
  something that happen in the middle of the release cycle: don't do it
  before or during travel, or just before or during the busy merge
  window period. ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -1001,6 +1001,9 @@ KBUILD_CFLAGS += $(call cc-option, -fstr
 KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-option, -Wno-stringop-overflow)
 KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
 
+#Currently, disable -Wunterminated-string-initialization as an error
+KBUILD_CFLAGS += $(call cc-option, -Wno-error=unterminated-string-initialization)
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 


