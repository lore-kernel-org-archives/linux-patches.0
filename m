Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD569A53
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 14:56:25 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id fu3so8998362ejc.7
        for <patches@lists.linux.dev>; Thu, 02 Jun 2022 07:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zCSSFQ2L4JXpdmXrE1zZ/i+Swl9oJ6KcROQdZ1N3Ha8=;
        b=ITZNq6NL54WMwUJGlIfxvdXqqOqhvvCVLdmzhwDzjVYtZoXqK/cElJsPRARmEaVe3x
         n+jVzu4v3nvlV2c7IJFSYkm5LXlZzZH2ujl0FiOQ9Z9rnMLleRRdaFJDfwhCfmx/Zv8L
         XNqtFYriy+qTO3tQmgY6aqVsGhqB7Hrww9Ypy9DFg/vMxYzcXYOaSe7BcTjQbClI9Syl
         2ysK/PXoPGwVP3Ns8dIW9wZRm500ED6Jr57O8MBF/3Yzl0wY+xHa79x1ja1/6hBc8XCQ
         BFQLCWqTG0ijre9u3cVf0qTPjjUX9qpH/zObaEgGaXgO+sMB0rMDymdaGebAESww0kax
         YqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zCSSFQ2L4JXpdmXrE1zZ/i+Swl9oJ6KcROQdZ1N3Ha8=;
        b=PG/VIZ3AsneF/HXmN+tnR+vB4ttTrf3ZV2MGta37g/WelcqR57a/pVuYMfsOI+77mZ
         olOmuDWeb0OJL+wZNmQxf4e2nkIV+ALdJL6objxzdU8JTTVxSDtf8hAjrxcqoN6MF4Ao
         abaL6XL7kgWd9/D6DC2npj+1tIfNSeYMW52ryWeDxR36NYBP4Wgm2I73iuTgxwBMgWAC
         DofCyyqXXAMJQxNR5UWk9u1swMZd7Gjqs3gRJBFmPCpfOAW4fleO4mWE+S7GYxmlb5Xd
         RkVlujZwQePf/I8S0VPmxPVmNniNh+mUk2nVz+n5eRn8ExjlBx+1PjFrjeAyCJSdICsj
         D7HA==
X-Gm-Message-State: AOAM530v0zsSRTUBC4RhedBDCtsTh+EvZN1ewzcWKHzRIXrfaRDVIvvX
	4rQxckLbTT5It8cg8CwapXg=
X-Google-Smtp-Source: ABdhPJyHM+S/vrNSui5eDofEaJLcLlz5Ju+mz8n8aLIwipJ9sog0+AFkOD1upwCZfy9Aj/HP+VkkrQ==
X-Received: by 2002:a17:907:6d1f:b0:6fe:e53b:7f53 with SMTP id sa31-20020a1709076d1f00b006fee53b7f53mr4659077ejc.375.1654181783946;
        Thu, 02 Jun 2022 07:56:23 -0700 (PDT)
Received: from orion.localdomain ([93.99.228.15])
        by smtp.gmail.com with ESMTPSA id wj17-20020a170907051100b006fed9a0eb17sm1800254ejb.187.2022.06.02.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:56:23 -0700 (PDT)
Received: by orion.localdomain (Postfix, from userid 1003)
	id 2879BA0884; Thu,  2 Jun 2022 16:56:57 +0200 (CEST)
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
Date: Thu,  2 Jun 2022 16:56:40 +0200
Message-Id: <20220602145642.16948-1-matenajakub@gmail.com>
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

This patch series is based on tag v5.18. This is third version,
I added a mremap expand merge test, added a comment and new variables to
the merge call and based the series on a newer kernel version.

Jakub Matěna (2):
  mm: refactor of vma_merge()
  mm: add merging after mremap resize

 mm/mmap.c   | 87 +++++++++++++++++++++++------------------------------
 mm/mremap.c |  8 +++--
 2 files changed, 43 insertions(+), 52 deletions(-)

-- 
2.35.1

