Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8B423AA
	for <patches@lists.linux.dev>; Fri, 27 May 2022 21:16:43 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id er5so6832736edb.12
        for <patches@lists.linux.dev>; Fri, 27 May 2022 14:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i6lPNcDzycIov1mSkrT1DuTIerHURYERHQ0SJ25h8ww=;
        b=SoBDYj9niVpCHTx5kJvkoGyZ8mBE7SuG/84fscSrduUQp5/ePxiInmUat6IaNSgsWR
         ga004ByY6lw6IyWbt1dkH46Wj6IaADkMP3e5Gr3o/YxGu7aLpNsUSeMImlSmPOV5JL9b
         MYZK/V+iUSyuYcIK8JFWFYdacOEe5yZ7LExyb91R0DRWdJAnW9ujXjGT1dN84xF1og+d
         vUZDh5DE6ZhFqolekBXBC9iauZdKhFOKYHdJ9unGcfGmEMYt/yuM1k4r8H/RDsTUx7AN
         isJw5LmdbEKVHxH2uzfveIU92LLMo+YNrBVdUuMQA4ivCIozuBJlQKuiAhEDpc4eXWyg
         xFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i6lPNcDzycIov1mSkrT1DuTIerHURYERHQ0SJ25h8ww=;
        b=lIBBKUH67kMUKQBoip4ut/vDmJRmfHSvAyjFHiP9ZYRA+dvNtFfi77uCRGovF7M4qS
         mOdhlO8+lBpgCjzuryDtZsMaPGkEwkYiE4lsTXY8ge03RaPfVTGhFW7Hjc95vv9arC5P
         vJeY4uf6NlcRt69TkYlKiKdt/AGKOlmd+mjUq+FyHyepWBai8R6r2R6q2wbAzK2+xh6+
         v1umHL9cJUFB5LDjZSsMJ+en6GZQenD5nbggprVyM2wgutox1ouzFSK9tTwfAxgLekv8
         UDDhTggoITOai7QhlKHU5dfm+5A8LIety6v1G74SatcgqbTYyPBUPgeAZ2NzCIQGxqJI
         eMSA==
X-Gm-Message-State: AOAM533jcoWGcCT96pAkFKnGIfgrYzwFD40b5ShkSGR3Lbqsm8ido3ml
	KJF/c4K+Axf41xFK0+XDicE=
X-Google-Smtp-Source: ABdhPJxFAs7eRYdqOiXTG1ydQhgXTOtFZa6dkQhVCr12wsO14FNnGTH7jFVGtNHeUysMTLDZpoIM7Q==
X-Received: by 2002:a05:6402:2071:b0:42b:dfa4:d4e1 with SMTP id bd17-20020a056402207100b0042bdfa4d4e1mr8968698edb.70.1653686201430;
        Fri, 27 May 2022 14:16:41 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id o8-20020a1709064f8800b006f3ef214e70sm1746739eju.214.2022.05.27.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 14:16:40 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 14EF4A0019; Fri, 27 May 2022 23:17:10 +0200 (CEST)
From: =?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	patches@lists.linux.dev,
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
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>
Subject: [PATCH v2 2/2] [PATCH 2/2] mm: add merging after mremap resize
Date: Fri, 27 May 2022 23:17:08 +0200
Message-Id: <20220527211708.839033-3-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220527211708.839033-1-matenajakub@gmail.com>
References: <20220527211708.839033-1-matenajakub@gmail.com>
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
 mm/mremap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 303d3290b938..21dfa15e8200 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/hugetlb.h>
 #include <linux/shm.h>
 #include <linux/ksm.h>
@@ -23,6 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/mempolicy.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
@@ -1022,8 +1024,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 				}
 			}
 
-			if (vma_adjust(vma, vma->vm_start, addr + new_len,
-				       vma->vm_pgoff, NULL)) {
+			vma = vma_merge(mm, vma, addr + old_len, addr + new_len,
+					vma->vm_flags, vma->anon_vma, vma->vm_file,
+					vma->vm_pgoff + (old_len >> PAGE_SHIFT), vma_policy(vma),
+					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
+			if (!vma) {
 				vm_unacct_memory(pages);
 				ret = -ENOMEM;
 				goto out;
-- 
2.35.1

