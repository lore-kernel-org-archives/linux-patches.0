Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844682E62B2;
	Tue,  8 Jul 2025 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994094; cv=none; b=lJv37ybkbVVMZipvx2yC3us75znxcL3+PWdY5Ewah5wZJaUc2Bvz9xT0ZCBauoHhyySFIuqdC3fRJi8AztX9UzJlpc+Itp68xx0uIodG1JWw21j8jXM/I/fqxC/XS81MHDlsYyrfd9mHDovZ6LQoisf4DuGDzpAT5W/Ddk9WaSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994094; c=relaxed/simple;
	bh=q9tqZVHWrTLsej0fKC1z0Usxe9qPpDoq8kY9mc0YiJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dG+hNJEI/OQiphAL4CzjlMPT8HLUdkwJcobGhLMGOtDyGh1+5PqYWJ/XlXanimnWR0ggwvW2m4GmoEPrOk1SLOj+Qfk3ZxS5vaeVeRnKN0LY3rMq79Fm/JEWsfsSpbWYKWYjbYYrBWG5Q5NrwSgu2X0WNjYn6IL7QiQtF+Ah35g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPjME6jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPjME6jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3A3C4CEF0;
	Tue,  8 Jul 2025 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994094;
	bh=q9tqZVHWrTLsej0fKC1z0Usxe9qPpDoq8kY9mc0YiJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPjME6jRm8wa8WGmEdnhC7eNK4OUZ+lB1yPHeeOMUMoDblIOpeQdtd826CjRUVzYt
	 SNzugW6xSfqdnn/98/Wr5pOqlPEyNHJLhCCEHc1sVn3ywuyUyZvklYCwvgQ3LfCEZZ
	 1fctioL2+qhKH5oooK6l3zwFq6p1xdRueL1JoBDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e04e2c007ba2c80476cb@syzkaller.appspotmail.com,
	Kohei Enju <enjuk@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/160] rose: fix dangling neighbour pointers in rose_rt_device_down()
Date: Tue,  8 Jul 2025 18:22:40 +0200
Message-ID: <20250708162234.842361153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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



