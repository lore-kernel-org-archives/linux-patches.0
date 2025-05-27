Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F421528750C;
	Tue, 27 May 2025 17:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368698; cv=none; b=udoYQvvbf9N4IT11bCCGc6d8rZZF+lZjJpPKiN+7Vkyrr5n1sI4W0hkNNvfSEhZLHwxc1Nxi37u8K+FCcNebrlD7ZPWJQ+zY1/4yKdWAbxUgJHwsTbgd+Kl3lMU90ijc/4dghFnaRr1Knz3lVAuR/bkfHQg9GkAd8N1Zp7ZpO5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368698; c=relaxed/simple;
	bh=go3huMssDw4tOVOGVPyyfDlOz5RSxlJTyVb5wu+n/1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOwiySuijAeSvp3EPvAiVo9KR4xNRFHrrWUd85wEwXMDRrOnjkJoQ4/7klT4orHbkCbgYOCReO03CAZc/v1feN14MdpbOvQP8B/v0G4wIlIcN+DHCQg0kmeW5kHju91wfUUvj/WPd0HYoWchv5MdiqWuuT9b1/fF2U/0VVeuswk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3dIBGMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3dIBGMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0792BC4CEE9;
	Tue, 27 May 2025 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368697;
	bh=go3huMssDw4tOVOGVPyyfDlOz5RSxlJTyVb5wu+n/1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3dIBGMIqvU/TuLKaV6cEE0012EX/lS+OHo9gAf7OCXYkc3zbEBHnfZyPW11Z2XMm
	 eLzCQXZ6tLO0BZ7ctE2dDEW0PQZcu2j9xvXfDRneY9bjMfMXIKgztybyxq+hER8I9O
	 umPzhpRWsQffXGMVNZ2rM90hFbQMEo0sK5GO08os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.14 780/783] gcc-15: make unterminated string initialization just a warning
Date: Tue, 27 May 2025 18:29:37 +0200
Message-ID: <20250527162544.896156341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1053,6 +1053,9 @@ KBUILD_CFLAGS += $(call cc-option, -fstr
 KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERFLOW) += $(call cc-option, -Wno-stringop-overflow)
 KBUILD_CFLAGS-$(CONFIG_CC_STRINGOP_OVERFLOW) += $(call cc-option, -Wstringop-overflow)
 
+#Currently, disable -Wunterminated-string-initialization as an error
+KBUILD_CFLAGS += $(call cc-option, -Wno-error=unterminated-string-initialization)
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 


