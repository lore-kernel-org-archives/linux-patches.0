Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585960;
	b=leCqzon+MnbO94mE4ivhOB767Q/QETqGhf0zJFAzzY1TtoNrbL7B9H3+AUArAZz+XO7s
	 yinVGsrbxBZ9u1oQpPF9ZcjSZLNUu0RAhOx+Uv6VxhCZWv4+jlLBXG/3vSZPTEgSflFlV
	 uazS06G7jzGI63qIx8BS6vpDMJvzbKECL3chZMauAU0ahzf1gpA4mlO1E95fSu4D8GD3W
	 22Sh6MsWnyWE95YlPlBLxhz2PYOergHrMJVcE9RmLiT4voc0PNnN9tgUmW99DUdeBlmtU
	 YbHmH/AjeZK44VDDPqG0zfsNPD6GX7LVXd4s1cCJu2afFWysUsh7eZVioHV8meEu4Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=obWvineHvQBLmI/oRt8ubYzd5GfKzjaH3MtvOFZI5tw=;
	b=LWz9LDkIeDezsChElMMRb+Ytwxl5WBnrzFFQv9HhP6NE+B+fQ3n61QPI5VpPa1ek/NLa
	 6XLqha2bzsHrDQqR5Op34uLSz8Wj7EJEeJwajf70IbOoIdpfihBEbxJlPzQn3xELXn2a6
	 G//IC/nkyiIUXLZqZXWQ4W6eFauUntKU7AeFS9vd68aQRAzi7DviPU6ZTTAavjKdv31O6
	 qQo04zov6gwzAoLQHkpoJCmBe1L4UdYU44QhVvfoFbXuB4jBok6h1n+SMHma37SdwAW0r
	 kdtIXvw0u0XFfpvrVUwTQhrdUg0JTps90tLlSdqA6zs9a6gHZlhD32lhdGAoqpxcWFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eyB9K9V+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E67606A896;
	Fri, 13 Nov 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eyB9K9V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C81F000C4;
	Fri, 13 Nov 2026 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585960;
	bh=obWvineHvQBLmI/oRt8ubYzd5GfKzjaH3MtvOFZI5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyB9K9V++++wflQyWlXqLgv80pG6wgZtZW3hibXAP/5x0uxBbUqXBuIrwNLDT7scO
	 u6DqvbTBxqX5ey6uAv9A47damd2QV0Upmi6L2fiH+Ddz4foOKVIgyksdE7QpeqORz/
	 YkZndVkmAJZfQ+yKrcAf0UyQ606Qq5XJK6lYh2yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <kasong@tencent.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 505/507] mm/vmscan: avoid false-positive -Wuninitialized warning, again
Date: Fri, 13 Nov 2026 10:53:29 -0500
Message-ID: <20261113153814.267643053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ca6e32f3f4240d0335775a11afc21e0451dd8d8f ]

I previously worked around a false-postive gcc-16 warning in the
get_tier_idx() function, by adding a fake initializer. This happens with
the -fsanitize=bounds sanitizer when the compiler creates a specialized
variant of isolate_folios():

In function 'get_tier_idx',
    inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
 4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/vmscan.c: In function 'isolate_folios.constprop':
mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
 4946 |         struct ctrl_pos sp, pv = {};
      |                         ^~

Adding another "= {}" would solve the problem as well, but to prevent
this from happening again after the next code refactoring, try instead to
prevent this by forbidding interprocedural optimizations on this function.

Link: https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/
Link: https://lore.kernel.org/20260916083456.4136132-1-arnd@kernel.org
Fixes: 3de705a43a46 ("mm/vmscan: avoid false-positive -Wuninitialized warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ec8fdede5dd8..88fd31d135853 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3194,8 +3194,11 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
-			  int tier_max, int gain, struct ctrl_pos *pos)
+/*
+ * __noipa works around gcc-16 warning for uninitialized use of pos->refaulted
+ */
+static void __noipa read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+				  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -4801,7 +4804,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4820,7 +4823,7 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
-- 
2.53.0



