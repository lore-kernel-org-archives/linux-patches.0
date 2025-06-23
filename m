Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85EFC2E0;
	Mon, 23 Jun 2025 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714292; cv=none; b=alaD0FVbvd48fk7tt5vd40nW348/BpoePPZ98wYUXpNnXPY/32nhwqECYsL63L7vkvSAdTnCrpLr5MX9lDADxbimOPROC/guiGB400B00oFafIyxVlgn5ZbXGS/EG9SsIEGCMx8iHx6cKMc/2a3eRyYOK+eWscQ0SLs+pbWJA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714292; c=relaxed/simple;
	bh=9NGdw5DeSX20CyUdUJtBdSYycmxhpWS6LEjkWn786OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGLNqyBtJHawCVAm9UUDwHsB2OJbCQkSFw9ybLytxqk1TA9K8dhanbRKcxbKvGjqwZqtTgb9QoI8sEFH1v2UghhHtddtl9JIzV2RPjxmX8hMVOB2O1si/f8Sc75G0fzakf3lQIWfjo+aU436tm/F66daKAAra6Gf6Eggl31tWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFVQFI/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFVQFI/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C14CC4CEEA;
	Mon, 23 Jun 2025 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714291;
	bh=9NGdw5DeSX20CyUdUJtBdSYycmxhpWS6LEjkWn786OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFVQFI/SiqaKo3OvIdFoBEt5veFjHwkBZ7KcfYvXH2Mxe4iM7b4YnvLpq8ANp1bhD
	 N+/BqDi8nU96607BZtzngAuBpeIUfiB/o9WlCBswp7xRIsb5KJD31RPowy1I5jZASn
	 cw00MwkaKpIaCIrT8xgkQJtdw83N1Bju4cbGsnoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	syzbot+a2b84e569d06ca3a949c@syzkaller.appspotmail.com,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vasiliy Kulikov <segoon@openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 197/355] ipc: fix to protect IPCS lookups using RCU
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130632.592209791@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit d66adabe91803ef34a8b90613c81267b5ded1472 upstream.

syzbot reported that it discovered a use-after-free vulnerability, [0]

[0]: https://lore.kernel.org/all/67af13f8.050a0220.21dd3.0038.GAE@google.com/

idr_for_each() is protected by rwsem, but this is not enough.  If it is
not protected by RCU read-critical region, when idr_for_each() calls
radix_tree_node_free() through call_rcu() to free the radix_tree_node
structure, the node will be freed immediately, and when reading the next
node in radix_tree_for_each_slot(), the already freed memory may be read.

Therefore, we need to add code to make sure that idr_for_each() is
protected within the RCU read-critical region when we call it in
shm_destroy_orphaned().

Link: https://lkml.kernel.org/r/20250424143322.18830-1-aha310510@gmail.com
Fixes: b34a6b1da371 ("ipc: introduce shm_rmid_forced sysctl")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reported-by: syzbot+a2b84e569d06ca3a949c@syzkaller.appspotmail.com
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/shm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -417,8 +417,11 @@ static int shm_try_destroy_orphaned(int
 void shm_destroy_orphaned(struct ipc_namespace *ns)
 {
 	down_write(&shm_ids(ns).rwsem);
-	if (shm_ids(ns).in_use)
+	if (shm_ids(ns).in_use) {
+		rcu_read_lock();
 		idr_for_each(&shm_ids(ns).ipcs_idr, &shm_try_destroy_orphaned, ns);
+		rcu_read_unlock();
+	}
 	up_write(&shm_ids(ns).rwsem);
 }
 


