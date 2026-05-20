Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807FC2BE02A;
	Wed, 20 May 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294573; cv=none; b=XQB9aF9U4JAXUnM8ANv0T0zsiJRTUNGcKJ1TPvy8iLEXiCcbMkq9IOKB/swlyKD3sKi9W96bE1NUlpBFJ891LCCzTqOfSQUF0q6IbBt/lXTek8EWkQltfCkp5rKfdQg6EoKJjo6SUfMSZghrsoh32KZHW6ZKM4OcxacVRT64ZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294573; c=relaxed/simple;
	bh=i21u/i0fwi5/9nnMT6CDQ5NJsGd0qKzMXNALslqAmAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKdVhwT/Rr8aQe+GUExWTSGUMv+8Ng2oaE79D6EZr0r0Y4GHlA61Mxitqi32zyFGe15kd35xXcl/2R+y80BG5e17EoIV6xQoDzbGpSdOWC7B4ZxgWon/HwrCLl9hrZ317VuE3hEOxzal6XppfQNnMe5QXw6lHJ24qfCx450ox4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+JlNSbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+JlNSbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878311F00893;
	Wed, 20 May 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294569;
	bh=emex5VnpZgKGo+MJY1T25DnOCWIaEP9bKMhk2FWRA2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+JlNSbNeEz2kzs0EuHsUl2PaHYP3gOUOHaSHraT7phzeF4dwk9sn7q/XL4a5l9Cl
	 OwabxvVju2Oj2lR3HAPhSDeqsaTtK9ocPQRLJ6gPGewoeYRvC4r9a0Q2qOXicDsxJj
	 RJ+mms+OJeaCNU3XLWyAOvmeDE3+a2aYO6kd9PxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0090/1146] tools/nolibc/printf: Move snprintf length check to callback
Date: Wed, 20 May 2026 18:05:40 +0200
Message-ID: <20260520162150.389500847@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 4045e7b19bbf7338452cda11e64cfe7ae3361964 ]

Move output truncation to the snprintf() callback.
This simplifies the main code and fixes truncation of padded fields.

Add a zero length callback to 'finalise' the buffer rather than
doing it in snprintf() itself.

Fixes: e90ce42e81381 ("tools/nolibc: implement width padding in printf()")
Signed-off-by: David Laight <david.laight.linux@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260302101815.3043-3-david.laight.linux@gmail.com
[Thomas: clean up Fixes trailer]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdio.h | 94 +++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 27 deletions(-)

diff --git a/tools/include/nolibc/stdio.h b/tools/include/nolibc/stdio.h
index 77d7669cdb806..a4df72d9a2d37 100644
--- a/tools/include/nolibc/stdio.h
+++ b/tools/include/nolibc/stdio.h
@@ -295,16 +295,25 @@ int fseek(FILE *stream, long offset, int whence)
  *  - %[l*]{d,u,c,x,p}
  *  - %s
  *  - unknown modifiers are ignored.
+ *
+ * Called by vfprintf() and snprintf() to do the actual formatting.
+ * The callers provide a callback function to save the formatted data.
+ * The callback function is called multiple times:
+ *  - for each group of literal characters in the format string.
+ *  - for field padding.
+ *  - for each conversion specifier.
+ *  - with (NULL, 0) at the end of the __nolibc_printf.
+ * If the callback returns non-zero __nolibc_printf() immediately returns -1.
  */
-typedef int (*__nolibc_printf_cb)(intptr_t state, const char *buf, size_t size);
+typedef int (*__nolibc_printf_cb)(void *state, const char *buf, size_t size);
 
