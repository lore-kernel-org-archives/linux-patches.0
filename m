Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A747650
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 05:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jhQgpcdU6gyeXMobM0XSItVG4AvZoQZZ5MixvI3m4K8=; b=HpNHcEsQXfVvSFJkEJm8E3PUH+
	kNmfgiNbIGwx5rIrHDAkIKGVBZlEn4AOltbU3ugrKNKKkFjMHm+Z36h56aM84Eqxi/ZOcD6elNgKW
	MSj8OpTEki2t+XXAGuR0XOtpf7oDXRW3O3nO2zqCFTxasw+9HbF45Wq7kubF+jOmyEvv/rPuelMgg
	FnHG1jGNse9yhUaRetIbIapaNZQEwlJIfkjXNAhjycsYOMhD19YkxeGd1+ZqmGlVySlFMATDbAn2V
	XmlAnRZajDT4FPi2fZsJXCoaW7mT6inrtz+CZs5BC0591Z1PBmbuGQuI84SqxJnsPeODsYP7XfslU
	BTtRi4SQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pnBfp-008KKF-16;
	Fri, 14 Apr 2023 05:08:37 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: david@redhat.com,
	patches@lists.linux.dev,
	linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pmladek@suse.com,
	petr.pavlu@suse.com,
	prarit@redhat.com,
	torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org
Cc: christophe.leroy@csgroup.eu,
	tglx@linutronix.de,
	peterz@infradead.org,
	song@kernel.org,
	rppt@kernel.org,
	dave@stgolabs.net,
	willy@infradead.org,
	vbabka@suse.cz,
	mhocko@suse.com,
	dave.hansen@linux.intel.com,
	colin.i.king@gmail.com,
	jim.cromie@gmail.com,
	catalin.marinas@arm.com,
	jbaron@akamai.com,
	rick.p.edgecombe@intel.com,
	mcgrof@kernel.org
Subject: [PATCH v3 0/4] module: avoid userspace pressure on unwanted allocations
Date: Thu, 13 Apr 2023 22:08:32 -0700
Message-Id: <20230414050836.1984746-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This v3 series follows up on the second iteration of these patches [0]. This
and other pending changes are avaiable on 20230413-module-alloc-opts
branch [1] which is based on modules-next.

Changes on this v3:

  o Catalin Marinas suggested we just use kmemleak_not_leak() for both
    ELF allocations even if its init stuff.
  o Considerable amount of effort went into trying to see if there's
    relationship with CPU count and wasted virtual memory allocations.
    The new module debugfs counters helped with creating this evaluation.
    The result of that put me on a path to then add even more debugging
    facilities to rule out and identify the culprits. In the end I have
    patches now which can get this down to 0 bytes wasted. The patch
    in this series which helps reduce the allocations has a graph
    showing the findings of the relationship between wasted virtual
    memory allocations and CPU count all during boot. It is insanity
    that the graph has to go into gigabytes of wasted virtual memory all
    at boot.
  o To help folks compare apples to apples I've put the stats debug
    patch *prior* to the one that helps with allocations. This way folks
    can see for themselves what the results look like.
  o Enhanced the statistics a bit more and added an example with 255 CPUs.
  o Went with atomic_long and casting for the debugs big counters.
  o Rolled in the patch that moved a helper as David suggested.
  o Minor fixes reported by 0-day
  o Added tags for Reviews, etc.

[0] https://lkml.kernel.org/r/20230405022702.753323-1-mcgrof@kernel.org
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20230413-module-alloc-opts

Luis Chamberlain (4):
  module: fix kmemleak annotations for non init ELF sections
  module: extract patient module check into helper
  module: add debug stats to help identify memory pressure
  module: avoid allocation if module is already present and ready

 Documentation/core-api/kernel-api.rst |  22 +-
 kernel/module/Kconfig                 |  37 +++
 kernel/module/Makefile                |   1 +
 kernel/module/decompress.c            |   4 +
 kernel/module/internal.h              |  74 +++++
 kernel/module/main.c                  | 194 ++++++++----
 kernel/module/stats.c                 | 432 ++++++++++++++++++++++++++
 kernel/module/tracking.c              |   7 +-
 8 files changed, 703 insertions(+), 68 deletions(-)
 create mode 100644 kernel/module/stats.c

-- 
2.39.2

