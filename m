Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B9033B6E8;
	Fri,  9 Jan 2026 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961933; cv=none; b=K+5B1mgzLIpsh3BItZKmysBPpcJ/magFFlOuYt3FogEPztLtHMhe6Zf/9PBY3s2oJMzwfkXCwran5tn8t+2HFihQD9tyTX0gKp0rYthzYkO3c73SCmlzPFzZmRcBB1wgIcx0/wRK+CNpO1Z6e0h6bkLyTlmq3c2h8NjxOfvOnlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961933; c=relaxed/simple;
	bh=dzWQaHpDyqw9dfVZUdxWLUObdsF0dK7uYwrIyUOhat0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2d3RoV0hqsipymkK/DwUTWwjG5zLtQuPKQn0QrirkVxlb/ToNWMZAt4tuI4bz3qsglYzJS8uQPZtnCu/K9kfepVURblo0jWq65kHh4GkITMOdL3tenwUaqI24jpzuhn5nZmBGQPm0vpeJeZPJp/sRHaOS3VQQPXNEYnjZX+x5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JohJDYbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JohJDYbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C676DC4CEF1;
	Fri,  9 Jan 2026 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961933;
	bh=dzWQaHpDyqw9dfVZUdxWLUObdsF0dK7uYwrIyUOhat0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JohJDYbgKkckFiYfn7z4GFDBTd6NybX62kzyU9FBcjFCMR7dnLPa/rJyyRBEbkYqc
	 /YaIY+PkxGndVik5Yh+QFmueLZVEH39QLxZMHO2OgMW8GiphssPUPau2JlfM2wL6Aj
	 wtTXZb362cCFk0TiYtZ3cNG0fPu2hCBPE9dzWc8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/634] fs/nls: Fix utf16 to utf8 conversion
Date: Fri,  9 Jan 2026 12:37:46 +0100
Message-ID: <20260109112124.513668831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 25524b6190295577e4918c689644451365e6466d ]

Currently the function responsible for converting between utf16 and
utf8 strings will ignore any characters that cannot be converted. This
however also includes multi-byte characters that do not fit into the
provided string buffer.

This can cause problems if such a multi-byte character is followed by
a single-byte character. In such a case the multi-byte character might
be ignored when the provided string buffer is too small, but the
single-byte character might fit and is thus still copied into the
resulting string.

Fix this by stop filling the provided string buffer once a character
does not fit. In order to be able to do this extend utf32_to_utf8()
to return useful errno codes instead of -1.

Fixes: 74675a58507e ("NLS: update handling of Unicode")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251111131125.3379-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nls/nls_base.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index a026dbd3593f6..7eacded3c17d1 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -94,7 +94,7 @@ int utf32_to_utf8(unicode_t u, u8 *s, int maxout)
 
 	l = u;
 	if (l > UNICODE_MAX || (l & SURROGATE_MASK) == SURROGATE_PAIR)
-		return -1;
+		return -EILSEQ;
 
 	nc = 0;
 	for (t = utf8_table; t->cmask && maxout; t++, maxout--) {
@@ -110,7 +110,7 @@ int utf32_to_utf8(unicode_t u, u8 *s, int maxout)
 			return nc;
 		}
 	}
-	return -1;
+	return -EOVERFLOW;
 }
 EXPORT_SYMBOL(utf32_to_utf8);
 
@@ -217,8 +217,16 @@ int utf16s_to_utf8s(const wchar_t *pwcs, int inlen, enum utf16_endian endian,
 				inlen--;
 			}
 			size = utf32_to_utf8(u, op, maxout);
-			if (size == -1) {
-				/* Ignore character and move on */
+			if (size < 0) {
+				if (size == -EILSEQ) {
+					/* Ignore character and move on */
+					continue;
+				}
+				/*
+				 * Stop filling the buffer with data once a character
+				 * does not fit anymore.
+				 */
+				break;
 			} else {
 				op += size;
 				maxout -= size;
-- 
2.51.0



