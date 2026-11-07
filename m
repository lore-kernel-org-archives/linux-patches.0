Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063079;
	b=YIek8DdJv1V62nWP+2Kb/f7pxZMEWBajbV8kt3n9PzdbzrVTX2lmowKdgGCQa7DZI1Sd
	 COgd4oAckOWgO07K1djfa/jvr0ADOUCmvlkuP45MI/dSqOOhubh9edAfSRW9EjWV19UdF
	 BWZDBO/7jWl3jWCJnIdDL4ZdpcKdBKFVc2ZdGQwhs1g3/oFUYzRL/UtPkGKmXOVFJbNDj
	 ruC6L5oMYWKqblWhEHLB/tv8xUnn3y73bTjHGAxjcMwLfUauDIyV4M1NZ14Szm+U32VkE
	 h9L/jk5jnp8tdt1B/S0sBAYgYnAwYyG2XY3dqVaD8y7G7UM7w65OVYo8EMtPrGA7Gpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZG/lulIn0qlE6Rcd6tdHrHA/3qbLaH/x5+RK67jcM0=;
	b=ON+gOwoXs/wzOTSFTHbKBXJXQhSqWobqnRYRsmiJ18EtKrURdmayo6M2qo0xjBwc8sPU
	 stvUG6oM1IU0+0tR1Mo4MkqnPghWamPkca8bHa9CRvKYRyH8ERuEUiQnKhk5vnEvC4PPf
	 +PSCpdITYTxtszoGpDhVcLORiy5aFJ1r4ZLiFVWKgMr3cGRy6JOU1vLffgXSi79+934CI
	 uOuf1MSvW/Ku+0BofRiXJvF0OvadlHKPYkNvC6mVo6xo8z0Y3HHyALE50TBReHNL12hhe
	 FMxuYq/tItorX1haAs09ksFf9ey0TuAD5IinI6G4JTIG1MBMf7dW7abGPj+O07OPhxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5VXkS8Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014CD606D802;
	Sat,  7 Nov 2026 14:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5VXkS8Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21991F0089F;
	Sat,  7 Nov 2026 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063078;
	bh=2ZG/lulIn0qlE6Rcd6tdHrHA/3qbLaH/x5+RK67jcM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5VXkS8YcREh96BaPpD/cy97FGEXHhbeaYxRzAQ+snP+Alj5JZzA+b6H9ed9Ep4Mq
	 Jb3iKT1IOeE+QMYj+bfedKXXmM9yNc2fXRxX2hf84q95sN07y6iXs7E6/LjqwKHgWQ
	 2+TfeXWkwLfW6jibXFIS8RI7VtCz4YlumBsfzONg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 319/869] dm-writecache: fix uncommitted_blocks underflow
Date: Sat,  7 Nov 2026 08:50:01 -0500
Message-ID: <20261107134903.295587496@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 8a0cc5f3446a324b13f62020eeddb32d6ba1c2db ]

Revert the commit 39495b12ef1cf602e6abd350dce2ef4199906531

writecache_bio_copy_ssd sets wc->uncommitted_blocks = 0; and then queues
the flush work: queue_work(wc->writeback_wq, &wc->flush_work);

It may be possible that discard is dispatched in this window, and the
discard would decrement wc->uncommitted_blocks to -1U.

Note that this bug is benign - wc->uncommitted_blocks is only used to
trigged autocommit, so decrementing it to -1U will trigger a spurious
autocommit, but won't cause any data corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Fixes: 39495b12ef1c ("dm writecache: correct uncommitted_block when discarding uncommitted entry")
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index d3f93a871a142..63e18c6f1325f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -899,8 +899,6 @@ static void writecache_discard(struct dm_writecache *wc, sector_t start, sector_
 				}
 				discarded_something = true;
 			}
-			if (!writecache_entry_is_committed(wc, e))
-				wc->uncommitted_blocks--;
 			writecache_free_entry(wc, e);
 		}
 
-- 
2.53.0



