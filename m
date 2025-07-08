Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C280B1DF74F;
	Tue,  8 Jul 2025 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992041; cv=none; b=ckF6ayaFq8/nSbbUZl/rQJtigx5JWjFvk/bZNyqezk7+LxiIt1vohd6QspSUw96CTqSyBjtzQsqR1fL88Hay0MYXl0r88ZCf/2hcLhCEQp1Lw5q5YeNXUHJqBgFjos5hQetGqcwiYIS6/IKYhB8nQuNPcAQhU2vV/nXstdluzTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992041; c=relaxed/simple;
	bh=oje+7LZbQEDReRIWHQoXlAFHnHXp2c7RvI/am/iwoIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVGWMDYkK6fSi8AsIEKJ3mcIKXFRA1Izj4glHQhaStGX45L4RfyLze7huS0zJZcJRaDur+4gqEfl6Nmbe7CuvLB17kXNy2QVXtdpO4cBqeaMUWAiTDd/egf1j1AllfJKzrmT2rnpxwyD4MTIWDk2Gn8XARAz/4PfLQVOS5O09Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM5r3/hC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM5r3/hC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F09FC4CEF0;
	Tue,  8 Jul 2025 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992041;
	bh=oje+7LZbQEDReRIWHQoXlAFHnHXp2c7RvI/am/iwoIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qM5r3/hC9qqRpEBfzIeRGbuRToGd3r/gfbzErr3VbdMF590VFqmlph8CzBJY09Z0z
	 KyTnFZpC+0BaVacWKgb+GLCi6Vj4vVGTzSJ7ea2JQJRt8xMoZoD2o30pXRfNYQaQvu
	 j88bZ/GHtfv0+bhXJymOuhNwKoPZTbQCzuGEJQCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e04e2c007ba2c80476cb@syzkaller.appspotmail.com,
	Kohei Enju <enjuk@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 40/81] rose: fix dangling neighbour pointers in rose_rt_device_down()
Date: Tue,  8 Jul 2025 18:23:32 +0200
Message-ID: <20250708162226.264278012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fee772b4637c8..a7054546f52df 100644
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



