Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D182836D9EA;
	Wed, 20 May 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298891; cv=none; b=VxvYz7OFVKLlG0KiJYonasKePvJ3njOitED7vov95WdBcLXxn8Q8a6XVEcMXcy3vD+YlxG3ohhf2GzUkwXW+dsGvkowFrY4m1dJ9uSPTX55EMiYX2XEx/B8B23juW+YsT7IRUwvQEFkXioxlCl2PYtupHM/YCMbxM7N5bCHyBAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298891; c=relaxed/simple;
	bh=aiqKhYGGRF2s7c7c8ZF4cCQIEqOOuATY1TIQ7+NZL8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEwg7PoSJZZ91qwwVszLopDxY2R7ec1iNbWwW6wpdEUKZybDv5K6ElHIHaYfasVsJFzxKwGbVd5VYfAiBK+5OHX/0dzT67X3+qILtNrku/sUjBLkYVWdjirH0NJgYcZU7L0pqE93Y1Bfq4/8bGywwnbZMKZg0idzKqLeNMXMWAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4G19UG4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4G19UG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440B41F00894;
	Wed, 20 May 2026 17:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298890;
	bh=c9LuNknuKkc2zC0Y+1u/p0J63Rqc//iEVx7yIfzeIf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4G19UG4gVAlO0IXTNyp1P/K0iZ/JUoXN58oZB9qZjAOjqljsP0ypZKmvkcGPHMBC
	 ziZAziXo1He8RpDaa6HmXOm/DsmjtFaupWXHKZD69OqSp4Lzm9zGMYdR4UNKGcUrKY
	 4mQINqHUbyjZiDAAu7Nq6DKQZ7EyGminPLegK1tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 584/957] lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Wed, 20 May 2026 18:17:47 +0200
Message-ID: <20260520162147.195337263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 9a8eaed5f8778..a98d64b45bc93 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -816,7 +816,8 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -824,7 +825,7 @@ static inline void print_hex_dump_devel(const char *prefix_str, int prefix_type,
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



