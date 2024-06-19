Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238D7146016;
	Wed, 19 Jun 2024 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804131; cv=none; b=T0JhSS5D3wjhlm0uRUaMQq3SBxiUOvsbphOkJQpNgbIOtE0bKOStJwdqihdNK2sCMo0oolxAWsXG68Sg9Q6CWVLpQx0pXboXlDvyghbZ6NUwgZ1vp9bRouFpjoW9zh/PTML2pyFTSRlF7zH5MaEQeUEmhqY38Rv34EihFyGp7qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804131; c=relaxed/simple;
	bh=6vPx2nf9E0d3VwBskf33Y4FJxh/dp3Vluyaz5lfLE4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7APAqreFRLUKNMw/rq9mR97kZyyQYynizw8so9xdxxiCS6o/fodmhvpk3JKt4u5XVZErzClMVb0H8VJ57eUGe1cBdfRst9DR4RTa8FenW+XSLqIr17/9aMQ0enY1zTAv8qr2K/kPIDLtqfAcbB4WWLeHzrQy+LEJgQwjyJTJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZVri+By; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZVri+By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB6C2BBFC;
	Wed, 19 Jun 2024 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804131;
	bh=6vPx2nf9E0d3VwBskf33Y4FJxh/dp3Vluyaz5lfLE4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZVri+ByROoJubvQAa+HBt850xFkvqiCT/iljj09fbwwhMgwubM/0QLt7VRrP9LAF
	 YCsEpPJgCBWKt6jql/DeG2npuDb9+AQtdzUdkLT99/fcA5Dw7AQQ7u+W+s+XcS56qm
	 ML4H7RotLMuNvYu2mSjZTTiOazllfyt9XRahCH0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sam James <sam@gentoo.org>
Subject: [PATCH 6.1 205/217] Revert "fork: defer linking file vma until vma is fully initialized"
Date: Wed, 19 Jun 2024 14:57:28 +0200
Message-ID: <20240619125604.597228864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam James <sam@gentoo.org>

This reverts commit 0c42f7e039aba3de6d7dbf92da708e2b2ecba557 which is commit
35e351780fa9d8240dd6f7e4f245f9ea37e96c19 upstream.

The backport is incomplete and causes xfstests failures. The consequences
of the incomplete backport seem worse than the original issue, so pick
the lesser evil and revert until a full backport is ready.

Link: https://lore.kernel.org/stable/20240604004751.3883227-1-leah.rumancik@gmail.com/
Reported-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -662,15 +662,6 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
-		/*
-		 * Copy/update hugetlb private vma information.
-		 */
-		if (is_vm_hugetlb_page(tmp))
-			hugetlb_dup_vma_private(tmp);
-
-		if (tmp->vm_ops && tmp->vm_ops->open)
-			tmp->vm_ops->open(tmp);
-
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
@@ -687,6 +678,12 @@ static __latent_entropy int dup_mmap(str
 			i_mmap_unlock_write(mapping);
 		}
 
+		/*
+		 * Copy/update hugetlb private vma information.
+		 */
+		if (is_vm_hugetlb_page(tmp))
+			hugetlb_dup_vma_private(tmp);
+
 		/* Link the vma into the MT */
 		mas.index = tmp->vm_start;
 		mas.last = tmp->vm_end - 1;
@@ -698,6 +695,9 @@ static __latent_entropy int dup_mmap(str
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
 			retval = copy_page_range(tmp, mpnt);
 
+		if (tmp->vm_ops && tmp->vm_ops->open)
+			tmp->vm_ops->open(tmp);
+
 		if (retval)
 			goto loop_out;
 	}


