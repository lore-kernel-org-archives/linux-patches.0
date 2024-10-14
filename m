Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3601A76A5;
	Mon, 14 Oct 2024 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918703; cv=none; b=ewLWF4AnH8fT54USyP9tXDpjaKlHGHKHmIjN68c44+gL1tvnnXnLx6NH6Ev9vVuqC1Fe0Z9uR2BhJXtWWRqSMrTmUfuEzGslAjNO2rKA3QzxbCe5s0x9MOl6c4YNel+6cfS03Ra8OBaRb5gaBrSrI+MEraNw7crpVFczF4iyYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918703; c=relaxed/simple;
	bh=+npSUftHENNiJo77P/GLxyP+ndq61rwBpaf6g7A2/kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im3yH8mqENJSuWToBA7iz3leHlKjY/Xp3XP0dkuchvbHPaqeKVMDsLTm8CVDNim7QeP6dR1uQ65VSM+Is1wFG6mkd6TyWP4S2VWZXueqKKdh3zpMPYxW5sw+sfaYEYmMH3b7HLov8JDo98lJ2uUjnSO63oKJtw5jQAGM+msPrko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTFT6B9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTFT6B9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F30C4CEC3;
	Mon, 14 Oct 2024 15:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918703;
	bh=+npSUftHENNiJo77P/GLxyP+ndq61rwBpaf6g7A2/kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTFT6B9b0U8uJGmKfXgvvErcYiqD5Gdr3OHxrDoG+I1mt6HujYqENTy/SEMu38i1t
	 V69trmmABshQOkjOPJlQH1NTbdPgdLO2AJvt2aUpypd+yxs0ILRc7WGfPb90oBXwmB
	 2Y3mqpihxe7NCympw8Y7pzQ3hKptpinkbMj8FxY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	SeongJae Park <sj@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 367/798] mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock
Date: Mon, 14 Oct 2024 16:15:21 +0200
Message-ID: <20241014141232.367276087@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit fb497d6db7c19c797cbd694b52d1af87c4eebcc6 upstream.

Traversing VMAs of a given maple tree should be protected by rcu read
lock.  However, __damon_va_three_regions() is not doing the protection.
Hold the lock.

Link: https://lkml.kernel.org/r/20240905001204.1481-1-sj@kernel.org
Fixes: d0cf3dd47f0d ("damon: convert __damon_va_three_regions to use the VMA iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/b83651a0-5b24-4206-b860-cb54ffdf209b@roeck-us.net
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -126,6 +126,7 @@ static int __damon_va_three_regions(stru
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
+	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -146,6 +147,7 @@ static int __damon_va_three_regions(stru
 next:
 		prev = vma;
 	}
+	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;


