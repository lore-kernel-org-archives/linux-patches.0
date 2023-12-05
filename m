Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605EA6FB1;
	Tue,  5 Dec 2023 03:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P58qMkc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C1DC433C7;
	Tue,  5 Dec 2023 03:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747463;
	bh=eToqS1r2zF80+15yV03juJlT8qgqY3YzZPJLQcNMbME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P58qMkc2AIK601J59UeKC3Rt4oqhuxH2oTcHlBh+GKwA++yD0qSF94ZgSeSygBTYJ
	 uV/o4kiz3PCcZhvnyJQov1kIahFBxi9Gzo6DSD0rt1Ls2y/Dm2vtDnZv2ISigtKavx
	 AtfvyC0c3AqStkGn/zJuOylqeMjulStl72NQg+5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 061/135] bcache: fixup lock c->root error
Date: Tue,  5 Dec 2023 12:16:22 +0900
Message-ID: <20231205031534.269449617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

commit e34820f984512b433ee1fc291417e60c47d56727 upstream.

We had a problem with io hung because it was waiting for c->root to
release the lock.

crash> cache_set.root -l cache_set.list ffffa03fde4c0050
  root = 0xffff802ef454c800
crash> btree -o 0xffff802ef454c800 | grep rw_semaphore
  [ffff802ef454c858] struct rw_semaphore lock;
crash> struct rw_semaphore ffff802ef454c858
struct rw_semaphore {
  count = {
    counter = -4294967297
  },
  wait_list = {
    next = 0xffff00006786fc28,
    prev = 0xffff00005d0efac8
  },
  wait_lock = {
    raw_lock = {
      {
        val = {
          counter = 0
        },
        {
          locked = 0 '\000',
          pending = 0 '\000'
        },
        {
          locked_pending = 0,
          tail = 0
        }
      }
    }
  },
  osq = {
    tail = {
      counter = 0
    }
  },
  owner = 0xffffa03fdc586603
}

The "counter = -4294967297" means that lock count is -1 and a write lock
is being attempted. Then, we found that there is a btree with a counter
of 1 in btree_cache_freeable.

crash> cache_set -l cache_set.list ffffa03fde4c0050 -o|grep btree_cache
  [ffffa03fde4c1140] struct list_head btree_cache;
  [ffffa03fde4c1150] struct list_head btree_cache_freeable;
  [ffffa03fde4c1160] struct list_head btree_cache_freed;
  [ffffa03fde4c1170] unsigned int btree_cache_used;
  [ffffa03fde4c1178] wait_queue_head_t btree_cache_wait;
  [ffffa03fde4c1190] struct task_struct *btree_cache_alloc_lock;
crash> list -H ffffa03fde4c1140|wc -l
973
crash> list -H ffffa03fde4c1150|wc -l
1123
crash> cache_set.btree_cache_used -l cache_set.list ffffa03fde4c0050
  btree_cache_used = 2097
crash> list -s btree -l btree.list -H ffffa03fde4c1140|grep -E -A2 "^  lock = {" > btree_cache.txt
crash> list -s btree -l btree.list -H ffffa03fde4c1150|grep -E -A2 "^  lock = {" > btree_cache_freeable.txt
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# pwd
/var/crash/127.0.0.1-2023-08-04-16:40:28
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# cat btree_cache.txt|grep counter|grep -v "counter = 0"
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# cat btree_cache_freeable.txt|grep counter|grep -v "counter = 0"
      counter = 1

We found that this is a bug in bch_sectors_dirty_init() when locking c->root:
    (1). Thread X has locked c->root(A) write.
    (2). Thread Y failed to lock c->root(A), waiting for the lock(c->root A).
    (3). Thread X bch_btree_set_root() changes c->root from A to B.
    (4). Thread X releases the lock(c->root A).
    (5). Thread Y successfully locks c->root(A).
    (6). Thread Y releases the lock(c->root B).

        down_write locked ---(1)----------------------┐
                |                                     |
                |   down_read waiting ---(2)----┐     |
                |           |               ┌-------------┐ ┌-------------┐
        bch_btree_set_root ===(3)========>> | c->root   A | | c->root   B |
                |           |               └-------------┘ └-------------┘
            up_write ---(4)---------------------┘     |            |
                            |                         |            |
                    down_read locked ---(5)-----------┘            |
                            |                                      |
                        up_read ---(6)-----------------------------┘

Since c->root may change, the correct steps to lock c->root should be
the same as bch_root_usage(), compare after locking.

static unsigned int bch_root_usage(struct cache_set *c)
{
        unsigned int bytes = 0;
        struct bkey *k;
        struct btree *b;
        struct btree_iter iter;

        goto lock_root;

        do {
                rw_unlock(false, b);
lock_root:
                b = c->root;
                rw_lock(false, b, b->level);
        } while (b != c->root);

        for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
                bytes += bkey_bytes(k);

        rw_unlock(false, b);

        return (bytes * 100) / btree_bytes(c);
}

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc:  <stable@vger.kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20231120052503.6122-7-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/writeback.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -921,14 +921,22 @@ static int bch_btre_dirty_init_thread_nr
 void bch_sectors_dirty_init(struct bcache_device *d)
 {
 	int i;
+	struct btree *b = NULL;
 	struct bkey *k = NULL;
 	struct btree_iter iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
 
+retry_lock:
+	b = c->root;
+	rw_lock(0, b, b->level);
+	if (b != c->root) {
+		rw_unlock(0, b);
+		goto retry_lock;
+	}
+
 	/* Just count root keys if no leaf node */
-	rw_lock(0, c->root, c->root->level);
 	if (c->root->level == 0) {
 		bch_btree_op_init(&op.op, -1);
 		op.inode = d->id;
@@ -941,7 +949,7 @@ void bch_sectors_dirty_init(struct bcach
 			sectors_dirty_init_fn(&op.op, c->root, k);
 		}
 
-		rw_unlock(0, c->root);
+		rw_unlock(0, b);
 		return;
 	}
 
@@ -978,7 +986,7 @@ void bch_sectors_dirty_init(struct bcach
 out:
 	/* Must wait for all threads to stop. */
 	wait_event(state.wait, atomic_read(&state.started) == 0);
-	rw_unlock(0, c->root);
+	rw_unlock(0, b);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)


