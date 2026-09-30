Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71213CB56A;
	Wed, 30 Sep 2026 19:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796028; cv=none; b=OSvqO5QCoK5Dydj4BAYIX33cyJJktClKvTqaNlXFnXyPjt+IPJEGM3yLdWweK7Fqcr8fmyqGCtAZgld3kNCkdz2O4gRxzmbKraQchwUGhT4J7enH3jvvbX9KqfjcfbBMaU+JL2EBYZU4nGm7u69vnlEqOpQg9GUynV/mJ6sCB/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796028; c=relaxed/simple;
	bh=MvtAFwcX08ImBlF3C0Q2LteQRDybjmM/1SyG7lVuMM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJ+hetIDG/Mod2Tmq30daFc8NGoJUuBTgJRHf+HZSh2fzAUNNyjKNnZgPKyLcjeODUGdetXhy0/fggn2v0f8tYRCR+xzfaGOBXyDpCo8ToyMtCo9jZOoluiaUYiybwwLA8dSv6oAOOLcB8PqPJhyvJajbqv/RbrNqYTMhMzG+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCQzSvOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCQzSvOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF35F1F000FF;
	Wed, 30 Sep 2026 19:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796026;
	bh=p+3pXSqEzZvU1f9afkpbfF82v2azVb1PSSg5mpJKaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCQzSvOnLMMFFSn3tH8Sf7xiIuQLG99UzmBTaDe/YTS7I0MzW2sFDw4eUA4yuezk3
	 uTRxTQ9JJc3huUDk3YB4IxyKoCnT3EwW3yQfuwT/4C5Qd8WW33yNlQ+oLqPcVeHU+/
	 eaABgjqlq92IRMs9Vb6f3puAgBCTJOeTfKpEYNQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meijing Zhao <zhaomeijing@lixiang.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0769/1193] mm: memblock: show all region flags in debugfs
Date: Wed, 30 Sep 2026 17:24:13 +0200
Message-ID: <20260930152451.341044967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Meijing Zhao <zhaomeijing@lixiang.com>

[ Upstream commit e2d5b01f878d76bd1142e512a0b979a1d3cd0abf ]

Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
debugfs") made memblock_debug_show() stop after finding the first set
flag. A memblock region can carry multiple flags, so the remaining flags
are hidden from debugfs.

Walk all bits in the region flags and print every set flag separated by
"|". Keep walking beyond flagname[] so that a set flag without a known
name is reported as UNKNOWN rather than silently ignored.

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Link: https://patch.msgid.link/20260902075944.3742866-1-zhaomeijing100@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 0695284232f3c..bb79e869718f2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2255,14 +2255,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
-			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+			unsigned int flags = reg->flags;
+			bool first = true;
+
+			for (j = 0; flags; j++, flags >>= 1) {
+				if (!(flags & 1))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, j < count ? flagname[j] : "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
 			seq_printf(m, "%s\n", "NONE");
 		}
-- 
2.53.0



