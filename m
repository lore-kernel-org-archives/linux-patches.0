Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882BA12FB31;
	Wed, 19 Jun 2024 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802582; cv=none; b=ircI0j6YJZ/bwQIlC6dL7S6dY7bM+pY6/ytlgkBeHWVQCI9A9H7X6sDlehszVReHrfqMduD7Ox1ZkKI3Ds0Eznvr544kG7po7Yq7cwyi0grP9GSEEhYawSZqgfIXkvZ8CdtB7rbXYEd3XS6cqJ856+0QwYfDLHkrxPGskBPwXWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802582; c=relaxed/simple;
	bh=1Ce/9IB5mVCVcdXPpmy/4ecjq3T9kmqqCqeSfk8bFXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu611yUWDe+sSvml9L/gdeaxaCBUOYDLNqiU0DBeLOqM4SSRdPnZYw+ESgy8emy4rRC8fKfGtd0h+ShilLkNQ7YY7/kw9oAvmdKV2ynC/xku8gLj826ysP23zke8W+pTVmh3HoRU2Dls3ydWbirpXlOIXCSl/lbt/TpQigvbhp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhxFnkLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhxFnkLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102EFC2BBFC;
	Wed, 19 Jun 2024 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802582;
	bh=1Ce/9IB5mVCVcdXPpmy/4ecjq3T9kmqqCqeSfk8bFXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhxFnkLOU9KFA76HvU1Z82YjxAZhohxWQS5aG8+ldLUS4ElGHQPfvpt+ybWTi0W11
	 hcQ5wguA86YFtomKzHAO7wBkQB1SDphqZMreWz4u9mUa/3Fwg/s66td4Oy7L0CJ0QS
	 MmTojW5U5z08H6X120Bd/lsKH1KekiP2zK6VtqKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sam James <sam@gentoo.org>
Subject: [PATCH 6.6 245/267] Revert "fork: defer linking file vma until vma is fully initialized"
Date: Wed, 19 Jun 2024 14:56:36 +0200
Message-ID: <20240619125615.725077029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam James <sam@gentoo.org>

This reverts commit cec11fa2eb512ebe3a459c185f4aca1d44059bbf which is commit
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
@@ -727,15 +727,6 @@ static __latent_entropy int dup_mmap(str
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
 		vm_flags_clear(tmp, VM_LOCKED_MASK);
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
@@ -752,6 +743,12 @@ static __latent_entropy int dup_mmap(str
 			i_mmap_unlock_write(mapping);
 		}
 
+		/*
+		 * Copy/update hugetlb private vma information.
+		 */
+		if (is_vm_hugetlb_page(tmp))
+			hugetlb_dup_vma_private(tmp);
+
 		/* Link the vma into the MT */
 		if (vma_iter_bulk_store(&vmi, tmp))
 			goto fail_nomem_vmi_store;
@@ -760,6 +757,9 @@ static __latent_entropy int dup_mmap(str
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
 			retval = copy_page_range(tmp, mpnt);
 
+		if (tmp->vm_ops && tmp->vm_ops->open)
+			tmp->vm_ops->open(tmp);
+
 		if (retval)
 			goto loop_out;
 	}


