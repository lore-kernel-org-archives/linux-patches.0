Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4876A318EC1;
	Thu,  2 Jul 2026 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010362; cv=none; b=EEWpaDsEQd9plStv8e/jw/y0jRTTq1HcBRNHcG29dfniCpo6ss4n9envqhNes4Lsw0cg1YDBvrKhbgf3xcSPwdFT3n0iiiG1sX2CwEZJyq8SsSjlst7CTUPbeZ92JII3IfxsGAoE/Oo+P29Twk4c5Hbb9kzxMQfW+LESRW+bQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010362; c=relaxed/simple;
	bh=4QxA8h4g5kGpM//ntVFMhPKR08Y5K2pSHNBtEjEJD2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j825QloywtTRpTiypOs2THye/n+51bxKYPrkICIiUm8V2uCjj7CF1mMcgKUt0ZPuvtU4ecZ2y0xJgRFLh7ASvPr5LHiokcpHGgPjXXGE6+RZivOZEZ88xhXducOTmT9dtA+hk5hlpqb3y0lQfEq2GgOGPUI0/+mu0IWpGltqT5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mdK3YvD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mdK3YvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B452B1F000E9;
	Thu,  2 Jul 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010361;
	bh=wR2a4YrJED/wgfZEbAbSBBwJ+p7Or5MkrZBBDPQ8+DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mdK3YvDcr823FroAeq24TLm0SZy6+AB8mzgNd5QZ1A3wiQ0tylKc/0ziawp3eC9X
	 lAnAGgQXrPGouP+8znRA8+uH2xIJMFsT3E0PzYOzS1UruWPteVZpUMJX1mWv16F8gr
	 2+32WBkhVYDIijZUwqAyizOrqB1oQ5Wkx/J3z1qI=
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
	Mark Brown <broonie@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.12 081/204] scripts/sorttable: Use normal sort if theres no relocs in the mcount section
Date: Thu,  2 Jul 2026 18:18:58 +0200
Message-ID: <20260702155120.364029837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 46514b3c2c17c67cefe84b0c1a59e0aaf6093131 ]

When ARM 64 is compiled with gcc, the mcount_loc section will be filled
with zeros and the addresses will be located in the Elf_Rela sections. To
sort the mcount_loc section, the addresses from the Elf_Rela need to be
placed into an array and that is sorted.

But when ARM 64 is compiled with clang, it does it the same way as other
architectures and leaves the addresses as is in the mcount_loc section.

To handle both cases, ARM 64 will first try to sort the Elf_Rela section,
and if it doesn't find any functions, it will then fall back to the
sorting of the addresses in the mcount_loc section itself.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/20250225182054.648398403@goodmis.org
Fixes: b3d09d06e052 ("arm64: scripts/sorttable: Implement sorting mcount_loc at boot for arm64")
Reported-by: "Arnd Bergmann" <arnd@arndb.de>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/893cd8f1-8585-4d25-bf0f-4197bf872465@app.fastmail.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -827,9 +827,14 @@ static void *sort_mcount_loc(void *arg)
 		pthread_exit(m_err);
 	}
 
-	if (sort_reloc)
+	if (sort_reloc) {
 		count = fill_relocs(vals, size, ehdr, emloc->start_mcount_loc);
-	else
+		/* gcc may use relocs to save the addresses, but clang does not. */
+		if (!count) {
+			count = fill_addrs(vals, size, start_loc);
+			sort_reloc = 0;
+		}
+	} else
 		count = fill_addrs(vals, size, start_loc);
 
 	if (count < 0) {


