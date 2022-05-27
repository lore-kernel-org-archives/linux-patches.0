Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155891853
	for <patches@lists.linux.dev>; Fri, 27 May 2022 10:47:53 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id z43so429183ede.1
        for <patches@lists.linux.dev>; Fri, 27 May 2022 03:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E8hw1YxRdyFQiBunbdOQafA0vLjTqdy9/4gfOonLrFg=;
        b=cMw3nqupRwb9iJ0bAiEPeAgnOBYM1beNn1TObGXfHMIOMS1sTGGaToiA5nWxbTPG23
         7Bz8Tf9v6QAYxGl16dxbYfTSm7cMnx29cgprRiQll1k8U5uaKV9vxmnxwM/ichP5gcNC
         2MhV/Fgj+5yEwdzZBeNIph23msVCY1g5rCZhKgrErykccuFP7ubdDpN+0sMnTjuyAXgD
         WlQzdnKIlZD5ZXUjz2BiatWWlSOPzWc4K+AATgFhBrhSUWAhmb/cxMDw9moE2hFmKj7M
         tL+7T6Ejx28GCXKEAeHuZe351Sitn3HNDzC0SQ+cSYB/9oTan6ZNM36uDM5QH6P2nfo8
         yO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E8hw1YxRdyFQiBunbdOQafA0vLjTqdy9/4gfOonLrFg=;
        b=EWsDS3YwFWMu7bgV57hmsdukOSN7e1uEOklvI2C4gzPtugdEv0uzvPZvwSj9nZB98N
         cfCOFqmzaHaW4mH++nOkdpJmkcLmG7UIAMsYcBFV/jw7HtML139t4qzAoNAUMnV3LxEd
         X4mgocp+I3J3pi3C6L5FzQC+Z9q+8m72DyOFjAho5rUA4GXSay89Hv4AWgkdGxLr79SG
         bTcjcwutEFeLsf1knvXx5dISA+KyGvZTfJXrXKONZI8DBIqMREG3isbJbN2ji3YlqyQy
         fgvHiW2cqTzZ9JDNmJAS523lM954av3cAuh3GRl8H14bzMVT4aPlRhwYBSoS3GnZWeYu
         Cdlw==
X-Gm-Message-State: AOAM531gro2KvMTyxL4NBELQ7DsY18iQTYIAcS2Rc9lOo1cQUgz4Otap
	uGU7EiM9WE5sgUamc6DsRQo=
X-Google-Smtp-Source: ABdhPJyTYr0OkS3+nT4wN/g4MnpnJWE858fclOQNBvUdUSBEzGJbKuxqnWjjUb04IleiIrgnKZ+Spw==
X-Received: by 2002:a05:6402:1cc1:b0:413:2b12:fc49 with SMTP id ds1-20020a0564021cc100b004132b12fc49mr43833744edb.118.1653648471305;
        Fri, 27 May 2022 03:47:51 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id v4-20020a50a444000000b0042ab87ea713sm777389edb.22.2022.05.27.03.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:47:49 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 5148EA0293; Fri, 27 May 2022 12:48:18 +0200 (CEST)
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
Subject: [PATCH 2/2] [PATCH 2/2] mm: add merging after mremap resize
Date: Fri, 27 May 2022 12:48:10 +0200
Message-Id: <20220527104810.24736-3-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220527104810.24736-1-matenajakub@gmail.com>
References: <20220527104810.24736-1-matenajakub@gmail.com>
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
 mm/mremap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 303d3290b938..c41237e62156 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/mm_inline.h>
 #include <linux/hugetlb.h>
 #include <linux/shm.h>
 #include <linux/ksm.h>
@@ -1022,8 +1023,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
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

