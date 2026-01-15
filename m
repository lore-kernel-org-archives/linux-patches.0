Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62713A7F5D;
	Thu, 15 Jan 2026 17:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497724; cv=none; b=ktX7Y4KSQUaV/x8sVD53dbyLMbhVmTD+72BaHr6lPXGXpx4z+/XzSPos19PxK8zBM/2XVSKh3kDywBtbDKEYhVVkkhDOmVccxskXl8m41rwL/uE1HkKaXIwrEbKJ1GmMfg/RKfrO+xjshSEOG3NdB/GUKDf/Ok13aoeNnYXx1qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497724; c=relaxed/simple;
	bh=+jPPXM2kxIM38HZwMu7LCI1BFtCYhk8flwim74U4RqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l6jCfyuXHsmeEdztHGsMxHYea5yuCNuShrQXqhjPH78lgKcl87j82YyE8WCj3+g5cgyJGetuKRAYg8mh7bzQS43YuLu1QQIlsaU9+IvqXhDiG0AN4Lgafo05r1gHUUZURf8CmrC8iq+eVv+Ol1wF5nHguMvPreGac7o42bPgDig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsAXR6q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsAXR6q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63209C16AAE;
	Thu, 15 Jan 2026 17:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497724;
	bh=+jPPXM2kxIM38HZwMu7LCI1BFtCYhk8flwim74U4RqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsAXR6q7/DxTnIr00mfxU+saEvRfkDCxvv8p9i6FSiJhSLs9aE08l6j46ZT2IARL6
	 51YnuQDQHJ8LHl2TveltREV4RlcjtZq3lxoN25eD00MdEO3wzwHXSlOdZXwZy2/iAY
	 ddQLWhhY6dP9p5SaoTTYkAaedS5V+T+gimXPxrlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/554] fs/nls: Fix inconsistency between utf8_to_utf32() and utf32_to_utf8()
Date: Thu, 15 Jan 2026 17:44:08 +0100
Message-ID: <20260115164252.851866942@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c36f9d7b2869a003a2f7d6ff2c6bac9e62fd7d68 ]

After commit 25524b619029 ("fs/nls: Fix utf16 to utf8 conversion"),
the return values of utf8_to_utf32() and utf32_to_utf8() are
inconsistent when encountering an error: utf8_to_utf32() returns -1,
while utf32_to_utf8() returns errno codes. Fix this inconsistency
by modifying utf8_to_utf32() to return errno codes as well.

Fixes: 25524b619029 ("fs/nls: Fix utf16 to utf8 conversion")
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251129111535.8984-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nls/nls_base.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 7eacded3c17d1..f072eb6b563f6 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -67,19 +67,22 @@ int utf8_to_utf32(const u8 *s, int inlen, unicode_t *pu)
 			l &= t->lmask;
 			if (l < t->lval || l > UNICODE_MAX ||
 					(l & SURROGATE_MASK) == SURROGATE_PAIR)
-				return -1;
+				return -EILSEQ;
+
 			*pu = (unicode_t) l;
 			return nc;
 		}
 		if (inlen <= nc)
-			return -1;
+			return -EOVERFLOW;
+
 		s++;
 		c = (*s ^ 0x80) & 0xFF;
 		if (c & 0xC0)
-			return -1;
+			return -EILSEQ;
+
 		l = (l << 6) | c;
 	}
-	return -1;
+	return -EILSEQ;
 }
 EXPORT_SYMBOL(utf8_to_utf32);
 
-- 
2.51.0



