Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8193FD4;
	Mon, 23 Jun 2025 21:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715235; cv=none; b=cc48DHSbBIyS1/x8fM3NG/xWHypL/VL1M9aZQnFDQObrBAa6V2uGcD7pev0IFEMSzr5psdYHf1Y0Nqlctyme0XmPw8+FJ5aoHPvtsqezqBREpVHtuiYWSGYhytgzikHXE8FdfMaO6Uo2ecDv4iJatvJAChvcfoWhdfmSnLF2nGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715235; c=relaxed/simple;
	bh=7QCIAh3fvlk+yX8a9jTzWORE8AQGyO0D9YlVo+xYBkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoWgDTgpjKsVnlRUdCoGFXY7pB/NIRwZ/MMVzXFSZMv2ztn2VKF4ghm/fTgkFSEkmioZNVMpHWSTr39REN8W3Cbo8GEnCWk/vhLE3ZecxgeaWm7WwiBhWjo58y4ib9g+JNBRQg7TPwZzY0cDQxtdrThwIzIIX4xND4StYVchL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onxaT244; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onxaT244"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C62C4CEEA;
	Mon, 23 Jun 2025 21:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715235;
	bh=7QCIAh3fvlk+yX8a9jTzWORE8AQGyO0D9YlVo+xYBkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onxaT244F4g1bSu7MIxnysU1SP6pFmF2crjMYZLXW3h5L5xCxZxIKQZq1orm9DNIp
	 sU3bIkEwjCirnhtG0zpK0zBmQd6Shp5306GzmxNMKkLQgLkI8CDvgJn//tgI+FfN4j
	 prK7bKaaMp/h/+4VTKTRoujMsoFZ9aJhXrUyay3s=
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
Subject: [PATCH 5.15 240/411] ipc: fix to protect IPCS lookups using RCU
Date: Mon, 23 Jun 2025 15:06:24 +0200
Message-ID: <20250623130639.697106544@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


