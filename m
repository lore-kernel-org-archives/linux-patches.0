Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353482D0602;
	Thu,  2 Jul 2026 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010872; cv=none; b=bWVqotgyOcVjeS25uIQKffd309GxTfQ1RrorIFffIRSqikytLRwtHigN+23+64cSNXtSLL6TXZoOyhHnak1Zaw3iEF+bg+w51EWCCRh2akUoZhD1s/2bTT6svteD0TPzTJb7DvE+JRKNkK2qrgYayJVATfMJbyCh+TDCreH1/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010872; c=relaxed/simple;
	bh=9b7qphFNT+/iAMmynmWwCSKUqvdixW4VaKI50TNzzN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBBJaw6J2IPH1G+1hQgVbtpXsZeCTMxDCTR8Gg349p2u3W6KbcpoqPQlKie9YGstdY05ZIXNzJmUywVOS7QP0D2gZ8bNfK+0mpnuMo1bwFWeZRjJtVh+48ghqbnowISfaerTrJ9i1+JWTepXOcjBvq+zbkU+k3Tmj7pNU9ePWB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AI6wJQgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AI6wJQgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DC61F000E9;
	Thu,  2 Jul 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010871;
	bh=6z8ZwZE/mHU/xo4WswiL4vy1Wh/KCeBeL6P/5Gv2fGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AI6wJQgbaafYvweEknR0I0QqXBQUTKaPAheaJjlONgYgYfe1P+HjCQeWPYlsmRBOv
	 lR9hqMuWfwikwPulk7U8UFJAqroyIx+wbcPqHMqW1R14SGktdOcsBdvO7IE/iXpvXQ
	 RfupdJVIPMN9ByRFGX85pWq1IwJjn95GOyAVpli4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.6 069/175] scripts/sorttable: Allow matches to functions before function entry
Date: Thu,  2 Jul 2026 18:19:30 +0200
Message-ID: <20260702155117.245339903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit dc208c69c033d3caba0509da1ae065d2b5ff165f ]

ARM 64 uses -fpatchable-function-entry=4,2 which adds padding before the
function and the addresses in the mcount_loc point there instead of the
function entry that is returned by nm. In order to find a function from nm
to make sure it's not an unused weak function, the entries in the
mcount_loc section needs to match the entries from nm. Since it can be an
instruction before the entry, add a before_func variable that ARM 64 can
set to 8, and if the mcount_loc entry is within 8 bytes of the nm function
entry, then it will be considered a match.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/20250225182054.815536219@goodmis.org
Fixes: ef378c3b82338 ("scripts/sorttable: Zero out weak functions in mcount_loc table")
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -611,13 +611,16 @@ static int add_field(uint64_t addr, uint
 	return 0;
 }
 
+/* Used for when mcount/fentry is before the function entry */
+static int before_func;
+
 /* Only return match if the address lies inside the function size */
 static int cmp_func_addr(const void *K, const void *A)
 {
 	uint64_t key = *(const uint64_t *)K;
 	const struct func_info *a = A;
 
-	if (key < a->addr)
+	if (key + before_func < a->addr)
 		return -1;
 	return key >= a->addr + a->size;
 }
@@ -1253,6 +1256,8 @@ static int do_file(char const *const fna
 #ifdef MCOUNT_SORT_ENABLED
 		sort_reloc = true;
 		rela_type = 0x403;
+		/* arm64 uses patchable function entry placing before function */
+		before_func = 8;
 #endif
 		/* fallthrough */
 	case EM_386:


