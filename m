Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B534E2DF9F;
	Tue, 20 Feb 2024 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465336; cv=none; b=tYtBEmMrtG7VmmkvSKoMVfTFb44UTkKw1jE6b8/6AHggqumJl+A27fqXFOKfrySKXIIE/XHjClATrgW7AukU7G62TguWL0mvA+QG5e4fkPCX2ZG+kkyvoQRPUK5rsm53P2xT17M4ZtHdHRXoPGpZy7tNW6TQQrNOCSbuFrjYq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465336; c=relaxed/simple;
	bh=6AshNXO0GxGye/1azFQlORZ81nNsXsdKd4P5yeMBFXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYo64puH76yAg3k2XhzKUojS4fg8XlRx5vuwTyqicUf92+/yyBEHZEkqNq+HWaK8D/oh0enJKMd6FdoyDJIZufGC5ETUV9tVVOKSZznLnGDoW9dWl3ZOFXOudgpRoQu7qjbXqIPToHdqvO78jetoKMS3kzZlQZwoZ/EGB1w2vbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEk1tSr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEk1tSr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C41FC433C7;
	Tue, 20 Feb 2024 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465336;
	bh=6AshNXO0GxGye/1azFQlORZ81nNsXsdKd4P5yeMBFXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEk1tSr3o4ofNRsifWnUGkzJ1mzz5L7MQ2imRxrfER6DbdQ4ZZw12MFXojC3oZ8XK
	 3XnRRN+fcn8Xh2yoSbYlThPPtWLx0htdhjZkSvnIFwJ0akU6UVc9wddYqZasocMRx8
	 VohZKrmbTGigm2NogRd1CujkPQ4XpE/HrmOKWVHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 290/309] mm: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
Date: Tue, 20 Feb 2024 21:57:29 +0100
Message-ID: <20240220205642.179641433@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Prakash Sangappa <prakash.sangappa@oracle.com>

commit e656c7a9e59607d1672d85ffa9a89031876ffe67 upstream.

For shared memory of type SHM_HUGETLB, hugetlb pages are reserved in
shmget() call.  If SHM_NORESERVE flags is specified then the hugetlb pages
are not reserved.  However when the shared memory is attached with the
shmat() call the hugetlb pages are getting reserved incorrectly for
SHM_HUGETLB shared memory created with SHM_NORESERVE which is a bug.

-------------------------------
Following test shows the issue.

$cat shmhtb.c

int main()
{
	int shmflags = 0660 | IPC_CREAT | SHM_HUGETLB | SHM_NORESERVE;
	int shmid;

	shmid = shmget(SKEY, SHMSZ, shmflags);
	if (shmid < 0)
	{
		printf("shmat: shmget() failed, %d\n", errno);
		return 1;
	}
	printf("After shmget()\n");
	system("cat /proc/meminfo | grep -i hugepages_");

	shmat(shmid, NULL, 0);
	printf("\nAfter shmat()\n");
	system("cat /proc/meminfo | grep -i hugepages_");

	shmctl(shmid, IPC_RMID, NULL);
	return 0;
}

 #sysctl -w vm.nr_hugepages=20
 #./shmhtb

After shmget()
HugePages_Total:      20
HugePages_Free:       20
HugePages_Rsvd:        0
HugePages_Surp:        0

After shmat()
HugePages_Total:      20
HugePages_Free:       20
HugePages_Rsvd:        5 <--
HugePages_Surp:        0
--------------------------------

Fix is to ensure that hugetlb pages are not reserved for SHM_HUGETLB shared
memory in the shmat() call.

Link: https://lkml.kernel.org/r/1706040282-12388-1-git-send-email-prakash.sangappa@oracle.com
Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -100,6 +100,7 @@ static int hugetlbfs_file_mmap(struct fi
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
+	vm_flags_t vm_flags;
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -141,10 +142,20 @@ static int hugetlbfs_file_mmap(struct fi
 	file_accessed(file);
 
 	ret = -ENOMEM;
+
+	vm_flags = vma->vm_flags;
+	/*
+	 * for SHM_HUGETLB, the pages are reserved in the shmget() call so skip
+	 * reserving here. Note: only for SHM hugetlbfs file, the inode
+	 * flag S_PRIVATE is set.
+	 */
+	if (inode->i_flags & S_PRIVATE)
+		vm_flags |= VM_NORESERVE;
+
 	if (!hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
-				vma->vm_flags))
+				vm_flags))
 		goto out;
 
 	ret = 0;


