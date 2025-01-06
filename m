Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D5158525;
	Mon,  6 Jan 2025 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178036; cv=none; b=J7ENeNOaO7FJfFt6DC5yy1erpaoYG1z4pWvvTRfczd0in/OgWYza4hI8vkk92BxVso52la2w4F3jg9E53+uX1blqAurSHicjfCgcRBds1S0e7tSg5Dj4XjiIxD53ZtAoShgpterFzG83SMRrXwfnKBUh7SyYv182jcGCwofE8Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178036; c=relaxed/simple;
	bh=DWmFGKgJvUpdhirTolfVIj3LUhrjKXr4wrpUjocZQQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkP5yYa5PUjbDugnPrQsbhWPpzHlCmw+nOMCPNzaYBafjcwbkdkCv2HlAJxQKaqxkm0sioPKBhAEhHr0bM2XTftN2ke4HVNMAOTawN9ykzz5WcNVuoQFlVYchWtOvQnX6jFiPlGGpJUNmW/MSHG5W/kAbICXnuM7wAmH9Rfjmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcSZSJGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcSZSJGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5233EC4CED2;
	Mon,  6 Jan 2025 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178036;
	bh=DWmFGKgJvUpdhirTolfVIj3LUhrjKXr4wrpUjocZQQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcSZSJGq2foMIL51jM9P++VbPsQ44mKX5w7BPOtpTElpHmIdWZb18IAQN+/SSOFiR
	 Tuwv5MFMbRYnwMsPr9DqliSYNxJ5nOmWEx8QFDy44HeVGlqqsMrwkQ2v+938NSthb+
	 Rl6neHb4UPrujWv4nhg9E6nPRP9WNBSPtIbKPgqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 140/156] mm: shmem: fix the update of shmem_falloc->nr_unswapped
Date: Mon,  6 Jan 2025 16:17:06 +0100
Message-ID: <20250106151147.003077942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linux.alibaba.com>

commit d77b90d2b2642655b5f60953c36ad887257e1802 upstream.

The 'shmem_falloc->nr_unswapped' is used to record how many writepage
refused to swap out because fallocate() is allocating, but after shmem
supports large folio swap out, the update of 'shmem_falloc->nr_unswapped'
does not use the correct number of pages in the large folio, which may
lead to fallocate() not exiting as soon as possible.

Anyway, this is found through code inspection, and I am not sure whether
it would actually cause serious issues.

Link: https://lkml.kernel.org/r/f66a0119d0564c2c37c84f045835b870d1b2196f.1734593154.git.baolin.wang@linux.alibaba.com
Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1527,7 +1527,7 @@ try_split:
 			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
-				shmem_falloc->nr_unswapped++;
+				shmem_falloc->nr_unswapped += nr_pages;
 			else
 				shmem_falloc = NULL;
 			spin_unlock(&inode->i_lock);


