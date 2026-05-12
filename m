Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265843EDE57;
	Tue, 12 May 2026 18:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608915; cv=none; b=h9gDwXZj+gVdpJ5SLHWgji4Nwn1Nc9+BtMVH2gT+4Y17qN/o6SMnBZ157oAlBQvvLelt2g9+NEzZwjz3DZAsonkMylhg4/XG5c8chZW80T8pXs1u8FPiJiwe/64ABy/r6dHg6n/JaImrLaTWVDE9jZdFK6EyUTYZxzOL/Nsadrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608915; c=relaxed/simple;
	bh=R1r/gf/aJK4b5kaeF1vZI53U8KBYmpBphr+Jr501GtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VheC6QG5l4tm8YyeB1RzTdWfkM32oU+xOda9b1sWvwcRJgBdnh1LD5qAx1yrPFR2EZh+G9eX8CbOFadi14kYtx8JAhK0umT9FTQvEPCC0Jit6ahM/izSiR01AVnPLiViXNliWAxSsotkaTQq0XBDFDLJfCINI7Vnqxkxp0teNjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT256Hxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT256Hxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3745C2BCB0;
	Tue, 12 May 2026 18:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608915;
	bh=R1r/gf/aJK4b5kaeF1vZI53U8KBYmpBphr+Jr501GtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT256Hxgcn6Ww/67b4Y4ewTXB41F/a0iCN7b9tB+EBvw5yz0p0CA4VYFcjrZS3IGX
	 8rN/93Ih1HHSm7cLBMxtQB2nPrjN90Vk8rBBpqEE8n0MDXIr7220TvYjf6LhowAA6w
	 ixDo++FgOw/ZOFrPWC90+mQE4PMQ3sK5qeHB+KMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/270] printk: add print_hex_dump_devel()
Date: Tue, 12 May 2026 19:41:06 +0200
Message-ID: <20260512173944.029257522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -802,6 +802,19 @@ static inline void print_hex_dump_debug(
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


