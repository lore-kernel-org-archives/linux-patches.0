Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8C1ED1
	for <patches@lists.linux.dev>; Mon, 16 May 2022 12:53:47 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id r188-20020a1c44c5000000b003946c466c17so8199702wma.4
        for <patches@lists.linux.dev>; Mon, 16 May 2022 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Z8unS+I3KC7HgCSi3Sa8z96pMNRd1BvZvnwNMD3WTs=;
        b=A3Dlgex7+DnOnYZLaF9FBzoiuQTihhx3vEfDIIJp3ykd3bn66AKO/ul3Gml8GQK9jh
         f3hwwjHkZCiJ9DgKTkGT62t+28fyu4fPeH6rpjIS14P866udo2QEa/nNiX3bv362z4Bl
         rpJU+Bj6Cff+nP2ncVPO9oJ0cnBIsdpRo4ftBVxKQfEBRJFiWMtRksBNCkEDEZkQczGR
         WvnhZx97jd08S63rv/lP1ZWpwI8Mt8hiY5Uqjse+zT5wigM7wz3Athcrzf2qZgpS8z3H
         uysUaWSpR4Co9Q6TEPdesUrO5VMOoIu23/e7zZZGR04IZ88yHXaeQq1cL7Oqi10OAYTH
         IeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Z8unS+I3KC7HgCSi3Sa8z96pMNRd1BvZvnwNMD3WTs=;
        b=3bfTvesXBe71oylQIyfXdhmcDdcvMaLPLMocDAlyQWup/10qKQi+B/iU7fl/0PPGoX
         MlCsCbRhbeiDgCWTrLhq4YL3iDSDGbK++L+3G7ikZJ+Z55H45QHSDFFV3kJSR//GfU/y
         GF+XEjJUA4ABBhbjANUAHctpl7Y2hH21OlHAukpG5pNQOnjxruyXIcVuzaDSGXAgSIto
         Vj4tcZCFrOYv7qxzS5RoTZClFlYyqIQJQdEdeOPsQEF4PtUCFslrDqRU1WzcrPSSYXwp
         DdoIejCBs5rSzNcvabd7NKNOxo0DGI+LsT9LVjQOEnk7yYPJ3EPea6ScBPyivXTJQpFI
         UUow==
X-Gm-Message-State: AOAM533DnrBkSDGmn1aKSp23BidowK6uTLJ2nZpVLNViT1PgZ1jnuJdL
	G7gPWtGYKJrIrGyRYwhIt7U=
X-Google-Smtp-Source: ABdhPJzV07JC9Mg9zVfcWX1VUOyPfRogVK8bD1F7lIrfsaUsrqugDWj/POWQV+HHzB0bOOI1Q6XAQg==
X-Received: by 2002:a05:600c:1da5:b0:395:baf7:ca4c with SMTP id p37-20020a05600c1da500b00395baf7ca4cmr16782305wms.99.1652705625778;
        Mon, 16 May 2022 05:53:45 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id p15-20020a7bcdef000000b00394517e7d98sm10372100wmj.25.2022.05.16.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 05:53:45 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 8F349A0E77; Mon, 16 May 2022 14:54:07 +0200 (CEST)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: linux-mm@kvack.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	vbabka@suse.cz,
	mhocko@kernel.org,
	mgorman@techsingularity.net,
	willy@infradead.org,
	liam.howlett@oracle.com,
	hughd@google.com,
	kirill@shutemov.name,
	riel@surriel.com,
	rostedt@goodmis.org,
	peterz@infradead.org,
	david@redhat.com,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [RFC PATCH v3 2/6] [PATCH 2/6] mm: add merging after mremap resize
Date: Mon, 16 May 2022 14:54:01 +0200
Message-Id: <20220516125405.1675-3-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220516125405.1675-1-matenajakub@gmail.com>
References: <20220516125405.1675-1-matenajakub@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When mremap call results in expansion, it might be possible to merge the
VMA with the next VMA which might become adjacent. This patch adds
vma_merge call after the expansion is done to try and merge.

Signed-off-by: Jakub Matěna <matenajakub@gmail.com>
---
 mm/mremap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 303d3290b938..75cda854ec58 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/hugetlb.h>
 #include <linux/shm.h>
 #include <linux/ksm.h>
@@ -1022,8 +1023,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 				}
 			}
 
-			if (vma_adjust(vma, vma->vm_start, addr + new_len,
-				       vma->vm_pgoff, NULL)) {
+			if (!vma_merge(mm, vma, addr + old_len, addr + new_len,
+					vma->vm_flags, vma->anon_vma, vma->vm_file,
+					vma->vm_pgoff + (old_len >> PAGE_SHIFT), vma_policy(vma),
+					vma->vm_userfaultfd_ctx, anon_vma_name(vma))) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
 				goto out;
-- 
2.35.1

