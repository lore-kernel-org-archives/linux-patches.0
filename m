Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089A523A3
	for <patches@lists.linux.dev>; Fri, 27 May 2022 21:16:42 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id er5so6832731edb.12
        for <patches@lists.linux.dev>; Fri, 27 May 2022 14:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWvlDm9hhFZkrdkaC2XFt8A0sbOQiaJ6DORh+Lhw6t4=;
        b=KLVb2+ZQN7uzvUyG53PLJ4bW9v/lK1hnNTEPLTSnKJMx1XDAMsoG0gSCiA5/EK6W9g
         eJhz2DcTPyc8DQxcwPtTwMM1+LB2IpnoMiivvViaP9prQ4XJppRIPWadklHfLOmsJ89R
         kB4Owxt2t9GWzcDKbnHacxYwvdww97EIIZPyR8uqjaAQ8ftttQiK0g+ny1BtTiCd0ulD
         S/H2uuaBbaMys1eN1qkzWPITJoxe3vuUq7BagicWa+2yIOen7pZNuQ8oUFxofKYxo4vq
         2VAdMM56PnhpvVpMKR8xI84zhY0f2c/tyWkAPoCz3qMNY8uZE/F0dIJk7P/prrsWGPyt
         7dbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zWvlDm9hhFZkrdkaC2XFt8A0sbOQiaJ6DORh+Lhw6t4=;
        b=L4Dv0AH83nHyWHeQJwmWseoT3i6dBNHUAWUEvpvUT46/WgVlCgOWZbY7mvcSXs+9ni
         STa+/WAO6uREVE2rq720EVKIrtun003jMoUzzcjBLlTDBWmLt8aRwiNUt88AQKkUGXaN
         XNSjEulIplsONhLicsegb90nowwsksWJJXJPAKWiVSEZPljbHkmcrNXZmT5Nc88OM57n
         Ovfsn9PIzkfC60kiVWfeQFjDqPx0409p5z9h+Wxe9011e2d3aeTblnVEs1/U7cTc63Hc
         N6V8fC3wfaTw2SfRjtUC6UqlIZFwqz/FWNHGW77+lZGGRDzMMaRwSM9NM1cVlXzcyH6k
         Qkrw==
X-Gm-Message-State: AOAM533JCXS4qlBcvOtAiN/Jj9/35PLBmT7ek4P0ooqiDEnhUYc1BhgT
	9cQIhc1EulPqN9MqfLbxGEE=
X-Google-Smtp-Source: ABdhPJziiLWf8KmbLEe2nDi77yclj3z5r9rxzbT0FP3vuoeKGDp/Fq1qhDenHdS+uXLKORJQqvhX0A==
X-Received: by 2002:a05:6402:4c1:b0:42b:e03f:d940 with SMTP id n1-20020a05640204c100b0042be03fd940mr8746801edw.235.1653686201174;
        Fri, 27 May 2022 14:16:41 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id g18-20020a170906869200b006f3ef214df2sm1771278ejx.88.2022.05.27.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 14:16:40 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 0DF9FA0017; Fri, 27 May 2022 23:17:10 +0200 (CEST)
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
Subject: [PATCH v2 0/2] Refactor of vma_merge and new merge call
Date: Fri, 27 May 2022 23:17:06 +0200
Message-Id: <20220527211708.839033-1-matenajakub@gmail.com>
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

This patch series is based on tag v5.18-rc2. This is second version,
I forgot to include one header file in the first version.

Jakub Matěna (2):
  mm: refactor of vma_merge()
  mm: add merging after mremap resize

 mm/mmap.c   | 87 +++++++++++++++++++++++------------------------------
 mm/mremap.c |  8 +++--
 2 files changed, 43 insertions(+), 52 deletions(-)

-- 
2.35.1

