Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7412431E858;
	Sat, 30 May 2026 18:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164424; cv=none; b=rI1MSKl81Mxi01q7hEG+rI8sWXBv1gLT3o8vDXtwROD90WDSCug7ntqY2s7ZZojUSUpOHqUYek3+yRb/yBNmm8mJ6PbOXqm4aj4l4Et8A3DeNxJZD+GbCjW8HlteV6WMxQGyxt2LMpPuropeQ2VIYciNEoVQCN8PNz9NqN8vZDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164424; c=relaxed/simple;
	bh=Bv6c2vgUarvy/pLTAU232A6rQAHe5JoMPW1oo072Pbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2DwBBL7XHmd0A6fGmn3wjvpuaRPWVV0rkg+4bdnmlHv+QfRwWKaVEags/JGWrqy4QKqVoINFCY3eTh50CRbMU/18SVjrdKU/gYYAlnX65ZgRKi32Y7O0NyPbwQe2EcbvRVA6Relgbiymy7tNubu9EenqNK1CqW2pjdvyg4X2kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRsHiGMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRsHiGMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96E31F00893;
	Sat, 30 May 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164423;
	bh=jSmN3tjfMDF2EDjYlkicPmpeS6b/kIPebFWz1TZPGuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRsHiGMUzoYA950/OR1fRvahbDFdn3qV2N1vne3Wp1g9N4gKAfb971U7Rg9ToXhQD
	 UDFjAk/u0j0dhYyfiERsuayh1HtXEAAKvG+DMbMDv2rbGEemPxKzNfC7wTUbyuZ2cv
	 C9oY9ZfiCm/sJpEHKLjzrFilyjGIgqtGSvitz/u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/776] lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Sat, 30 May 2026 18:04:24 +0200
Message-ID: <20260530160254.374101794@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c4fb84822111d..ff5062bf9b33d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -741,7 +741,8 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -749,7 +750,7 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
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



