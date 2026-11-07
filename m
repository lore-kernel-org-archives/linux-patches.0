Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063338;
	b=hyYE7QxqoLqdAaVpTHn49IQaK0M7VPlPY4g006z0CK7Esr1ic4CpUbyDdHtqCs3njXnX
	 iIre75oaGrh0Tm+h1Qf8nUKPtKEW+zxOt3GuumEmb+ir/9hdaRrpzNdDYp0jLYUM/N8yV
	 3XjfvJ7h/0AOoIAVR/LOaxVbJFDOnyx9/vsT0LZJvtJZN/EHYlIRwDeI25QYCPShwJ2I6
	 wWoSFnU+d+Egvqo3Yhe7pCPvaJz9SlmwJIFjYdnyfm3qTyE8cUB7rg41gy4VmK1/rK83c
	 9NdWYGKO4r1RQHsZwcrsXSJjSDC339qN5fSdo97l76V5IY/4zIwRr8Fa67M2AJRS0gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eONuHqHHw0RgUjXf6ZtK34mng2ovVZTJJ7Ew1ctvGRw=;
	b=0iI6Do4EAiQZwToe21fmK+f7BJhjFCMDOu5rqXgT0VYzGn2GK5mA7zBojnCuuOoRN9cT
	 /umVZglcbUEnVgV2UprrLSqlzBoRMy2suEAr9JFQZEfCuGDDwhhMW6eCqDntATwu7z12C
	 PjiJLvRhiGoe5SqdiOqmW8zjM6RazEWX7WXxoXT20t8bM3j0A7vFesjwhH0WkmgI08hMF
	 PURrl9hXoesivbK8abXnYGUXlwQ3kjlWzKLZImyaJR+dshgNLOOgZA2rPaKDv1OoC2Jl5
	 HLaQ4uahBbvg0URvkZCGHw4E9o/ft5gwBl6b3yJUU9ZvnCeUHLHkszi9F4Ca98MdhZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn3x1r49;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0A6606A32C;
	Sat,  7 Nov 2026 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn3x1r49
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356411F0089F;
	Sat,  7 Nov 2026 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063338;
	bh=eONuHqHHw0RgUjXf6ZtK34mng2ovVZTJJ7Ew1ctvGRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn3x1r49rU836KjyLEGrGAHOS8gSX29Sk0qKEgz3aKm/SSfUsu8JMSd0r1Tmla+d1
	 9SZgqjQEwvR/8U4Wg/NGUpNIs72e3tYVy+EUM7opHjoN6CIGdl2aDhfjrX/FTrKbDK
	 3kwPKl4ddovccBX49zd5DqxaUiutAVYfRUsEhzN4=
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
Subject: [PATCH 6.18 483/869] mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Sat,  7 Nov 2026 08:52:45 -0500
Message-ID: <20261107134909.962252598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 00b20c4ff222f..7c59c20d68574 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -249,6 +249,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
-- 
2.53.0



