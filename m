Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792B8324B37;
	Mon, 27 Oct 2025 19:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593288; cv=none; b=ndlUl3rH7BvnIQbacqX+/UGc9yHMyINzolN9THbnE5hj3LVM05wvix6Yy55eIj7mTxq0o3HaLd/2NkMssJykikW6FbZChRai4dPlbLuxqK1RsTZ6eyYzFZwnKuTOPrHASR5PmC3l3gZ2PgDcO08pVFdaHjMZKV2zcR3pg0/grU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593288; c=relaxed/simple;
	bh=Sz+n876W0MOY/YYG6vzBs8BmVfuWIcsAWwIvOhQxUhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0/T1w6izDGUNqYvyDtBLjOTRK8XdvegyQq+oXQOnAvQRG5nnBouR4EgxvPbGSTgnn2d4xmb3nHmyvGQ/oItApiOKQgWDNyNxajkIYgvCxfzssgvTR0QZPUx8Wj0PK0KrPlMDl11ch3nSfUjamKS7lMZDpTbnp93UD3yNBXUWcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE/wcT1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE/wcT1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D431C4CEFD;
	Mon, 27 Oct 2025 19:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593288;
	bh=Sz+n876W0MOY/YYG6vzBs8BmVfuWIcsAWwIvOhQxUhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mE/wcT1LOb1ZBwU3G5plXGTgNRytYv0c2diur05i+CaqMxbr9JprlPAJbZMA/Xhp7
	 fUXTEIispibAB7r4I1MRGNwdDwihw5d1Qb84+0Cl3npanTrJEgfz+AhqEfgedjECty
	 X7tEZIy7UlnrXyWw+MG0Pm7XMcuy28bCPpIt5AfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.17 086/184] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
Date: Mon, 27 Oct 2025 19:36:08 +0100
Message-ID: <20251027183517.212593284@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit b98c94eed4a975e0c80b7e90a649a46967376f58 upstream.

The arm64 copy_highpage() assumes that the destination page is newly
allocated and not MTE-tagged (PG_mte_tagged unset) and warns
accordingly. However, following commit 060913999d7a ("mm: migrate:
support poisoned recover from migrate folio"), folio_mc_copy() is called
before __folio_migrate_mapping(). If the latter fails (-EAGAIN), the
copy will be done again to the same destination page. Since
copy_highpage() already set the PG_mte_tagged flag, this second copy
will warn.

Replace the WARN_ON_ONCE(page already tagged) in the arm64
copy_highpage() with a comment.

Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: stable@vger.kernel.org # 6.12.x
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/copypage.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -35,7 +35,7 @@ void copy_highpage(struct page *to, stru
 		    from != folio_page(src, 0))
 			return;
 
-		WARN_ON_ONCE(!folio_try_hugetlb_mte_tagging(dst));
+		folio_try_hugetlb_mte_tagging(dst);
 
 		/*
 		 * Populate tags for all subpages.
@@ -51,8 +51,13 @@ void copy_highpage(struct page *to, stru
 		}
 		folio_set_hugetlb_mte_tagged(dst);
 	} else if (page_mte_tagged(from)) {
-		/* It's a new page, shouldn't have been tagged yet */
-		WARN_ON_ONCE(!try_page_mte_tagging(to));
+		/*
+		 * Most of the time it's a new page that shouldn't have been
+		 * tagged yet. However, folio migration can end up reusing the
+		 * same page without untagging it. Ignore the warning if the
+		 * page is already tagged.
+		 */
+		try_page_mte_tagging(to);
 
 		mte_copy_page_tags(kto, kfrom);
 		set_page_mte_tagged(to);


