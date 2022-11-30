Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3155E79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA109C433D6;
	Wed, 30 Nov 2022 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834340;
	bh=YDrjMdH5rSQYcDqKtDE6mnnLUWZkTUoWFVA7oM54EwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRGXWsI+5hugFAr12zk8MnZwuoMqCBgffZLophUSn+qX2oHqchfJHk19JuSEEqzB2
	 Oy3BVcju7z0oRfyhMJibPmTrqBJmDBg/Q1qXatdJAvEAEDxz3gfo5A4re8lCXcqiW8
	 jpjqleC2HGqvf/g7ZZXX/1M/5AT0k7dSorpQwYSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Liguang <liliguang@baidu.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 217/289] mm: correctly charge compressed memory to its memcg
Date: Wed, 30 Nov 2022 19:23:22 +0100
Message-Id: <20221130180549.038053487@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Liguang <liliguang@baidu.com>

commit cd08d80ecdac577bad2e8d6805c7a3859fdefb8d upstream.

Kswapd will reclaim memory when memory pressure is high, the annonymous
memory will be compressed and stored in the zpool if zswap is enabled.
The memcg_kmem_bypass() in get_obj_cgroup_from_page() will bypass the
kernel thread and cause the compressed memory not be charged to its memory
cgroup.

Remove the memcg_kmem_bypass() call and properly charge compressed memory
to its corresponding memory cgroup.

Link: https://lore.kernel.org/linux-mm/CALvZod4nnn8BHYqAM4xtcR0Ddo2-Wr8uKm9h_CHWUaXw7g_DCg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20221114194828.100822-1-hannes@cmpxchg.org
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Li Liguang <liliguang@baidu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2971,7 +2971,7 @@ struct obj_cgroup *get_obj_cgroup_from_p
 {
 	struct obj_cgroup *objcg;
 
-	if (!memcg_kmem_enabled() || memcg_kmem_bypass())
+	if (!memcg_kmem_enabled())
 		return NULL;
 
 	if (PageMemcgKmem(page)) {


