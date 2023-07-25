Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDAB1EA72
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB0C433C7;
	Tue, 25 Jul 2023 10:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282177;
	bh=/WSUJ4MZNBXEQFat0hm3g+FgNhjj2koOuWzKQ0ebEsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeFrHeRDI7T+5UwUitYb0vZy+ZZHmFM1ilLlORImQVPAfhqISTiNQh75jZS07Hh/1
	 qqdvwKvqvOARtkIxIEnNVnVdev3rWR2oqBYPIMfrdrcsfSliyrCpdiod+LVfJXMstT
	 BIaHTmk5G6Rqq9VSlG8g1do7wGrm1Etie7gkg37E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 007/227] mm/mlock: fix vma iterator conversion of apply_vma_lock_flags()
Date: Tue, 25 Jul 2023 12:42:54 +0200
Message-ID: <20230725104515.107130597@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit 2658f94d679243209889cdfa8de3743cde1abea9 upstream.

apply_vma_lock_flags() calls mlock_fixup(), which could merge the VMA
after where the vma iterator is located.  Although this is not an issue,
the next iteration of the loop will check the start of the vma to be equal
to the locally saved 'tmp' variable and cause an incorrect failure
scenario.  Fix the error by setting tmp to the end of the vma iterator
value before restarting the loop.

There is also a potential of the error code being overwritten when the
loop terminates early.  Fix the return issue by directly returning when an
error is encountered since there is nothing to undo after the loop.

Link: https://lkml.kernel.org/r/20230711175020.4091336-1-Liam.Howlett@oracle.com
Fixes: 37598f5a9d8b ("mlock: convert mlock to vma iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
  Link: https://lore.kernel.org/linux-mm/50341ca1-d582-b33a-e3d0-acb08a65166f@arm.com/
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mlock.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -471,7 +471,6 @@ static int apply_vma_lock_flags(unsigned
 {
 	unsigned long nstart, end, tmp;
 	struct vm_area_struct *vma, *prev;
-	int error;
 	VMA_ITERATOR(vmi, current->mm, start);
 
 	VM_BUG_ON(offset_in_page(start));
@@ -492,6 +491,7 @@ static int apply_vma_lock_flags(unsigned
 	nstart = start;
 	tmp = vma->vm_start;
 	for_each_vma_range(vmi, vma, end) {
+		int error;
 		vm_flags_t newflags;
 
 		if (vma->vm_start != tmp)
@@ -505,14 +505,15 @@ static int apply_vma_lock_flags(unsigned
 			tmp = end;
 		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
 		if (error)
-			break;
+			return error;
+		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
 	}
 
-	if (vma_iter_end(&vmi) < end)
+	if (tmp < end)
 		return -ENOMEM;
 
-	return error;
+	return 0;
 }
 
 /*


