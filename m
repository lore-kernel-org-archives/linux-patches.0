Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF0FD531;
	Tue, 14 May 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684199; cv=none; b=rEp+5TGefgMbCzmoMJm+ER4Ugh1kSOgt4yblOGdtXA/KNgfLDsQTidt8N/O/f9nHmLwBRvIv5PsOJzu9jf9IPJW5rjFb8Z3IA0oT0Cp7LTXCxv7rW6vh+YvsJBs8gvU8Xa1UNk5rdHNZvW+lTwoMbMTu3ROLwsSQbeq247akWgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684199; c=relaxed/simple;
	bh=bL9jNkWNmhpSTIHfYQm3hWiZJNf/DyVDr1GYDIJMyQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0AYdzytBFATrtN9oCYdEM6xZZup24BB0bBTVHep81jsnopQBm5lQJERzQA+3DUdEPyAg6oyE7Vnx/yuZ1j71kosquYkNE+ARiBFpxZJl2bA2cGfnUSmg0Y0W8smsPH8Ugnpy8yVrfDAQQe/IIUp5ryMPVn/Jd09vzeQ8PuK9U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19ZiBuKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19ZiBuKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6677C2BD10;
	Tue, 14 May 2024 10:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684199;
	bh=bL9jNkWNmhpSTIHfYQm3hWiZJNf/DyVDr1GYDIJMyQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19ZiBuKutZgr2uEvn8ddAu7fBilOAHJgNJq+qUNnQtgEmoEA0x/KzjJFQIXGgAjzP
	 iI0Ik/AbhlHB5caPjCvd3OwjCHceCCIQgGFwGyf4fhY3FK9Ep1UvpKmTIY1g86qepC
	 vbjy2Ox7dpT/mdhn4ypDEW/WcnpgR+qUNgtbJ+7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 317/336] fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan
Date: Tue, 14 May 2024 12:18:41 +0200
Message-ID: <20240514101050.588753452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit c70dce4982ce1718bf978a35f8e26160b82081f4 upstream.

make_uffd_wp_pte() was previously doing:

  pte = ptep_get(ptep);
  ptep_modify_prot_start(ptep);
  pte = pte_mkuffd_wp(pte);
  ptep_modify_prot_commit(ptep, pte);

But if another thread accessed or dirtied the pte between the first 2
calls, this could lead to loss of that information.  Since
ptep_modify_prot_start() gets and clears atomically, the following is the
correct pattern and prevents any possible race.  Any access after the
first call would see an invalid pte and cause a fault:

  pte = ptep_modify_prot_start(ptep);
  pte = pte_mkuffd_wp(pte);
  ptep_modify_prot_commit(ptep, pte);

Link: https://lkml.kernel.org/r/20240429114017.182570-1-ryan.roberts@arm.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1826,7 +1826,7 @@ static void make_uffd_wp_pte(struct vm_a
 		pte_t old_pte;
 
 		old_pte = ptep_modify_prot_start(vma, addr, pte);
-		ptent = pte_mkuffd_wp(ptent);
+		ptent = pte_mkuffd_wp(old_pte);
 		ptep_modify_prot_commit(vma, addr, pte, old_pte, ptent);
 	} else if (is_swap_pte(ptent)) {
 		ptent = pte_swp_mkuffd_wp(ptent);


