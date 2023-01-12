Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F14D746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD38C433EF;
	Thu, 12 Jan 2023 13:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531823;
	bh=PjPAaAFiqvBB7Xv7doTYQ0HK1EOaXydqqAJiLTRoYrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCORxo85GC7jlxf5h/K9Ngebs0X6Ovv1wCs1fMsLIuShsjmijPLbOG8nj+8EO7gZ0
	 TEgmGC77V2B1DKi8OaicFBNcrAn3TIRv2iDKH3oqcq/ySq0hkB5N4ndwtqafD9erpx
	 Z7HPwJ4KLBuUVl/JVY4Q1yimQapTyajqketxII48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 09/10] gcc: disable -Warray-bounds for gcc-11 too
Date: Thu, 12 Jan 2023 14:56:30 +0100
Message-Id: <20230112135327.373332907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
References: <20230112135326.981869724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5a41237ad1d4b62008f93163af1d9b1da90729d8 upstream.

We had already disabled this warning for gcc-12 due to bugs in the value
range analysis, but it turns out we end up having some similar problems
with gcc-11.3 too, so let's disable it there too.

Older gcc versions end up being increasingly less relevant, and
hopefully clang and newer version of gcc (ie gcc-13) end up working
reliably enough that we still get the build coverage even when we
disable this for some versions.

Link: https://lore.kernel.org/all/20221227002941.GA2691687@roeck-us.net/
Link: https://lore.kernel.org/all/D8BDBF66-E44C-45D4-9758-BAAA4F0C1998@kernel.org/
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -892,13 +892,17 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-12 array-bounds globally.
+# Currently, disable gcc-11,12 array-bounds globally.
 # We may want to target only particular configurations some day.
+config GCC11_NO_ARRAY_BOUNDS
+	def_bool y
+
 config GCC12_NO_ARRAY_BOUNDS
 	def_bool y
 
 config CC_NO_ARRAY_BOUNDS
 	bool
+	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
 	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
 
 #


