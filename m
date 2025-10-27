Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A63254AC;
	Mon, 27 Oct 2025 19:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593062; cv=none; b=BJNiemGQJ6PF0aIec1bHOKNqw+a6TNn09zY1k9cyc6qhqMFTldhMkt+H7eEU9Ci96HPbbiTBbsRMH1+i+47jlk/EuqLIfIeYJlrjyQtX6JG7T26jrK90kihUSdBigNFdujCo77dYuvLjKiPyGSK2p0/9EP3X4Bu/FpLOGy4oAPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593062; c=relaxed/simple;
	bh=nq3NIesUxwtP9CON9n+aPatGkYNqXUKOzSr2Z+HcXfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnZbHfu3OfI9IMnLzU2vuKYQwqXWN9Pm+Yqp0Slk4wl8EjcbHEmjLoM5orMkAB0OiY6O/HdgyswVoRLUp6syXwoZP9vRcIxIL1gl1UpM324y+INTJPKuxzEH0o71c/HE8rZsTm6vl1vb8+qdOe9wrdR9hWg26/sgHli0/23kPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sbwzi788; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sbwzi788"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BB8C4CEF1;
	Mon, 27 Oct 2025 19:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593061;
	bh=nq3NIesUxwtP9CON9n+aPatGkYNqXUKOzSr2Z+HcXfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sbwzi788mq71xf9BVUOOp8OXBJLIZlwIMogo9CEfaChCwmy5VClZId5gGa9mIb8x9
	 73mHEkzYtvHlLGH7Ony+txL295fdNyjgxKORpxoVlEaNAZcybnHA+yQUzbfbuQMjQJ
	 USmGw0Tg+pGI5LeLhWydc46RexRM5MeGsiSi3oas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	David Hildenbrand <david@redhat.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/117] arm64: mte: Do not warn if the page is already tagged in copy_highpage()
Date: Mon, 27 Oct 2025 19:37:22 +0100
Message-ID: <20251027183457.167468082@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

[ Upstream commit b98c94eed4a975e0c80b7e90a649a46967376f58 ]

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
[ omitted hugetlb MTE changes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/copypage.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -25,8 +25,13 @@ void copy_highpage(struct page *to, stru
 		page_kasan_tag_reset(to);
 
 	if (system_supports_mte() && page_mte_tagged(from)) {
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
 	}


