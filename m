Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839B3348C55;
	Wed, 20 May 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301089; cv=none; b=DO2KfxnHvhyLWRabojE0xp8iGGP0d2zJgT6jIPUiA+q0FgsFGwGMpnj2IW882dq5cmgns21D12PBdXHGPMczZmrtsg7Rk9uwFjkC7W9gpsRz9l/mmMXmfmrOUKrrHEm+xRLb75RHBAaZe/z8ZWxyo/R9RxhpUtueT1o/EXRU3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301089; c=relaxed/simple;
	bh=vNgEFxbOKC83OQ1SPWrdW7hHfB4+fGDi8rRlpWcM7F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Al1Vcd53NHCyYTAV9klzRH8RbIoAhFxpsSTZnMIDOE6SvOu2Um+Zk10GwDmc4kd7Oeo3R1Dy7Z7LdXMd77Xxy89cWQA01nk6mOZj4z3cJhmdXnM92iPMXkZzegAuXyWnBOlvzx/OoZMMjD8s4vyj/K6fsdH9ZqFWFFXkW8fG7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x3lmPAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x3lmPAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C361F000E9;
	Wed, 20 May 2026 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301088;
	bh=JcSIuUrMMbb2hF84y9dNBJMDRcCk8K6JcmsJt8oGWj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1x3lmPATKN7fywKLgjxNf9Q21UJNPeMZNLhRW3m4tlmDibev2oy0RwCwU+FHXGHs9
	 sbjjamA0lPw1VB3CnFi0FRmjSs4KfeNPkwJIzf/8unx3LnuQJhizwdIAS50n2a3dXi
	 CmxAwCUVuEtBDKdoU9AeeRtK1BB9AvE+OP4X527Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/666] lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Wed, 20 May 2026 18:20:32 +0200
Message-ID: <20260520162120.393486818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 36776b7f8a8955b4e75b5d490a75fee0c7a2a7ef ]

print_hex_dump_bytes() claims to be a simple wrapper around
print_hex_dump(), but it actally calls print_hex_dump_debug(), which
means no output is printed if (dynamic) DEBUG is disabled.

Update the documentation to match the implementation.

Fixes: 091cb0994edd20d6 ("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/3d5c3069fd9102ecaf81d044b750cd613eb72a08.1774970392.git.geert+renesas@glider.be
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index f9498e9cb8ba4..a6c6fd107805b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -800,7 +800,8 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -808,7 +809,7 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  *
- * Calls print_hex_dump(), with log level of KERN_DEBUG,
+ * Calls print_hex_dump_debug(), with log level of KERN_DEBUG,
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
-- 
2.53.0



