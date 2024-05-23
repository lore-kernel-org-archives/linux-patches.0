Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7A1E497;
	Thu, 23 May 2024 13:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470105; cv=none; b=VyxBrTjWgJZvrnlukYQ2kdyiP4P9q8sh9eyW8U3o+pAIKXIZLr9YRrWieKBCaYPNQCaHU0jN+cai7/anK4x8K3y5Ve/L7AiCs6b/NgFT/8gtoVPf8mGm0SspPU+wRRyXpZGSzoaoGn+E3R6qwrJ7NbaWNZPyRat7cjZL+d6FKVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470105; c=relaxed/simple;
	bh=sn3yw1QWvcTAilyXa7sywtAaOauc6GRRDvLXsQVlbTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxEVY1auJf6MbbiJivcrbRlPS7B9/++JpGOpNGFL0/NfEuYVNNVVlfjiKPMT1Cs6hGqSDPE+R1GwARzp2svu45hJIFx4Cg9RomqI3nDTSBs3REDUDm4Bjb91yd0bAHagHQXBqKqBGKQlkpQfg95tvBHWfwMheVfvnJptlOJ9Cpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV9Loekg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV9Loekg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C97C2BD10;
	Thu, 23 May 2024 13:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470105;
	bh=sn3yw1QWvcTAilyXa7sywtAaOauc6GRRDvLXsQVlbTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV9LoekgV5Rc7L8ZJkV+N86v6/c/CKUSe+SGGzUnbFV8Mkl7Mq5yd8SHsmBTmnFIl
	 PU4gR3NZnlzku4gnuQlpeZWkpBOR8QfSr8BdzrEvpdGu3fDSEZ6MWvD/4KSAo2HW7n
	 YoB9xvKB8yNq6VjzmVq0CVEn2I4iEAfwJRFz+cvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	George Guo <guodongtai@kylinos.cn>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joe Perches <joe@perches.com>,
	Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 4.19 09/18] string.h: Add str_has_prefix() helper function
Date: Thu, 23 May 2024 15:12:32 +0200
Message-ID: <20240523130326.087206848@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 72921427d46bf9731a1ab7864adc64c43dfae29f upstream.

A discussion came up in the trace triggers thread about converting a
bunch of:

 strncmp(str, "const", sizeof("const") - 1)

use cases into a helper macro. It started with:

	strncmp(str, const, sizeof(const) - 1)

But then Joe Perches mentioned that if a const is not used, the
sizeof() will be the size of a pointer, which can be bad. And that
gcc will optimize strlen("const") into "sizeof("const") - 1".

Thinking about this more, a quick grep in the kernel tree found several
(thousands!) of cases that use this construct. A quick grep also
revealed that there's probably several bugs in that use case. Some are
that people forgot the "- 1" (which I found) and others could be that
the constant for the sizeof is different than the constant (although, I
haven't found any of those, but I also didn't look hard).

I figured the best thing to do is to create a helper macro and place it
into include/linux/string.h. And go around and fix all the open coded
versions of it later.

Note, gcc appears to optimize this when we make it into an always_inline
static function, which removes a lot of issues that a macro produces.

Link: http://lkml.kernel.org/r/e3e754f2bd18e56eaa8baf79bee619316ebf4cfc.1545161087.git.tom.zanussi@linux.intel.com
Link: http://lkml.kernel.org/r/20181219211615.2298e781@gandalf.local.home
Link: http://lkml.kernel.org/r/CAHk-=wg_sR-UEC1ggmkZpypOUYanL5CMX4R7ceuaV4QMf5jBtg@mail.gmail.com

Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Suggestions-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggestions-by: Joe Perches <joe@perches.com>
Suggestions-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/string.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -492,4 +492,24 @@ static inline void memcpy_and_pad(void *
 		memcpy(dest, src, dest_len);
 }
 
+/**
+ * str_has_prefix - Test if a string has a given prefix
+ * @str: The string to test
+ * @prefix: The string to see if @str starts with
+ *
+ * A common way to test a prefix of a string is to do:
+ *  strncmp(str, prefix, sizeof(prefix) - 1)
+ *
+ * But this can lead to bugs due to typos, or if prefix is a pointer
+ * and not a constant. Instead use str_has_prefix().
+ *
+ * Returns: 0 if @str does not start with @prefix
+         strlen(@prefix) if @str does start with @prefix
+ */
+static __always_inline size_t str_has_prefix(const char *str, const char *prefix)
+{
+	size_t len = strlen(prefix);
+	return strncmp(str, prefix, len) == 0 ? len : 0;
+}
+
 #endif /* _LINUX_STRING_H_ */


