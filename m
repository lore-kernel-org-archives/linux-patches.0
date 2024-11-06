Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402A71DFE0B;
	Wed,  6 Nov 2024 12:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896549; cv=none; b=HRVovlCfPC15gCMJgXVDGmhP9QKtJ8i8OwgnbrIsrdF0JTmhT9AnJPORJx6zl+pPNFD88VjFzd2f3EsdLeQp1uQiAL9HqkPpPzIjf0fO+0Qfh0nFubB2OxWVvH3GASMBhkzLYDOpNooMH15A3uw19tHvzKSkVjF7U/kUhksZecE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896549; c=relaxed/simple;
	bh=L8IjY8bc/3c4OP96xIX17HnHLpxs38Lwz8k6XzHvEr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnz0uyJ9ZZtVKtwH4HFvV2XAQVpekxp1kyZCPwTjsicGQdo7wJ8CTpfPw5FXZJWSRrGQKex9SyJpE0QDOCKPp1QbEdrEuL4FlKms0oQXbFutyRx0Gah+wp8O3Wq2KLIDMQml6brIoIZ6VnnmrzG7IEF1Rko/QcABsMsNuF2sHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YObDHId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YObDHId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B700C4CECD;
	Wed,  6 Nov 2024 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896549;
	bh=L8IjY8bc/3c4OP96xIX17HnHLpxs38Lwz8k6XzHvEr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YObDHIdq9BQzCJUciuK6iAYEjf4dhNt7m3DsAhrBiOvAySg3kxllQogETEZ+XWP9
	 tm7MYQlI8m9aFfdQ8TT3QpqCTX2eQQQpXErr60Fuuupo8F0o5Hcl+E54lK+bI2ygtJ
	 oP3mCFek66EGKOqNe+NCZRnBOlQ+14/KVIVkd1pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Michael Matz <matz@suse.de>,
	Matthias Bodenbinder <matthias@bodenbinder.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Gabriel Krisman Bertazi <gabriel@krisman.be>
Subject: [PATCH 6.11 203/245] mm, mmap: limit THP alignment of anonymous mappings to PMD-aligned sizes
Date: Wed,  6 Nov 2024 13:04:16 +0100
Message-ID: <20241106120324.243782042@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

[ Upstream commit d4148aeab412432bf928f311eca8a2ba52bb05df ]

Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
boundaries") a mmap() of anonymous memory without a specific address hint
and of at least PMD_SIZE will be aligned to PMD so that it can benefit
from a THP backing page.

However this change has been shown to regress some workloads
significantly.  [1] reports regressions in various spec benchmarks, with
up to 600% slowdown of the cactusBSSN benchmark on some platforms.  The
benchmark seems to create many mappings of 4632kB, which would have merged
to a large THP-backed area before commit efa7df3e3bb5 and now they are
fragmented to multiple areas each aligned to PMD boundary with gaps
between.  The regression then seems to be caused mainly due to the
benchmark's memory access pattern suffering from TLB or cache aliasing due
to the aligned boundaries of the individual areas.

Another known regression bisected to commit efa7df3e3bb5 is darktable [2]
[3] and early testing suggests this patch fixes the regression there as
well.

To fix the regression but still try to benefit from THP-friendly anonymous
mapping alignment, add a condition that the size of the mapping must be a
multiple of PMD size instead of at least PMD size.  In case of many
odd-sized mapping like the cactusBSSN creates, those will stop being
aligned and with gaps between, and instead naturally merge again.

Link: https://lkml.kernel.org/r/20241024151228.101841-2-vbabka@suse.cz
Fixes: efa7df3e3bb5 ("mm: align larger anonymous mappings on THP boundaries")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Michael Matz <matz@suse.de>
Debugged-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1229012 [1]
Reported-by: Matthias Bodenbinder <matthias@bodenbinder.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219366 [2]
Closes: https://lore.kernel.org/all/2050f0d4-57b0-481d-bab8-05e8d48fed0c@leemhuis.info/ [3]
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 18fddcce03b85..8a04f29aa4230 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1952,7 +1952,8 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 	if (get_area) {
 		addr = get_area(file, addr, len, pgoff, flags);
-	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
+		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
 						     pgoff, flags, vm_flags);
-- 
2.43.0



