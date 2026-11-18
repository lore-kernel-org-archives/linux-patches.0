Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036478;
	b=Jl1nyP7mqoOnfqIsuv+3E/VwViDs94qhjZGdnnnKBPxBqOUXV9LQd9Tdw8Ab/QIoWWVu
	 irn8BNlBe0MhC9jts3zxyXAddKIs8GPIjERyfCKzdO7YRq2ouOWDw4tYmnt4LZKCx04Vo
	 l1mudNrvXDsLfmyIxqnoO3uwMOD8TtAkXh+8x8N2hlfGYDrVfShsPa0057HIik+Xco/xl
	 A4ohcs+jvzUa5Y2LR9wpo8XhA6lrtWlE+kwQ2FyOzkYKzQ+RJtnJ+UyKjFYIfFoNRZYzm
	 sOXzisMFXflYGOw7RYpXzZc+Wm3n11pdo9NeaVv7U1ubDw69w1owOxxi/+wWhkCV7HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h6H+DPe4gWm4D2e5o54V3nBlEk9t1gHizZtsp+T63uY=;
	b=b11TkaGWyuJBM9OjosSWArOEW8FJQmVlqnAYUoCdMy6w7kbLICA1sQbCCHVNWZM5xoJF
	 xbJ0jh/An+Xmq5JD3U46HaSZlzzKpdFxvgzpabz159epjvEBuzn+mJf/tgh9dU6pU5BqR
	 jtvbvLIyTosMZaS4+0ir3f/C4KKRBg3g71OForJnsWmz6Ic6mBa7QVYhirLqC9DsZQ9h3
	 bjpWIAcc8HKtqNxVWiDQg+4xGDBFyiTp2zqP/lmWPxtx0blEkt+ZeabPob3BX0eP3QMCX
	 2smklWjYEx0icv1uhZsAMvdrdl36rXDTudLqnqrV7He0oQLAutZXxnk8UG3Qe04BdUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9XnPtOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2796C606A320;
	Wed, 18 Nov 2026 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9XnPtOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5BF1F000C4;
	Wed, 18 Nov 2026 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036478;
	bh=h6H+DPe4gWm4D2e5o54V3nBlEk9t1gHizZtsp+T63uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9XnPtOSwc6l6CtYRQHDmAndEub3zAwwSJQQuabJY7wBd/XLNbL9hilje+9B1y+ED
	 9LpYeRon3w/oZz+JGNuBP3mJk2PAySSb3wOnKU6gfe/+ehnCP/NWxdRZ+OdCNuth/p
	 MoFeH0uNw1MHhU1CNCrr7jfhhIn0Zkfp7Vrt4W64=
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
Subject: [PATCH 6.6 1075/3318] mm/hugetlb_cgroup: move per-node usage on cgroup reparenting
Date: Wed, 18 Nov 2026 15:28:17 +0100
Message-ID: <20261118150352.218262891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f256718983bb1..41f7b3889474a 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -240,6 +240,8 @@ static void hugetlb_cgroup_move_parent(int idx, struct hugetlb_cgroup *h_cg,
 	/* Take the pages off the local counter */
 	page_counter_cancel(counter, nr_pages);
 
+	hugetlb_cgroup_move_usage(h_cg, parent, folio, folio);
+
 	set_hugetlb_cgroup(folio, parent);
 out:
 	return;
-- 
2.53.0



