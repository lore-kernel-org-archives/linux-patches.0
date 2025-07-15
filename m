Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CE62ECE9A;
	Tue, 15 Jul 2025 13:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587751; cv=none; b=boojuAozexiVcUR7yz+sDao4AFbd90K8opfvtkpB7kQWyJXrhh+o7g41TFenj2nBVfCLDmLErxayQkimFXlag5fAMBnGo6CYYVibla1YNo0XbsUL15py7yP9LeBIMb6356zXjdHsjeeI+UYFK4EfwzSg9TXAV0Uli6gp53PPJJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587751; c=relaxed/simple;
	bh=+GQfc4bqsqs5W2QV+5udN/wojTCASvysVvDjsvaWqpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKnu8rHSk11hrN1grITf3tobC/N5m4+nuAHChHusUSW+x4pPklTpkDDAd61Gv9jRwQCThfh9qK7ZDQu+orn7gA2AsCUoHxD3VzQQ60UUv/Etfsq/yha2fywTcQrWX6x9hALqds1q0TPWa692z1QKIDEiX4HW4Ftu0JdEgr/ZIkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=naVFJulw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="naVFJulw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEABC4CEE3;
	Tue, 15 Jul 2025 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587751;
	bh=+GQfc4bqsqs5W2QV+5udN/wojTCASvysVvDjsvaWqpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naVFJulwktoJsf6wId6eArEe9gntiZjW4veviLp8+dGdnj9ZvWBVLYEya57FrUoXI
	 h3OjJYvjdZKY8NkxLN2FHLVbdPkg3juCFh7kblC1MqZ2ckHDriv3Th/dXXaCLQMVe3
	 K6dV/fOw0qdDH386SyaKoshu1RbrpZpvMI1K+NGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e04e2c007ba2c80476cb@syzkaller.appspotmail.com,
	Kohei Enju <enjuk@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/208] rose: fix dangling neighbour pointers in rose_rt_device_down()
Date: Tue, 15 Jul 2025 15:13:27 +0200
Message-ID: <20250715130814.869128771@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

From: Kohei Enju <enjuk@amazon.com>

[ Upstream commit 34a500caf48c47d5171f4aa1f237da39b07c6157 ]

There are two bugs in rose_rt_device_down() that can cause
use-after-free:

1. The loop bound `t->count` is modified within the loop, which can
   cause the loop to terminate early and miss some entries.

2. When removing an entry from the neighbour array, the subsequent entries
   are moved up to fill the gap, but the loop index `i` is still
   incremented, causing the next entry to be skipped.

For example, if a node has three neighbours (A, A, B) with count=3 and A
is being removed, the second A is not checked.

    i=0: (A, A, B) -> (A, B) with count=2
          ^ checked
    i=1: (A, B)    -> (A, B) with count=2
             ^ checked (B, not A!)
    i=2: (doesn't occur because i < count is false)

This leaves the second A in the array with count=2, but the rose_neigh
structure has been freed. Code that accesses these entries assumes that
the first `count` entries are valid pointers, causing a use-after-free
when it accesses the dangling pointer.

Fix both issues by iterating over the array in reverse order with a fixed
loop bound. This ensures that all entries are examined and that the removal
of an entry doesn't affect subsequent iterations.

Reported-by: syzbot+e04e2c007ba2c80476cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e04e2c007ba2c80476cb
Tested-by: syzbot+e04e2c007ba2c80476cb@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kohei Enju <enjuk@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250629030833.6680-1-enjuk@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 66aa05db5390f..d0112f1863850 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -497,22 +497,15 @@ void rose_rt_device_down(struct net_device *dev)
 			t         = rose_node;
 			rose_node = rose_node->next;
 
-			for (i = 0; i < t->count; i++) {
+			for (i = t->count - 1; i >= 0; i--) {
 				if (t->neighbour[i] != s)
 					continue;
 
 				t->count--;
 
-				switch (i) {
-				case 0:
-					t->neighbour[0] = t->neighbour[1];
-					fallthrough;
-				case 1:
-					t->neighbour[1] = t->neighbour[2];
-					break;
-				case 2:
-					break;
-				}
+				memmove(&t->neighbour[i], &t->neighbour[i + 1],
+					sizeof(t->neighbour[0]) *
+						(t->count - i));
 			}
 
 			if (t->count <= 0)
-- 
2.39.5



