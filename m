Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135EB1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8902DC433C9;
	Fri, 21 Jul 2023 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956140;
	bh=P5osZbV/yO3ne+1piUV03kgXN0IdBQUvkU+egyQjWRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPg8I53m6mcOd7ydJJ2jn8rLzOt7UmMm9uvFfvVBF7o4gizuJpYlTX9kd+H8/EHK1
	 Ywgq8CZbwi+wlRQOkUM7BnF18HYZjodtORejqsw2MHUP7puO7NmWkYToJroO+csRUu
	 YCgRjgnQi+97MiwKp8TlpQo3I9yaUGuLy16+Jnc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@google.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 139/292] kasan: fix type cast in memory_is_poisoned_n
Date: Fri, 21 Jul 2023 18:04:08 +0200
Message-ID: <20230721160534.825782816@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrey Konovalov <andreyknvl@google.com>

commit 05c56e7b4319d7f6352f27da876a1acdc8fa5cc4 upstream.

Commit bb6e04a173f0 ("kasan: use internal prototypes matching gcc-13
builtins") introduced a bug into the memory_is_poisoned_n implementation:
it effectively removed the cast to a signed integer type after applying
KASAN_GRANULE_MASK.

As a result, KASAN started failing to properly check memset, memcpy, and
other similar functions.

Fix the bug by adding the cast back (through an additional signed integer
variable to make the code more readable).

Link: https://lkml.kernel.org/r/8c9e0251c2b8b81016255709d4ec42942dcaf018.1688431866.git.andreyknvl@google.com
Fixes: bb6e04a173f0 ("kasan: use internal prototypes matching gcc-13 builtins")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/generic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -130,9 +130,10 @@ static __always_inline bool memory_is_po
 	if (unlikely(ret)) {
 		const void *last_byte = addr + size - 1;
 		s8 *last_shadow = (s8 *)kasan_mem_to_shadow(last_byte);
+		s8 last_accessible_byte = (unsigned long)last_byte & KASAN_GRANULE_MASK;
 
 		if (unlikely(ret != (unsigned long)last_shadow ||
-			(((long)last_byte & KASAN_GRANULE_MASK) >= *last_shadow)))
+			     last_accessible_byte >= *last_shadow))
 			return true;
 	}
 	return false;