-static __attribute__((unused, format(printf, 4, 0)))
-int __nolibc_printf(__nolibc_printf_cb cb, intptr_t state, size_t n, const char *fmt, va_list args)
+static __attribute__((unused, format(printf, 3, 0)))
+int __nolibc_printf(__nolibc_printf_cb cb, void *state, const char *fmt, va_list args)
 {
 	char escape, lpref, ch;
 	unsigned long long v;
 	unsigned int written, width;
-	size_t len, ofs, w;
+	size_t len, ofs;
 	char outbuf[21];
 	const char *outstr;
 
@@ -406,17 +415,13 @@ int __nolibc_printf(__nolibc_printf_cb cb, intptr_t state, size_t n, const char
 			outstr = fmt;
 			len = ofs - 1;
 		flush_str:
-			if (n) {
-				w = len < n ? len : n;
-				n -= w;
-				while (width-- > w) {
-					if (cb(state, " ", 1) != 0)
-						return -1;
-					written += 1;
-				}
-				if (cb(state, outstr, w) != 0)
+			while (width-- > len) {
+				if (cb(state, " ", 1) != 0)
 					return -1;
+				written += 1;
 			}
+			if (cb(state, outstr, len) != 0)
+				return -1;
 
 			written += len;
 		do_escape:
@@ -429,18 +434,25 @@ int __nolibc_printf(__nolibc_printf_cb cb, intptr_t state, size_t n, const char
 
 		/* literal char, just queue it */
 	}
+
+	/* Request a final '\0' be added to the snprintf() output.
+	 * This may be the only call of the cb() function.
+	 */
+	if (cb(state, NULL, 0) != 0)
+		return -1;
+
 	return written;
 }
 
-static int __nolibc_fprintf_cb(intptr_t state, const char *buf, size_t size)
+static int __nolibc_fprintf_cb(void *stream, const char *buf, size_t size)
 {
-	return _fwrite(buf, size, (FILE *)state);
+	return _fwrite(buf, size, stream);
 }
 
 static __attribute__((unused, format(printf, 2, 0)))
 int vfprintf(FILE *stream, const char *fmt, va_list args)
 {
-	return __nolibc_printf(__nolibc_fprintf_cb, (intptr_t)stream, SIZE_MAX, fmt, args);
+	return __nolibc_printf(__nolibc_fprintf_cb, stream, fmt, args);
 }
 
 static __attribute__((unused, format(printf, 1, 0)))
@@ -498,26 +510,54 @@ int dprintf(int fd, const char *fmt, ...)
 	return ret;
 }
 
-static int __nolibc_sprintf_cb(intptr_t _state, const char *buf, size_t size)
+struct __nolibc_sprintf_cb_state {
+	char *buf;
+	size_t space;
+};
+
+static int __nolibc_sprintf_cb(void *v_state, const char *buf, size_t size)
 {
-	char **state = (char **)_state;
+	struct __nolibc_sprintf_cb_state *state = v_state;
+	size_t space = state->space;
+	char *tgt;
+
+	/* Truncate the request to fit in the output buffer space.
+	 * The last byte is reserved for the terminating '\0'.
+	 * state->space can only be zero for snprintf(NULL, 0, fmt, args)
+	 * so this normally lets through calls with 'size == 0'.
+	 */
+	if (size >= space) {
+		if (space <= 1)
+			return 0;
+		size = space - 1;
+	}
+	tgt = state->buf;
+
+	/* __nolibc_printf() ends with cb(state, NULL, 0) to request the output
+	 * buffer be '\0' terminated.
+	 * That will be the only cb() call for, eg, snprintf(buf, sz, "").
+	 * Zero lengths can occur at other times (eg "%s" for an empty string).
+	 * Unconditionally write the '\0' byte to reduce code size, it is
+	 * normally overwritten by the data being output.
+	 * There is no point adding a '\0' after copied data - there is always
+	 * another call.
+	 */
+	*tgt = '\0';
+	if (size) {
+		state->space = space - size;
+		state->buf = tgt + size;
+		memcpy(tgt, buf, size);
+	}
 
-	memcpy(*state, buf, size);
-	*state += size;
 	return 0;
 }
 
 static __attribute__((unused, format(printf, 3, 0)))
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
-	char *state = buf;
-	int ret;
+	struct __nolibc_sprintf_cb_state state = { .buf = buf, .space = size };
 
-	ret = __nolibc_printf(__nolibc_sprintf_cb, (intptr_t)&state, size, fmt, args);
-	if (ret < 0)
-		return ret;
-	buf[(size_t)ret < size ? (size_t)ret : size - 1] = '\0';
-	return ret;
+	return __nolibc_printf(__nolibc_sprintf_cb, &state, fmt, args);
 }
 
 static __attribute__((unused, format(printf, 3, 4)))
-- 
2.53.0



