Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7E93EFFA0;
	Fri, 15 May 2026 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861642; cv=none; b=nsVKcAWiBjUe2kAz163PipF4fBoiX69CRW1LCgQdd6qlhMjABk/r2arxF1Sdv90lZKPzF5Ur77Cbi5Fh9Q9ebOp85EsNixxBou9ATZps4cKpW5reRWu4/IQXXgRNcSofs+qNot76aQIO/ondmWMUyl6Xo4HPHK4agi+QsvaObbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861642; c=relaxed/simple;
	bh=/m0BUMJiVHeL3UoTlnoguMbxULDWdxHNFuRCfihuKOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UI+g+TSYUzt2x5reQaYUrxFIgoEBXn5sxmRTfWVThBHrI9xrVbbN2NvonXlX/IQVLmtQ+fqfPRQ0P1+XBtMLvFxyXr8TItqJ/nN4fqm37hGU3DAWrkgJ1tuEcde8ZnstM9bI2NSfdzoPfCwUP/Lbbsyi4qylHcSuvjd8EOOlIbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2uuSkCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2uuSkCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128CEC2BCB0;
	Fri, 15 May 2026 16:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861642;
	bh=/m0BUMJiVHeL3UoTlnoguMbxULDWdxHNFuRCfihuKOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2uuSkCxSNuWe1SWSMH1PfVno/S7vksh2tu3eOjnU/kFp6mcLE56+MYM6Zr69PeXr
	 arIwaLlZYzQ2FdJO8r3gydnYxWCLF6TqM9s9uIVA4Z2W3HEPxQ/SO11s1gXVQ/7q3l
	 daPsR6gldHgFXYhkqnYBE0XEACfmS7FCF+gAn/lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 407/474] printk: add print_hex_dump_devel()
Date: Fri, 15 May 2026 17:48:36 +0200
Message-ID: <20260515154723.858757665@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -745,6 +745,19 @@ static inline void print_hex_dump_debug(
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


