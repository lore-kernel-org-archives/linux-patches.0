Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CB43FBEDA;
	Wed, 20 May 2026 18:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302505; cv=none; b=qgW3GkFE/j+6PHjcc1chPRutr65yCDlTJ1lmL4lXF3ig/q5oWIMDSAGe1nVXs0R2s0EDCwd+REb0zNs2ecvLFo/371Sgj5L98PIGILFAcZ47UJZ0h1xpk0tR3HDeGb8/w3CmbuJ4afvhPV5XmyxIcJ1UAr4qGBfqicPNoZ6Bnmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302505; c=relaxed/simple;
	bh=y3o307rfLXcG5+hgAN5J1vqVjNnfa4KxSWsSTFw4ocI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4wp66j+fHncuygY/41ku011Sy0ITXz4TQopLxex8X7dZSynSta/uV2hotxD4JdCzXCMlASJo8Rb8piEzvdHRhUHJ4P5UQwsi/G3WVLX2Xt/1mcY7EHh41rHvqSg+JsEFnEAomO+Z1g3pNiXf2d0xkK0oJIbnLBVL5Xr5JXB9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNILd6Av; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNILd6Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D091F00893;
	Wed, 20 May 2026 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302503;
	bh=s9NDQcie+exyOU1+8+RgAOSOjQ5Q2eEj9ZDT4Rd8PqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNILd6AvWdctXm3O9/4qEmEkIh/N7gEybbe9WPQ/fjOci+eMSkKlncPFMIiTh2KZ6
	 lFLXkkCpvS5DdxjKK9dMVXul1jqolJjGPZOI+UP8ZyLhJunPDo758eq375z6DhysOM
	 l+otJo+++KvNR+GQoaaZhpJlEg3xCwGge09ZTIRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/508] lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Wed, 20 May 2026 18:21:54 +0200
Message-ID: <20260520162104.950611701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 478203bb2369c..794476418ccef 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -759,7 +759,8 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -767,7 +768,7 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
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



