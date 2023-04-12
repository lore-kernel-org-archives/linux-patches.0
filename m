Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9032F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC58C433EF;
	Wed, 12 Apr 2023 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289637;
	bh=aMciy0R6RSU+bWDQ+Km+kU9ii7DeYaaHukWKshTn5og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A93ANh7uXoOr4k6vB3nAByPsgvc8OnyGvBY04ArD9yt3tWfJ85GOFVMKwbvEJPn2y
	 57+E1guEuds8fmiW3v3YcRL1tzYjBRFaUeImbic6nOzOc3iSPZqbmDP0PKzl6wfiHz
	 Lygyr8VBqyymFaX3GOHTFE698AueIylPcAzsFP9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 154/173] maple_tree: fix get wrong data_end in mtree_lookup_walk()
Date: Wed, 12 Apr 2023 10:34:40 +0200
Message-Id: <20230412082844.321928073@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit ec07967d7523adb3670f9dfee0232e3bc868f3de upstream.

if (likely(offset > end))
	max = pivots[offset];

The above code should be changed to if (likely(offset < end)), which is
correct.  This affects the correctness of ma_data_end().  Now it seems
that the final result will not be wrong, but it is best to change it.
This patch does not change the code as above, because it simplifies the
code by the way.

Link: https://lkml.kernel.org/r/20230314124203.91572-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20230314124203.91572-2-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3875,18 +3875,13 @@ static inline void *mtree_lookup_walk(st
 		end = ma_data_end(node, type, pivots, max);
 		if (unlikely(ma_dead_node(node)))
 			goto dead_node;
-
-		if (pivots[offset] >= mas->index)
-			goto next;
-
 		do {
-			offset++;
-		} while ((offset < end) && (pivots[offset] < mas->index));
-
-		if (likely(offset > end))
-			max = pivots[offset];
+			if (pivots[offset] >= mas->index) {
+				max = pivots[offset];
+				break;
+			}
+		} while (++offset < end);
 
-next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
 		if (unlikely(ma_dead_node(node)))


