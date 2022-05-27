Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19D46B8
	for <patches@lists.linux.dev>; Fri, 27 May 2022 10:47:51 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id c93so3587782edf.7
        for <patches@lists.linux.dev>; Fri, 27 May 2022 03:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/fT1it2KZU2gPXkEvlWdCKHS58rx52JxhTKoYGvWFsI=;
        b=RRHjbEWLo2//B4DPzz6ni5o3BsNnS6apiG3aXTQnDHlIWIIzK1KijymcswiWzlHFtY
         f4mkpH7cLheY6r/TX6hJMUhSaomWTESb3RUoKXH78dVbYDcmz3byk7MprwemE3lMoHSW
         wUK8bcIJJz2Bz+wUoLKwSwowL5/Xky9sXpdWuaXefgSn90q6kXSIt12TUok6I4kXq8fD
         IYrnZbMGB2z/eoeNFjIU+Rp07MPbWuCQpNtw+/QZHXQl3HVcKre9Qsw+Itnwwu3Zx7ge
         +D41kdUtz7/9UjllTAR1Z+MUwIwRF9gRjD2uxegnYRu+HC+WtUnOj5wkl/Sn33XOCida
         +Qgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/fT1it2KZU2gPXkEvlWdCKHS58rx52JxhTKoYGvWFsI=;
        b=cCjSPKDSPZ/1NNoyHlwbFrl4EQdK/cs2ciWR8yO80681j+QQdBJElRAcyCjq7s93qu
         UJ3jVbGFA8jflGvg3Nk9fCDhTY23210H7CpIwKXlVWFGEONpyzi8aJtJI9aIv0hg2rd7
         eIDx3YLus1FbNdHJzzpAfbaX5APnu/OQw5rY8K7PM9aUcJxt7Qx/stC/IbzwdATo9DK8
         YEzMfRZYTXc9NB51DUY07B166xolIzi61T9YK6gi4+GIe0LA1ly46CvJGVWIJvjPiU7u
         cxhZmpTCarB4F11bBVHB8oJ64JV67BQYe1790Xe5whuliazPQcH7NKgnMLaVhEPGNvKe
         t6yA==
X-Gm-Message-State: AOAM533eFV3WKBHf4ISWhgRwk6KP5zNFyGFLxy9Vc08NlbjHH8ldmADG
	EJIX5E3ki9a3eqxweaMnvPk=
X-Google-Smtp-Source: ABdhPJwd8nCaOgRfb6mdXbAKJwYlhIYmPv5Kq25qkC6wi7PtkgjVQe2mNDQE+tW1St0c5Vc6Lsh7gQ==
X-Received: by 2002:a05:6402:4392:b0:42b:612:b275 with SMTP id o18-20020a056402439200b0042b0612b275mr41609136edc.288.1653648470130;
        Fri, 27 May 2022 03:47:50 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id c13-20020a50d64d000000b0042617ba63cfsm1926153edj.89.2022.05.27.03.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:47:49 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 4BD67A028F; Fri, 27 May 2022 12:48:18 +0200 (CEST)
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
Subject: [PATCH 0/2] Refactor of vma_merge and new merge call
Date: Fri, 27 May 2022 12:48:08 +0200
Message-Id: <20220527104810.24736-1-matenajakub@gmail.com>
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

This patch series is based on tag v5.18-rc2.

Jakub Matěna (2):
  mm: refactor of vma_merge()
  mm: add merging after mremap resize

 mm/mmap.c   | 87 +++++++++++++++++++++++------------------------------
 mm/mremap.c |  8 +++--
 2 files changed, 43 insertions(+), 52 deletions(-)

-- 
2.35.1

