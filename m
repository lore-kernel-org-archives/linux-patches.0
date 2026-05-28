Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A217318EE1;
	Thu, 28 May 2026 19:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998076; cv=none; b=lRCjK7S6HMhLNGnqYWrYAf4kJ1JrC7crm/aAAAA3uaSLQ3dJoLOWevsUvVZXhx4KJFmIaU2qPDo3C3tHkG7eqiCWDp6deQIfS/3ha6EPc33q8P2Aek2sKaDnUyRrmLlMleotP0hfDnmMWzZyGWF6GNSGWXisztYhp1jGxy8esfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998076; c=relaxed/simple;
	bh=2I8VVqoeZvx0bGV6lRvYGPG3y9HYsJFuZYPBtQ4COAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js6riF6rTz2Gmua6WM8ujv5hA2AmAqQnui9xDqERU98UMitq/n+n+il6u8Hcgv9DYoQEVkyo16Kxn/DHXu2pP/vAYN+1tsdSTChYHjbbYHtsGEWBpTOb+sGPeJByDODJiJl4j56Dz2THY6Rgbbh5MzHywhqQ5hLR7o5cMuTx6xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAHCdiL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAHCdiL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EC81F00A3A;
	Thu, 28 May 2026 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998074;
	bh=/oiXbXNF3eFUfFBsR5GYjgcwaZl2zXD1sO/9CMSbU/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sAHCdiL95qxZRRBntKQ5R0iNVpwKmOiFrBGwYXLmAWGfN1K9uWm87NmKoG3PZrwqR
	 WYWogHN+o1+fsX02ynFBW8+GWMpf0OC0y84aGG7YxRTUoDsWak2ULwcJwG7tWsgzJg
	 r8XvHS/fnPipkH0E3lDgI5TD7/X18Q0D4lWdXQV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunny Patel <nueralspacetech@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>
Subject: [PATCH 7.0 037/461] mm/migrate_device: fix spinlock leak in migrate_vma_insert_huge_pmd_page
Date: Thu, 28 May 2026 21:42:46 +0200
Message-ID: <20260528194647.970403863@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunny Patel <nueralspacetech@gmail.com>

commit 63451de16e0a08be40f9ab5e7c5c8f5c79676fb1 upstream.

When check_stable_address_space() fails after the PMD spinlock has
been acquired via pmd_lock(), the code jumps directly to the abort
label, bypassing the spin_unlock() call in unlock_abort. This causes
the PMD spinlock to be permanently held, leading to a deadlock.

Change the goto target from abort to unlock_abort to ensure the
spinlock is always released on this error path.

Link: https://lore.kernel.org/20260425133537.17463-1-nueralspacetech@gmail.com
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -856,7 +856,7 @@ static int migrate_vma_insert_huge_pmd_p
 	ptl = pmd_lock(vma->vm_mm, pmdp);
 	csa_ret = check_stable_address_space(vma->vm_mm);
 	if (csa_ret)
-		goto abort;
+		goto unlock_abort;
 
 	/*
 	 * Check for userfaultfd but do not deliver the fault. Instead,


