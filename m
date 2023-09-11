Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D821170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F56C433C8;
	Mon, 11 Sep 2023 13:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440461;
	bh=Ym+rbpL4k/6qXBv22+qjqcig/omEmm+qg9RXzKQgL24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIUwRfVUQoCOwA6k2l2MiN1OSNosSq0cyWhFl8xi1uEcJw7sO13tXG1lkDOZhb9tv
	 3aveqMau6Jc7xIihMjD03R52qCIeZY+3k6dLc5+JB9B0udL3eQ6UbpYJxs1Jj2f2pC
	 vsSaHK3CieufW+KIQXZ6C04licTdOKHwgN5sG7Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 069/739] libbpf: Fix realloc API handling in zero-sized edge cases
Date: Mon, 11 Sep 2023 15:37:48 +0200
Message-ID: <20230911134653.039547520@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 8a0260dbf6553c969248b6530cafadac46562f47 ]

realloc() and reallocarray() can either return NULL or a special
non-NULL pointer, if their size argument is zero. This requires a bit
more care to handle NULL-as-valid-result situation differently from
NULL-as-error case. This has caused real issues before ([0]), and just
recently bit again in production when performing bpf_program__attach_usdt().

This patch fixes 4 places that do or potentially could suffer from this
mishandling of NULL, including the reported USDT-related one.

There are many other places where realloc()/reallocarray() is used and
NULL is always treated as an error value, but all those have guarantees
that their size is always non-zero, so those spot don't need any extra
handling.

  [0] d08ab82f59d5 ("libbpf: Fix double-free when linker processes empty sections")

Fixes: 999783c8bbda ("libbpf: Wire up spec management and other arch-independent USDT logic")
Fixes: b63b3c490eee ("libbpf: Add bpf_program__set_insns function")
Fixes: 697f104db8a6 ("libbpf: Support custom SEC() handlers")
Fixes: b12688267280 ("libbpf: Change the order of data and text relocations.")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230711024150.1566433-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 15 ++++++++++++---
 tools/lib/bpf/usdt.c   |  5 ++++-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index bc48ab1695719..7cc79bf764550 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6157,7 +6157,11 @@ static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_progra
 	if (main_prog == subprog)
 		return 0;
 	relos = libbpf_reallocarray(main_prog->reloc_desc, new_cnt, sizeof(*relos));
-	if (!relos)
+	/* if new count is zero, reallocarray can return a valid NULL result;
+	 * in this case the previous pointer will be freed, so we *have to*
+	 * reassign old pointer to the new value (even if it's NULL)
+	 */
+	if (!relos && new_cnt)
 		return -ENOMEM;
 	if (subprog->nr_reloc)
 		memcpy(relos + main_prog->nr_reloc, subprog->reloc_desc,
@@ -8528,7 +8532,8 @@ int bpf_program__set_insns(struct bpf_program *prog,
 		return -EBUSY;
 
 	insns = libbpf_reallocarray(prog->insns, new_insn_cnt, sizeof(*insns));
-	if (!insns) {
+	/* NULL is a valid return from reallocarray if the new count is zero */
+	if (!insns && new_insn_cnt) {
 		pr_warn("prog '%s': failed to realloc prog code\n", prog->name);
 		return -ENOMEM;
 	}
@@ -8837,7 +8842,11 @@ int libbpf_unregister_prog_handler(int handler_id)
 
 	/* try to shrink the array, but it's ok if we couldn't */
 	sec_defs = libbpf_reallocarray(custom_sec_defs, custom_sec_def_cnt, sizeof(*sec_defs));
-	if (sec_defs)
+	/* if new count is zero, reallocarray can return a valid NULL result;
+	 * in this case the previous pointer will be freed, so we *have to*
+	 * reassign old pointer to the new value (even if it's NULL)
+	 */
+	if (sec_defs || custom_sec_def_cnt == 0)
 		custom_sec_defs = sec_defs;
 
 	return 0;
diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index f1a141555f084..37455d00b239c 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -852,8 +852,11 @@ static int bpf_link_usdt_detach(struct bpf_link *link)
 		 * system is so exhausted on memory, it's the least of user's
 		 * concerns, probably.
 		 * So just do our best here to return those IDs to usdt_manager.
+		 * Another edge case when we can legitimately get NULL is when
+		 * new_cnt is zero, which can happen in some edge cases, so we
+		 * need to be careful about that.
 		 */
-		if (new_free_ids) {
+		if (new_free_ids || new_cnt == 0) {
 			memcpy(new_free_ids + man->free_spec_cnt, usdt_link->spec_ids,
 			       usdt_link->spec_cnt * sizeof(*usdt_link->spec_ids));
 			man->free_spec_ids = new_free_ids;
-- 
2.40.1



