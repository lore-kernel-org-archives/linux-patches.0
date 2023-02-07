Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E142C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D309C433EF;
	Tue,  7 Feb 2023 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775157;
	bh=49eVP3VvglhYDyZ+MybjCp1gHpBrluq4dXb3TC50YQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUnqZYsLiBItl3Yg0d57KTdUdybS+AGOLe461aSoqAWEIMRkHYTj8VcRboRoLwzz4
	 jizKV0FeKcqUOWTPz6q7mPejfvIyqJwFlIs3e5/7Isv+hvvcZ5QO/Rd8kLjGfFvJ+B
	 0KedBIzvr5nM3RAeVzSgy5rTFwc5jPPOLEmtEp90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhao <yuzhao@google.com>,
	msizanoen <msizanoen@qtmlabs.xyz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 156/208] mm: multi-gen LRU: fix crash during cgroup migration
Date: Tue,  7 Feb 2023 13:56:50 +0100
Message-Id: <20230207125641.519933289@linuxfoundation.org>
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

From: Yu Zhao <yuzhao@google.com>

commit de08eaa6156405f2e9369f06ba5afae0e4ab3b62 upstream.

lru_gen_migrate_mm() assumes lru_gen_add_mm() runs prior to itself.  This
isn't true for the following scenario:

    CPU 1                         CPU 2

  clone()
    cgroup_can_fork()
                                cgroup_procs_write()
    cgroup_post_fork()
                                  task_lock()
                                  lru_gen_migrate_mm()
                                  task_unlock()
    task_lock()
    lru_gen_add_mm()
    task_unlock()

And when the above happens, kernel crashes because of linked list
corruption (mm_struct->lru_gen.list).

Link: https://lore.kernel.org/r/20230115134651.30028-1-msizanoen@qtmlabs.xyz/
Link: https://lkml.kernel.org/r/20230116034405.2960276-1-yuzhao@google.com
Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: msizanoen <msizanoen@qtmlabs.xyz>
Tested-by: msizanoen <msizanoen@qtmlabs.xyz>
Cc: <stable@vger.kernel.org>	[6.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3290,13 +3290,16 @@ void lru_gen_migrate_mm(struct mm_struct
 	if (mem_cgroup_disabled())
 		return;
 
+	/* migration can happen before addition */
+	if (!mm->lru_gen.memcg)
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(task);
 	rcu_read_unlock();
 	if (memcg == mm->lru_gen.memcg)
 		return;
 
-	VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
 	VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
 
 	lru_gen_del_mm(mm);


