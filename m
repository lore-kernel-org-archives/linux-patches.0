Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE6C129;
	Mon,  1 Apr 2024 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988634; cv=none; b=ICm5Lp5SmPgjbwtL5fWVjvmjHkXvmTZrOB7PrrtrNI2avGjCar3fKc9hPFOoAMB+HJu7+2mzSeaZIrLu1jcGqx8XWrCVf77dcJoLIghlcuFUUc4mB1OnfsuqFmItl6reOAH/y8HzdKxbJx3I00NAOXj+JbPFs6Xj1eAz3+W0p/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988634; c=relaxed/simple;
	bh=+lZvTwpoYnP3F4fp7RXGbi85kQqKe9MrgrLqiGzEQRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBejxeAH7B1SUoihsCTIbFPA8tXUrUEhg3gA9WSOWFeHIhgc11Ck7eoUg7DZ77xUfD9GCVTml20vil2hX0wT15hGKM+r+ELyJYF6ZUYXfyO7o2U3A5gRyIvGeJoeBb1vtMBWVoULuksAVwObOcSP6SMttc+TunoHqpdRwgWDooA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcqYQoVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcqYQoVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313CBC433F1;
	Mon,  1 Apr 2024 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988634;
	bh=+lZvTwpoYnP3F4fp7RXGbi85kQqKe9MrgrLqiGzEQRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcqYQoVhBdp78Dme1HHd2YkuVDKGPEehJDjEleey6agbqjDr8NMuT6bWuADXKoqxn
	 NPnyX+3RlIKwpHk1Cno32yoLDbPyI2fOBs4DIXF1+hLQafm9XaTc6klRycUZ31Y2Co
	 qZ9Cmr+w8UlcRmzXxYkLzcFCarkEsayEOrt8ns+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 244/432] mm, mmap: fix vma_merge() case 7 with vma_ops->close
Date: Mon,  1 Apr 2024 17:43:51 +0200
Message-ID: <20240401152600.413782444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka <vbabka@suse.cz>

commit fc0c8f9089c20d198d8fe51ddc28bfa1af588dce upstream.

When debugging issues with a workload using SysV shmem, Michal Hocko has
come up with a reproducer that shows how a series of mprotect() operations
can result in an elevated shm_nattch and thus leak of the resource.

The problem is caused by wrong assumptions in vma_merge() commit
714965ca8252 ("mm/mmap: start distinguishing if vma can be removed in
mergeability test").  The shmem vmas have a vma_ops->close callback that
decrements shm_nattch, and we remove the vma without calling it.

vma_merge() has thus historically avoided merging vma's with
vma_ops->close and commit 714965ca8252 was supposed to keep it that way.
It relaxed the checks for vma_ops->close in can_vma_merge_after() assuming
that it is never called on a vma that would be a candidate for removal.
However, the vma_merge() code does also use the result of this check in
the decision to remove a different vma in the merge case 7.

A robust solution would be to refactor vma_merge() code in a way that the
vma_ops->close check is only done for vma's that are actually going to be
removed, and not as part of the preliminary checks.  That would both solve
the existing bug, and also allow additional merges that the checks
currently prevent unnecessarily in some cases.

However to fix the existing bug first with a minimized risk, and for
easier stable backports, this patch only adds a vma_ops->close check to
the buggy case 7 specifically.  All other cases of vma removal are covered
by the can_vma_merge_before() check that includes the test for
vma_ops->close.

The reproducer code, adapted from Michal Hocko's code:

int main(int argc, char *argv[]) {
  int segment_id;
  size_t segment_size = 20 * PAGE_SIZE;
  char * sh_mem;
  struct shmid_ds shmid_ds;

  key_t key = 0x1234;
  segment_id = shmget(key, segment_size,
                      IPC_CREAT | IPC_EXCL | S_IRUSR | S_IWUSR);
  sh_mem = (char *)shmat(segment_id, NULL, 0);

  mprotect(sh_mem + 2*PAGE_SIZE, PAGE_SIZE, PROT_NONE);

  mprotect(sh_mem + PAGE_SIZE, PAGE_SIZE, PROT_WRITE);

  mprotect(sh_mem + 2*PAGE_SIZE, PAGE_SIZE, PROT_WRITE);

  shmdt(sh_mem);

  shmctl(segment_id, IPC_STAT, &shmid_ds);
  printf("nattch after shmdt(): %lu (expected: 0)\n", shmid_ds.shm_nattch);

  if (shmctl(segment_id, IPC_RMID, 0))
          printf("IPCRM failed %d\n", errno);
  return (shmid_ds.shm_nattch) ? 1 : 0;
}

Link: https://lkml.kernel.org/r/20240222215930.14637-2-vbabka@suse.cz
Fixes: 714965ca8252 ("mm/mmap: start distinguishing if vma can be removed in mergeability test")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -954,13 +954,21 @@ static struct vm_area_struct
 	} else if (merge_prev) {			/* case 2 */
 		if (curr) {
 			vma_start_write(curr);
-			err = dup_anon_vma(prev, curr, &anon_dup);
 			if (end == curr->vm_end) {	/* case 7 */
+				/*
+				 * can_vma_merge_after() assumed we would not be
+				 * removing prev vma, so it skipped the check
+				 * for vm_ops->close, but we are removing curr
+				 */
+				if (curr->vm_ops && curr->vm_ops->close)
+					err = -EINVAL;
 				remove = curr;
 			} else {			/* case 5 */
 				adjust = curr;
 				adj_start = (end - curr->vm_start);
 			}
+			if (!err)
+				err = dup_anon_vma(prev, curr, &anon_dup);
 		}
 	} else { /* merge_next */
 		vma_start_write(next);


