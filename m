Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849303955E1;
	Tue, 12 May 2026 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608224; cv=none; b=e/AKhFiL6Xo2jVZxDMEXsJVt4SwiNqTwbKfI80XSIjnOG3Tdjc5jL878nz1qXQkXoMkstgyUrymDSG58zDm3/SNtON3gjIkiaE0f5QlGVTr1BGnBZQKD9F3XuUjPG5u/lryfaqXC73D1DTETX4Ff2aixAp5PzJKJzTdJ4A+78x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608224; c=relaxed/simple;
	bh=x+evND+hXLIq/hm+fVoZraLTLkBS8pLrTEDSNG5dhrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvpcNnFD+Q+tdb2O3KlB7TX9qV/qwStFOfPRx19bBn+MFdnb1WLT6FyQ0hiAxWT0NYDOqJNHozSPtOGZ/2pUSbV/nlvr87DTDC0X9iqIDTj1czY0rW5e32mZrcobrOGwSi6rZTTo0SL1QiPxiq3A9GZYTgNjG8UBiqYBcV8v+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mh0EBIe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mh0EBIe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AD8C2BCB0;
	Tue, 12 May 2026 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608224;
	bh=x+evND+hXLIq/hm+fVoZraLTLkBS8pLrTEDSNG5dhrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mh0EBIe5MJ9rhKxLh6zaXN+DCvQEEMmIAue5B/iIwlfZUKESGfqzSw10FLIZfrgQ2
	 ZoyXsg0AaHOQQvN4ClQxJR4xBcFVxQtl9Gko5cJFhSgyGr3sQpnF5Yq91jpmeHHLYD
	 ho4CziSoxtn9+k4yogekqQ5EEXc2Lo807WNQKXMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/206] printk: add print_hex_dump_devel()
Date: Tue, 12 May 2026 19:40:48 +0200
Message-ID: <20260512173937.024533201@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d134feeb5df33fbf77f482f52a366a44642dba09 ]

Add print_hex_dump_devel() as the hex dump equivalent of pr_devel(),
which emits output only when DEBUG is enabled, but keeps call sites
compiled otherwise.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 177730a273b1 ("crypto: caam - guard HMAC key hex dumps in hash_digest_key")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/printk.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -786,6 +786,19 @@ static inline void print_hex_dump_debug(
 }
 #endif
 
+#if defined(DEBUG)
+#define print_hex_dump_devel(prefix_str, prefix_type, rowsize,		\
+			     groupsize, buf, len, ascii)		\
+	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
+		       groupsize, buf, len, ascii)
+#else
+static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
+					int rowsize, int groupsize,
+					const void *buf, size_t len, bool ascii)
+{
+}
+#endif
+
 /**
  * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
  * @prefix_str: string to prefix each line with;


