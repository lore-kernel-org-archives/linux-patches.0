Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28161C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332F3C433EF;
	Mon, 20 Mar 2023 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326167;
	bh=Fc2LY8kg5erkMKI8YX4205Af+z97dWI42SPFrBSVEqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtlwtlD6v059aCRbH0LlD1TJxxSTAPy6j/Lf+rGdIUWm02NOTS8jtYIMtBIn93UQM
	 0ZO7NiBZ4gaPvV0eJ7l0s9r9UfTKiNjqj6r0k8aHm7/+zKkZU9rhNwSOiRuwYS8Yj/
	 URQEB6dwIbW53aEGuT3I8MvGSQ7Dpu1CF0maBpiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Houghton <jthoughton@google.com>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 186/211] mm: teach mincore_hugetlb about pte markers
Date: Mon, 20 Mar 2023 15:55:21 +0100
Message-Id: <20230320145521.293151991@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Houghton <jthoughton@google.com>

commit 63cf584203f3367c8b073d417c8e5cbbfc450506 upstream.

By checking huge_pte_none(), we incorrectly classify PTE markers as
"present".  Instead, check huge_pte_none_mostly(), classifying PTE markers
the same as if the PTE were completely blank.

PTE markers, unlike other kinds of swap entries, don't reference any
physical page and don't indicate that a physical page was mapped
previously.  As such, treat them as non-present for the sake of mincore().

Link: https://lkml.kernel.org/r/20230302222404.175303-1-jthoughton@google.com
Fixes: 5c041f5d1f23 ("mm: teach core mm about pte markers")
Signed-off-by: James Houghton <jthoughton@google.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mincore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -33,7 +33,7 @@ static int mincore_hugetlb(pte_t *pte, u
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
 	 */
-	present = pte && !huge_pte_none(huge_ptep_get(pte));
+	present = pte && !huge_pte_none_mostly(huge_ptep_get(pte));
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;


