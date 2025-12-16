Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540834F492;
	Tue, 16 Dec 2025 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886454; cv=none; b=JSLsPzQ0Yd8NiXVmPjRrtT7ZMkWrGP0mnnoACg3XLMTKADiXygrQN14/x6+0Tzujl6lxToXcOxLEQC7m7dH2Podz5OPJjNTzNX7+2rllQZqEziwO+Hfs2tw9zG87O3KoBC5csvRytZjs6e1MPFSKBHVQ8y3YXKLgC/PLliXROMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886454; c=relaxed/simple;
	bh=8IxCQz8zQ8CnTV8YnP2rhdODZua9GNPnah0ycVLe/IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdgCa0xA1JVtpymCJ8bJlXo7lmWWvxQGGSYU20z1QuVCv1agBMI5Stl3+IFfxV+PWmfIEqz/GI1Bd7uxvTc6dtZmiviXYYtwEDHWHeL+i2pC+ScwK85JvvFSDq25rl/xdAYzCqOKBQPgJOudZz6K7ssQScymTEVwqWCqurn4H14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xh7mYSpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xh7mYSpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354CEC4CEF1;
	Tue, 16 Dec 2025 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886454;
	bh=8IxCQz8zQ8CnTV8YnP2rhdODZua9GNPnah0ycVLe/IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh7mYSpeUZUSz48mhiC4VkOuKKbK2R+KxsFOyKXfwpBn19+i91mZI2yXNBlB659Z3
	 kkokcMwtrg4sVAm4N2/++PDjln0DPLDMUcaxi9qtVuXMxElibHLZAxO/CRmNlPbUsI
	 hqbm9+WRSgUxbvU/PYlBIOGOoLBKYPpSZ86XqHFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 441/507] fs/nls: Fix utf16 to utf8 conversion
Date: Tue, 16 Dec 2025 12:14:42 +0100
Message-ID: <20251216111401.434084810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 18d597e49a194..d434c4463a8f7 100644
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



