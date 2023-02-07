Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0322C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A30AC433EF;
	Tue,  7 Feb 2023 13:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775163;
	bh=LjL0IUvyKFfBRJVVBvhcjv3LNCu44CpAtCOpOOH9yCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXx9id2WSWOmKPgzcFbC2QH422eTDbN3o1TdllmaqBt27odsZSb5dTj3Ti8TlIE0L
	 Dtb//e7HJfCSbnuegUbwiu3bYO2azuak+l3ZCcZ+Yb77S+QNI5qnIv839hYxhRNBdP
	 pAKX0OYQmT61mxo3+1W0bzW1Od2y/edjZMmx8OUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Miko Larsson <mikoxyzzz@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Shakeel Butt <shakeelb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 158/208] mm: memcg: fix NULL pointer in mem_cgroup_track_foreign_dirty_slowpath()
Date: Tue,  7 Feb 2023 13:56:52 +0100
Message-Id: <20230207125641.605762237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit ac86f547ca1002aec2ef66b9e64d03f45bbbfbb9 upstream.

As commit 18365225f044 ("hwpoison, memcg: forcibly uncharge LRU pages"),
hwpoison will forcibly uncharg a LRU hwpoisoned page, the folio_memcg
could be NULl, then, mem_cgroup_track_foreign_dirty_slowpath() could
occurs a NULL pointer dereference, let's do not record the foreign
writebacks for folio memcg is null in mem_cgroup_track_foreign_dirty() to
fix it.

Link: https://lkml.kernel.org/r/20230129040945.180629-1-wangkefeng.wang@huawei.com
Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: Ma Wupeng <mawupeng1@huawei.com>
Tested-by: Miko Larsson <mikoxyzzz@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1655,10 +1655,13 @@ void mem_cgroup_track_foreign_dirty_slow
 static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 						  struct bdi_writeback *wb)
 {
+	struct mem_cgroup *memcg;
+
 	if (mem_cgroup_disabled())
 		return;
 
-	if (unlikely(&folio_memcg(folio)->css != wb->memcg_css))
+	memcg = folio_memcg(folio);
+	if (unlikely(memcg && &memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
 }
 


