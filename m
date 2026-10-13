Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA45E3B1EE7;
	Tue, 13 Oct 2026 11:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892070; cv=none; b=LPp2EFPgz08eL+BDm6eCwk9qMXQF5KonPal/pjfEv7KBY30eNI4yHPmyZBY6/ydl547xB+cx8G8ArFLv4mNpViplVltZxwymK2eU9IhuRpTiQgsQ446+vVIK+EGGio4S1vc/lI41u00wz1ar1Ne61WaoZ8dfZhqR+qqIzfK7+L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892070; c=relaxed/simple;
	bh=U6LIqb2eXWDzETPQuTzfWt3s+2aCjY2tWVVp2XKcjqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZI3xyt56Qjzu5eHaKjgODqZwhLVjabAAwVXr3FF26Zd3NYZqXStN6ZbqnytWOcFPdIT9DBww2tOD2Y2Rg/6tD7jeN9EYqOj7qjgyV+EDIxAdScEnM2DOGQmeb3Fpsb70U2FlfLPgcNXBCPinH6FrWfos1InNvKIzhEtULmAyJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSkVnGxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSkVnGxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9311F00893;
	Tue, 13 Oct 2026 11:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892069;
	bh=jwBNDY5HE4Vlkszv+5DiFh0uDpQloLoqSDCT1Ez9LsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSkVnGxOLVUKgtIGpc6X9xnFXOlUWNMNoc09XqgfCumQMh9OkvJfSD6EXMb1UTjBu
	 5RtSHBTE2ugbfKDWvdbJM0tGJeCLTRvWJT2sIRaIZSU3oWeuF6EGDDOYbHbe7mIvDC
	 looi5EoUwBpN2PjUkYA3Q5LS/YWi6hB8DiJ3/X4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	SJ Park <sj@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH 7.2 050/281] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
Date: Tue, 13 Oct 2026 13:36:06 +0200
Message-ID: <20261013112856.266045533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 28eed9906e01d01cbdfb352e799413b2e8b33b76 upstream.

Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
However, the incorrect format specifier '%lu' was used which triggers
-Wformat warnings when building for 32-bit:

  hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
        |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
        |                                         %zu

  hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
  but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
        |                            ~~~              ^~~~~~~~~~~~~~~~~~~
        |                            %zu

Fix this by switching to the expected '%zu' format specifier.

Link: https://lore.kernel.org/20260927162419.820609-1-cmllamas@google.com
Fixes: ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB pages")
Fixes: 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into hugepage-mmap")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/hugetlb-mmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 0f2aad1b7dbd..2edbc992e6bc 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -122,7 +122,7 @@ int main(int argc, char **argv)
 		hugepage_size = default_huge_page_size();
 		if (!hugepage_size)
 			ksft_exit_skip("Could not detect default hugetlb page size.");
-		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
+		ksft_print_msg("Default size hugepages (%zu kB)\n", hugepage_size >> 10);
 	}
 
 	/* munmap will fail if the length is not page aligned */
@@ -131,7 +131,7 @@ int main(int argc, char **argv)
 
 	hugetlb_set_nr_pages(hugepage_size, nr);
 	if (hugetlb_free_pages(hugepage_size) < nr)
-		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
+		ksft_exit_skip("Not enough %zu Kb pages\n", hugepage_size >> 10);
 
 	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
-- 
2.56.0



