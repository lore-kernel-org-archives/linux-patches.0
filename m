Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062353;
	b=K7lvgfd265PJ1j8g4jC6SitLe8dczHgN5cpXU4VjW+9mNNTG+VPh3ScgyyhJacZnBCcb
	 uVItPErdER7Q6njae+mtyN+FdSVGpcPevQrWJOLGzhk9T7ji7sM36YI/ZpVmBtA+195A9
	 pWW6CPJlaM3DV7Gg6QZRhxVwr/l99FnUn7vVXnpYSJXMIufST/kNTmDHrZL+0LGAbuNOp
	 4XzEC06mDvln/JqnEmzVJHpO5JFUBQC0uBuXYBXy7YyzD5eOfjKdrrSLdpv4Uei2XnNpe
	 aYie6bPKo8mtnkQk4MChkl4WnX1MaegxqZ/YykA8Rv/qY3jUEGEE6/WzlFDQnS0Knsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=83r4Ipd9xfUytwN6QIL5qu4Usv/Z06W1MkO0bRHMzI0=;
	b=dNlDxnjibP9u5pCaJBJMF7hLLd6aXg5PbHfw2HS7jy77P10hnvS2eDyC3NGBlQMNg8D+
	 IkJOYreodAyMGn1g41mFoL9DpFr37A79uSBY0LfSM3lPfE6ge87XwTqZ/DynOa13c0Q8t
	 JkgQdSrNGvADRYFpEIzjRp77T6EuLrnpkK2JJ21KqkeU6VD6gIM3r/17xi+ZRfAdbL7WW
	 jSkbVYL6ZPyw9UlgoqtyJeA+j+SI2aEfmbFuyzHksywzkAoe2oYbJ2dZehCn7O2URj6uF
	 BjiBLI68pP/uVyruRnpt+4/uOkhZdSG2HcvDWLTJjHdJNRwl6N1UbCSmu9ANk2AodZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNUfzqjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A6E606D82D;
	Sat,  7 Nov 2026 14:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNUfzqjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC921F0089F;
	Sat,  7 Nov 2026 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062353;
	bh=83r4Ipd9xfUytwN6QIL5qu4Usv/Z06W1MkO0bRHMzI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNUfzqjKup4Phw7Cs/wXvrLFijyNkL43c8g792TzU7uwPuWoZXJdshEcv8uEr1Zo5
	 AgIG9oroDrwx87pWY88nBWFUsFSrCDoAWgF6WnjHAc0liN00iGSdbN+AUcv0EsJNB3
	 yHmtXEbeyYt/ZWLMeHSHTvEy+hGLU8k1mBHjI9sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1242/1536] mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Sat,  7 Nov 2026 08:54:18 -0500
Message-ID: <20261107135032.644092844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 23fac055c21176f66ed453394b533bdfc00f7fba ]

hugetlb_cgroup_css_offline() hands the folios of a dying cgroup over to
its parent with hugetlb_cgroup_move_parent(), which moves the page_counter
charges and the hugetlb_cgroup pointer of the folio but not its per-node
usage.  The parent's hugetlb.<size>.numa_stat is short by that usage while
they are charged, and underflows once they are freed, exposing incorrect
per-node usage values to userspace.

Move the per-node usage to the parent as well.  The folios keep their node
here, so only the cgroup which holds the usage changes.

Link: https://lore.kernel.org/20260918-for-hugetlb-charge-v2-2-2b6d8c2bdc36@kylinos.cn
Fixes: f47761999052 ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index c592cba90f464..0d051f5d69ce7 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -250,6 +250,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
-- 
2.53.0



