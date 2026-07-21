Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E829040B106;
	Tue, 21 Jul 2026 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648242; cv=none; b=XhY/TNhRNTT3+FfvXeZA0H2Ku0ianRMyZoZCR4GbLS5xN0FR4pq7Qp/8RvMhif+8rm8NnVLYYfzRK0v6CuwExIF0I/WAWgyR7mWZ9dhqLqGd90moRKXmQhMEowvWxSC5hIU+tDHKWBSCsCTikXRHEg48bJ6cKlfrzsOUyJgHQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648242; c=relaxed/simple;
	bh=0GST2fGThUN/peDO40/1X7hrGPcZJIfv6tjTj0MxWCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIMwUeohhO4Qs+MkYTfBlmgbiqABxOBUbjq2upNZeVEkwb4rI7LFaAwArE/GqhpeobZei+RalimKaWHp0gLUN5aJwmTlAZGlc18geFMcRXB61LQ6dvd2o8+Iw53mW9njFVjr848QGsy5ngc3bG9/9GfBLp4An+zFXexChcB6o5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwRMkWRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwRMkWRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576141F000E9;
	Tue, 21 Jul 2026 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648240;
	bh=9g/Oc0WU3YrFsQ2UxrDhEtWrR9nWBAZJOfKgjEYW8y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QwRMkWRhNpj2O3O/Xt1nFRy7sieqRp2BWctpI7YI4ZOLf8Ar5OVo5vmFERe5bXdnF
	 LdY22ba1VDmM/qJ78otTZz6Ahg/IAxfQFZayDbJGW5KK3Vg8yUTNmt6d5obRQ0AAUT
	 NXsxlAr8LESDkkbUzgIUvMlf+m9R3BkZpvgu1on8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0123/2077] objtool/klp: Fix create_fake_symbols() skipping entsize-based sections
Date: Tue, 21 Jul 2026 16:56:36 +0200
Message-ID: <20260721152555.600438128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 3de711fba73ad93b8b3fbe09cf681cefed5d573d ]

create_fake_symbols() has two phases: creating symbols from
ANNOTATE_DATA_SPECIAL entries, and a fallback that uses sh_entsize for
special sections like .static_call_sites.

When .discard.annotate_data is absent, the function returns early,
skipping the entsize fallback and silently allowing unsupported
module-local static call keys through.

Fix it by jumping to the entsize phase instead of returning early.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Assisted-by: Claude:claude-4-opus
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index cb26c1c92a74a2..18e40a7f864310 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1348,7 +1348,7 @@ static int create_fake_symbols(struct elf *elf)
 
 	sec = find_section_by_name(elf, ".discard.annotate_data");
 	if (!sec || !sec->rsec)
-		return 0;
+		goto entsize;
 
 	for_each_reloc(sec->rsec, reloc) {
 		unsigned long offset, size;
@@ -1380,7 +1380,7 @@ static int create_fake_symbols(struct elf *elf)
 	/*
 	 * 2) Make symbols for sh_entsize, and simple arrays of pointers:
 	 */
-
+entsize:
 	for_each_sec(elf, sec) {
 		unsigned int entry_size;
 		unsigned long offset;
-- 
2.53.0



