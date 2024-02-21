Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65CD7BB1B;
	Wed, 21 Feb 2024 13:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523442; cv=none; b=gQ68mp/cZNgE4PvE8zT8nFE7MM6LcU5df/dl7XSBqHHLY4SD6pk83y5DAaA48HYoL7XX2NkennpyAvsxkxUm1+RDBc0LY2LCpjwedrrj5Vw2o68jz15xh9fFAUnSB6d7RNzDtcTalds19794a6r5PjZ/Vh3BOpWELv7aqJQg1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523442; c=relaxed/simple;
	bh=R5IGBSmTLbxAhCC2u9Zf9wbxIe05kLPxhrwb/h6ngjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=erowUEVHQ8yG9aFAQnaLl01A8yFAhBzFlDK7vcS2NqFOYlrlPseILVRrNDV68h+WSC7v/PnMq8nh9+gyr5pXXYjTxkihKnns7qiSiCvqd3wLHOEy2glFQ9NfWhcYkmFFMNMtnStqhEz2deuhSRhmYJg5PlgqCJz40b2Tn7hMeXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYkVpkKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYkVpkKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487E1C433F1;
	Wed, 21 Feb 2024 13:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523437;
	bh=R5IGBSmTLbxAhCC2u9Zf9wbxIe05kLPxhrwb/h6ngjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYkVpkKAiZUcTxHvkEQGQ4xlMqawQa7IqcfuAjGnAzdmEc/qk7CEo5ol2r2/EB7wD
	 yA8mNu3G5ctIHDUIowfBopHJsIgHBxD+4TLjRIuv/TbiyRPc9KY1kMzhDWihbnfChh
	 JykrElPMBWFk/06DX7d/yuxEO/G4DIDgfTEzjHJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 419/476] mm: hugetlb pages should not be reserved by shmat() if SHM_NORESERVE
Date: Wed, 21 Feb 2024 14:07:50 +0100
Message-ID: <20240221130023.512969224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -135,6 +135,7 @@ static int hugetlbfs_file_mmap(struct fi
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
+	vm_flags_t vm_flags;
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -176,10 +177,20 @@ static int hugetlbfs_file_mmap(struct fi
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


