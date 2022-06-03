Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622927E8
	for <patches@lists.linux.dev>; Fri,  3 Jun 2022 14:56:49 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id 25so10225364edw.8
        for <patches@lists.linux.dev>; Fri, 03 Jun 2022 07:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=39Qt6YV0FwGKKYhTeE9ToxWI/DQEBDcRES3gLcKo9F4=;
        b=e5A51A66u/0SUz0B94iSCOyvfYagEF/2TxdxjA9CmFKdNeO/J0N5sqDpvBbPU6WFg2
         gk8e+0UF1CeTlWFTJV+6ai4nhPgXKJ4AbaqyTwt2JeDC9U6+a3bwxmLAfl2fauHXMzBi
         dmiOm86ZRsEWg9BHtO7Pjs+WX8jzq83cW1QVqFUT/ov8PN+D6TtIiuNZO3cVs83vvKBH
         1pp/AsM3RQ1sgbGxY0JqebqJtkbbNgJ03qQbw0DfB4u6ed/pga5DtxNWt98R2otqJkHX
         +DgCohf0SgMcuecZU5IZ68VcrgfSj7lFh9+qqN7sR0u9QAMx0M+m4DOdgIDNV5v0Rvu9
         1Jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=39Qt6YV0FwGKKYhTeE9ToxWI/DQEBDcRES3gLcKo9F4=;
        b=b7BuUPCGrhtLaFGSCyd0DUiinriATqD/R9XFRwEsyKPcIJlEtn6M6O0r9sQ4xPpCEW
         XHFcolnwPY+iH0CFLb2M8FDSaJZ6wS2u0h0y2AglX7HQZHaLIGgbcahwq7VMNBaOqQp0
         ErtuhDW5pHn0/ahQM+d2XSTbC8AhAUPlGD85Mp4TSCnBmURVw2XL2MkyptYvOJugLFDC
         T+rajx4wCtqjGv3bfPaZceM2qxukQ+Ot7rJYvYEflAjA5QdQz+xH5RxXlDklLel9rrUg
         jWnwerhOQxk52Z1Op6uuat8uxKW3idOmA8wtbDGmSKih7vTWAenY3l3o559BlQoUDwud
         DVZQ==
X-Gm-Message-State: AOAM533GYud9bKkuxnYg0gMEjEzLQaZ6YzOZ+7PyKd4gzG8W7/s7TQlE
	PMyYahea5qutCz7+a8zeru0=
X-Google-Smtp-Source: ABdhPJwd9zjK40T7IiYBa1JINrlDj45THKbt8M6DpIODKZse3VhsfKpoBF+/R+oC7IAlwEM+YGwCWQ==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr11271819edb.273.1654268207704;
        Fri, 03 Jun 2022 07:56:47 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id u19-20020a056402111300b0042dc6336684sm4021965edv.73.2022.06.03.07.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 07:56:46 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id A9D03A007B; Fri,  3 Jun 2022 16:57:20 +0200 (CEST)
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
Subject: [PATCH v4 0/2] Refactor of vma_merge and new merge call
Date: Fri,  3 Jun 2022 16:57:17 +0200
Message-Id: <20220603145719.1012094-1-matenajakub@gmail.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I am currently working on my master's thesis trying to increase
number of merges of VMAs currently failing because of page offset
incompatibility and difference in their anon_vmas. The following
refactor and added merge call included in this series is just two
smaller upgrades I created along the way.

The rest of the work is still being worked on but was send to mailing
list as a RFC:
https://lore.kernel.org/all/20220516125405.1675-1-matenajakub@gmail.com/

This patch series is based on mm-unstable branch (specifically commit
1bdf44dbc966e31c635199d413ee064a7d320844). This is fourth version,
I added a mremap expand merge test, added a comment and new variables to
the merge call and based the series on the mm-unstable kernel branch.

Jakub Matěna (2):
  mm: refactor of vma_merge()
  mm: add merging after mremap resize

 mm/mmap.c   | 87 +++++++++++++++++++++++------------------------------
 mm/mremap.c |  8 +++--
 2 files changed, 43 insertions(+), 52 deletions(-)

-- 
2.35.1

