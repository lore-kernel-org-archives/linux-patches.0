Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21CB44CAF7;
	Tue, 16 Jun 2026 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626204; cv=none; b=In84Q3XalpucusRcKlQ+9HnSmjLD7ANoq+Q7PgSR/WAvluYAeKENU0Rw5Yfhjs2cm9VxDbQGCx8b7OwdebNIAIrHgeqJjZhXWKARYe2wzTNAxXeTRUfAcHiwgcPaFwOs/L2ytHjgkHqQmA+1KwhayJD9S+aiIuJxFqdu3N+YNwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626204; c=relaxed/simple;
	bh=0GA1IkdlkKwBP0rM/YIwFQDej0Z+9jFcO/jBisn9NEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxIN29kJ+qg91pV7T90NgTJoOQVSNUX48wKTZhNOJ2wKXB29qBy2GwRc+71bQNgwQsAS+VGXvqUWA8qJJ1f5/m/T7juS5CKGgdHy3geP/uDBtZ2XCGIEwNSbueuh1AVkLFeFHwTPcOr9EapXIF5zF5SNp8n38DFhsfwAx8Jz90s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBXlXkYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBXlXkYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D311F000E9;
	Tue, 16 Jun 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626203;
	bh=OUqHsNmOj2YxxKXxDPAszLqjmMtw/eWgO2ZuoijhUIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBXlXkYaAkF0I18pEsnG1iUKkhDz8KM+Tja5k7xMqiQoVP48/GGmCdoq51rdr6t8q
	 zARorRC9ER3Y1g+zv7S9WpkDCks24Vi45R4gfFjssqIE87fR4ulDQOMwo0ibOaNNOo
	 80QI3d0OcoMzdCdW06zyuhArB+E2nuCEoAmiWKLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Michal Nazarewicz <mina86@mina86.com>,
	Stefan Strogin <stefan.strogin@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 250/325] mm/cma_debug: fix invalid accesses for inactive CMA areas
Date: Tue, 16 Jun 2026 20:30:46 +0530
Message-ID: <20260616145110.977308904@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit c0ca59beb5252ea2bd4fdaef009d003dedc2030e upstream.

cma_activate_area() can fail after allocating range bitmaps.  Its cleanup
path frees those bitmaps, but only clears cma->count and
cma->available_count.  It leaves cma->nranges and each range's count in
place, so cma_debugfs_init() can still register debugfs files for an area
that never activated successfully.

That exposes two problems.  Reading the bitmap file can make debugfs walk
a freed range bitmap and trigger an invalid memory access.  Reading
maxchunk can also take cma->lock even though that lock is initialized only
on the successful activation path.

Fix this by creating debugfs entries only for CMA areas that reached
CMA_ACTIVATED.

c009da4258f9 introduced the invalid access to bitmap file.  2e32b947606d
introduced the invalid access to cma->lock.  This change applies to both
issues.  So I added two Fixes tags.

Link: https://lore.kernel.org/20260520061025.3971821-1-songmuchun@bytedance.com
Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/cma_debug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -205,7 +205,8 @@ static int __init cma_debugfs_init(void)
 	cma_debugfs_root = debugfs_create_dir("cma", NULL);
 
 	for (i = 0; i < cma_area_count; i++)
-		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
+		if (test_bit(CMA_ACTIVATED, &cma_areas[i].flags))
+			cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
 
 	return 0;
 }


