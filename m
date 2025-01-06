Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DC51DB546;
	Mon,  6 Jan 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177587; cv=none; b=AtMXFj2tegSJIX2l50pzPvFetM+E/NqZPmQXJla/7plFBC8CG7wuWwLX03Jse0YIFGhZXETar+0qRCR0XHKyLWRujPgBSUepd79uA3jyLxLMNUFKAFCCmrnKF0IKohYOqtWKuvOtRSCBTrRET7612rVLodN0/pOwg1FNGov2P00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177587; c=relaxed/simple;
	bh=FqJ5jOBH0UsAmFsV7wQMe/rBNbUHpDj/j7K3BIpiBbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7vDtxcLevDwobQE5QRSmfIbqNQhFcFbPx3RCKL1HkHpYxstaZtrgCthtXMMKNeOzmGGMWnE2Uf2RhkFzxwdDtSy1PJ3irKjrT2I48kSA0+fxX/5ELEve0Hy9Wm3mnBkn1fkSUkq2bB6wFWiBBYKDmXlDq91zTDl2cB0yF0g40U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4zBd7N4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4zBd7N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4954C4CED6;
	Mon,  6 Jan 2025 15:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177587;
	bh=FqJ5jOBH0UsAmFsV7wQMe/rBNbUHpDj/j7K3BIpiBbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4zBd7N4xNCKyIKrO6G3if458AHkZ76zpPxS+TZM5+pDCCZDH+uPAPdd/hG8mTtLG
	 1hw5avEznlJABxT8wEzpY6T+28vXidYWllKj9OClkZhUw8BZ7KgRqkgHwNc+f9EVSP
	 Ehjsnro598dclbHq9I7gE/4Q13WeQE1dqivCsmc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 212/222] fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit
Date: Mon,  6 Jan 2025 16:16:56 +0100
Message-ID: <20250106151158.791098857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

commit 3754137d263f52f4b507cf9ae913f8f0497d1b0e upstream.

Entries (including flags) are u64, even on 32bit.  So right now we are
cutting of the flags on 32bit.  This way, for example the cow selftest
complains about:

  # ./cow
  ...
  Bail Out! read and ioctl return unmatched results for populated: 0 1

Link: https://lkml.kernel.org/r/20241217195000.1734039-1-david@redhat.com
Fixes: 2c1f057e5be6 ("fs/proc/task_mmu: properly detect PM_MMAP_EXCLUSIVE per page of PMD-mapped THPs")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1516,7 +1516,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 			flags |= PM_FILE;
 
 		for (; addr != end; addr += PAGE_SIZE, idx++) {
-			unsigned long cur_flags = flags;
+			u64 cur_flags = flags;
 			pagemap_entry_t pme;
 
 			if (page && (flags & PM_PRESENT) &&


