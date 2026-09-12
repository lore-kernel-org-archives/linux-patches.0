Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AD43624BC;
	Sat, 12 Sep 2026 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203504; cv=none; b=gRDO1x9N0jjTdJe62Kojr3c2BRKFYatLVx9qX/PZuiue+l+5FNGQvXBX3fvIe0SubE5sIVvn2z4BPri6WKtIAxYZFf8ax64ZdpXm0HgAhAn3lWcHGcgZonD35IOaYZMWjfFYVPTbr9BMJxM2/AlZ8S3Qm40lbTu2F9khPl45qQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203504; c=relaxed/simple;
	bh=7qf7Ol9ABFdiXdPdZYJ1kFw5BTW1ky5WJ1UwodKU7eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emfKCQ8Cuzz6e47ugKdGawB0AB9rrqh/8j33V+pKpoL5K5gGNvyboUxEBeIKJSDUWI+8oQLMn0E9T48g+qtoQwh26X8bdzW/4/bcZXLW4eCH64XMUCMevHEGNJgsf6DZQ9aoK6KXmiL53VjcwBmlikPRvG/zxTeikUjz2ysUk1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pilHjxOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pilHjxOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F1C1F000FF;
	Sat, 12 Sep 2026 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203502;
	bh=/IBRYPUVRYDnv8yIaV1T3W5F4xpKQhzymavrGCDedpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pilHjxOkqBfDmppcxi6+9oeGlvfpk06jF6NhQzCyCoJvbqedPgy7A88WWY4VcEVVQ
	 9AKQD0OdmOv/auRv9CCYFqKCWx2P/zF6mrznuijQhNCJ++OIwOOvK7Mv42B4hd6KOY
	 NlVfSsjzonZyvDTjEWLSaocvIdcMxj5gaj4CvH/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1379/1815] objtool/klp: Fix size of empty special section entries
Date: Sat, 12 Sep 2026 08:52:09 +0200
Message-ID: <20260912065721.399500428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 1ea786097cd79522b76cbd41beeb8f84ef3a76f4 ]

create_fake_symbols() sizes each ANNOTATE_DATA_SPECIAL entry from the
offset of the next annotation, falling back to the end of the section
for the last entry.  But the last entry is detected by a zero size,
which also happens for an *empty* entry: ALTERNATIVE(oldinstr, "", ft)
still annotates its zero-length replacement, at the same offset as the
next entry's annotation.

So every empty replacement gets a fake symbol spanning the entire rest
of .altinstr_replacement.  That's harmless today only because
find_symbol_containing() picks the smaller of two overlapping symbols.

Track whether a next annotation was found rather than inferring it from
the size.  A zero-length fake symbol is fine: find_symbol_containing()
skips those, so the properly sized symbol at the same offset still wins.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/913e691c5009397df832c7c9a18cd5cf71b42737.1786138493.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index c5284d2752072..b4220e12a8e2f 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1628,13 +1628,17 @@ static int create_fake_symbols(struct elf *elf)
 	for_each_reloc(sec->rsec, reloc) {
 		unsigned long offset, size;
 		struct reloc *next_reloc;
+		bool last = true;
 
 		if (annotype(elf, sec, reloc) != ANNOTYPE_DATA_SPECIAL)
 			continue;
 
 		offset = reloc_addend(reloc);
 
-		size = 0;
+		/*
+		 * Find the start of the next entry so the fake symbol size can
+		 * be calculated.
+		 */
 		next_reloc = reloc;
 		for_each_reloc_continue(sec->rsec, next_reloc) {
 			if (annotype(elf, sec, next_reloc) != ANNOTYPE_DATA_SPECIAL ||
@@ -1642,10 +1646,15 @@ static int create_fake_symbols(struct elf *elf)
 				continue;
 
 			size = reloc_addend(next_reloc) - offset;
+			last = false;
 			break;
 		}
 
-		if (!size)
+		/*
+		 * If no next entry found, this is the last entry, so its size
+		 * is from the current offset to the end of the section.
+		 */
+		if (last)
 			size = sec_size(reloc->sym->sec) - offset;
 
 		if (create_fake_symbol(elf, reloc->sym->sec, offset, size))
-- 
2.53.0



