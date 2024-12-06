Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FE31494D9;
	Fri,  6 Dec 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496292; cv=none; b=JaymIVue9+aGUPYAPhNXKcBSgObGoVrnkB9wl/AvOBOBhhSzi5inO1y4xLxKBP2c+io/ak3kny/YagReAGxmYF6VxlKCtqrGqXZgpsOf1DZg/QiJrExvjWX3MTKThfVhP6Ywgu3qJvG1EiH504JxF7jC9wfMAD3S2pRCZ7KHvtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496292; c=relaxed/simple;
	bh=Ja9hVR/ATTFKnYeu7DzKO/1I0kngEQTumNVHiyD1Jzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh8uHdMz1fU2+iE0A5sbr1VXo48ua1IyaMDGt5Egi6P9u7jYCH3UvSADwBeIz3vVBvvBCgJw+uFYNKhH67JBrbSdwoGvOvI4YsAyXsZGuN5zIZ36TEFsEiC66pEvD+tTrssU3b6VzYIoKJkOF/OZLTN1OqcCml7W4+gemrbMTEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqWjSzsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqWjSzsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A140C4CED1;
	Fri,  6 Dec 2024 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496291;
	bh=Ja9hVR/ATTFKnYeu7DzKO/1I0kngEQTumNVHiyD1Jzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqWjSzsMwCDKPsp8H6bzihRtyJe8FLYtAHVEZJIVdDUfK2fQqUWAPbXFuC+aex/Lv
	 AXdRZu5jOfPotbyzsf6QlOLBXEfQ3CE5tCrdrktuzBWC6AMac3ORYcGyLN+z22+ZR9
	 z1hMCdetf7Ky9gWlgkEj+8x/nz//wupQc+3YPI/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Todd Kjos <tkjos@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 109/146] binder: fix OOB in binder_add_freeze_work()
Date: Fri,  6 Dec 2024 15:37:20 +0100
Message-ID: <20241206143531.854043542@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Carlos Llamas <cmllamas@google.com>

commit 011e69a1b23011c0db3af4b8293fdd4522cc97b0 upstream.

In binder_add_freeze_work() we iterate over the proc->nodes with the
proc->inner_lock held. However, this lock is temporarily dropped to
acquire the node->lock first (lock nesting order). This can race with
binder_deferred_release() which removes the nodes from the proc->nodes
rbtree and adds them into binder_dead_nodes list. This leads to a broken
iteration in binder_add_freeze_work() as rb_next() will use data from
binder_dead_nodes, triggering an out-of-bounds access:

  ==================================================================
  BUG: KASAN: global-out-of-bounds in rb_next+0xfc/0x124
  Read of size 8 at addr ffffcb84285f7170 by task freeze/660

  CPU: 8 UID: 0 PID: 660 Comm: freeze Not tainted 6.11.0-07343-ga727812a8d45 #18
  Hardware name: linux,dummy-virt (DT)
  Call trace:
   rb_next+0xfc/0x124
   binder_add_freeze_work+0x344/0x534
   binder_ioctl+0x1e70/0x25ac
   __arm64_sys_ioctl+0x124/0x190

  The buggy address belongs to the variable:
   binder_dead_nodes+0x10/0x40
  [...]
  ==================================================================

This is possible because proc->nodes (rbtree) and binder_dead_nodes
(list) share entries in binder_node through a union:

	struct binder_node {
	[...]
		union {
			struct rb_node rb_node;
			struct hlist_node dead_node;
		};

Fix the race by checking that the proc is still alive. If not, simply
break out of the iteration.

Fixes: d579b04a52a1 ("binder: frozen notification")
Cc: stable@vger.kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20240926233632.821189-3-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 4d90203ea048..8bca2de6fa24 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5593,6 +5593,8 @@ static void binder_add_freeze_work(struct binder_proc *proc, bool is_frozen)
 		prev = node;
 		binder_node_unlock(node);
 		binder_inner_proc_lock(proc);
+		if (proc->is_dead)
+			break;
 	}
 	binder_inner_proc_unlock(proc);
 	if (prev)
-- 
2.47.1



