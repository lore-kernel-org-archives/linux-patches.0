Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6257E68
	for <patches@lists.linux.dev>; Sun, 12 Dec 2021 06:52:48 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id v23so9663113pjr.5
        for <patches@lists.linux.dev>; Sat, 11 Dec 2021 22:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=u3a3vrzHqdA/cq7G0yrkkIe6WLWwASeC4ff5g3IY6r0=;
        b=IBAImVNcA2hFDtgg5Ygat6PJ9jbpxtPIiyveN8XqvvKhSfEtLxhQ1NwQl9Gy3NjXAN
         TFRM36gCC8jDj6NjVhBy2A5jp17b0an/B3BVeHgg9pteK63CSlu2P5jDZCNqkqjgMg/S
         ZD2sJ0vSVSsMeF1Eu6q2nI7Fl5utNtP7IzosC6KggdA5i5MP5JUUI10Tkke7cFhCwOFm
         Z7JARn8J/P3Z+m1G7ZbGkRWRANqiL1I1A3yyHCzBi1lMJcbwpSyRLDm6ZFX/06p6i96T
         EmYIodd7vaUWg3HtHiGLnXyO6EnWrLbLy6IOCtkPCyMyIpNf+m0+dDhuz6g2X2EIxdwr
         tQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=u3a3vrzHqdA/cq7G0yrkkIe6WLWwASeC4ff5g3IY6r0=;
        b=mX8x2y4Ap5lbP8v12yc9VfUPQubxVc8MD+KtMjrHfpSTMHhP5P2EQnwzjSCUmch711
         yWwABwC7ajPGZgd5pVmuCIWSyJ9ZUuSqoRr3PRKBFps8zBhVrwTSCQM2jHyaDccwtaiI
         MktWblnkyvHXk3+/zcbAxqLEBvzybxQYsXcdT3iFHvWkiRPds8FMa6/+qTDW3ETasdeC
         Gr8msE6G5STWwY9KGoYDPjVzSc7oZ9KIz0kBOhGK0wUe4JqNgw9X0ppFBkStTos3bYyS
         0tP+oIaCy6s+9wvBuAh5XoKnLuQQ+MH5HeEid/1uP8Ts1d045kcsAeNdAs595i9RTwBt
         7+Jw==
X-Gm-Message-State: AOAM530mVQKWXUBXA/P3BItvTF1hHgbvOprUaWYXZnXpAwwohLkN7H/0
	yYHhkecP4LztpzSgnqdgDZY=
X-Google-Smtp-Source: ABdhPJxZXel7c/67LTjINIxS3hDguKFl47yP7+U6phVaxlqCTP29fHdEYGxVvbG038JogxuZgg8CxQ==
X-Received: by 2002:a17:90a:a504:: with SMTP id a4mr35694110pjq.17.1639291967953;
        Sat, 11 Dec 2021 22:52:47 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id ng9sm3613977pjb.4.2021.12.11.22.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 22:52:47 -0800 (PST)
Date: Sun, 12 Dec 2021 06:52:41 +0000
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: [PATCH] mm/slob: Remove unnecessary page_mapcount_reset() function
 call
Message-ID: <20211212065241.GA886691@odroid>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-32-vbabka@suse.cz>

After commit f1ac9059ca34 ("mm/sl*b: Differentiate struct slab fields
by sl*b implementations"), we can reorder fields of struct slab
depending on slab allocator.

For now, page_mapcount_reset() is called because page->_mapcount and
slab->units have same offset. But this is not necessary for
struct slab. Use unused field for units instead.

Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 mm/slab.h | 4 ++--
 mm/slob.c | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 90d7fceba470..dd0480149d38 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -50,8 +50,8 @@ struct slab {
 	struct list_head slab_list;
 	void * __unused_1;
 	void *freelist;		/* first free block */
-	void * __unused_2;
-	int units;
+	long units;
+	unsigned int __unused_2;
 
 #else
 #error "Unexpected slab allocator configured"
diff --git a/mm/slob.c b/mm/slob.c
index 39b651b3e6e7..7b2d2c7d69cc 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
 			clear_slob_page_free(sp);
 		spin_unlock_irqrestore(&slob_lock, flags);
 		__ClearPageSlab(slab_page(sp));
-		page_mapcount_reset(slab_page(sp));
 		slob_free_pages(b, 0);
 		return;
 	}
-- 
2.30.2

