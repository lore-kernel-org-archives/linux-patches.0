Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8631B1803B
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaE1Jx6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB106C433C8;
	Mon, 23 Oct 2023 11:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061546;
	bh=0NfI+EcaaDRLUj7pYDOjaHYqwH4CcOrqNeKg96MzlrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaE1Jx6OSMZH9YG/s9LDB4RanuXDpK3xB8Ryy4Yde3lNl1y/Qr9u+7WpH0Ukgh81P
	 9YY31WelcTlLAfHlhbfAskamedOpwxEVez8Zp6DH/i2mrCEB1KAn+00ltELCJXQFKF
	 /VZU9yJgQJi1ykD40s5qa3Bg1N56VJCg3zcvD4wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Mark <lmark@codeaurora.org>,
	Georgi Djakov <georgi.djakov@linaro.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	pjy@amazon.com
Subject: [PATCH 5.10 083/202] mm/memory_hotplug: rate limit page migration warnings
Date: Mon, 23 Oct 2023 12:56:30 +0200
Message-ID: <20231023104828.967818598@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Mark <lmark@codeaurora.org>

commit 786dee864804f8e851cf0f258df2ccbb4ee03d80 upstream.

When offlining memory the system can attempt to migrate a lot of pages, if
there are problems with migration this can flood the logs.  Printing all
the data hogs the CPU and cause some RT threads to run for a long time,
which may have some bad consequences.

Rate limit the page migration warnings in order to avoid this.

Link: https://lkml.kernel.org/r/20210505140542.24935-1-georgi.djakov@linaro.org
Signed-off-by: Liam Mark <lmark@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <pjy@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory_hotplug.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1279,6 +1279,8 @@ do_migrate_range(unsigned long start_pfn
 	struct page *page, *head;
 	int ret = 0;
 	LIST_HEAD(source);
+	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		if (!pfn_valid(pfn))
@@ -1325,8 +1327,10 @@ do_migrate_range(unsigned long start_pfn
 						    page_is_file_lru(page));
 
 		} else {
-			pr_warn("failed to isolate pfn %lx\n", pfn);
-			dump_page(page, "isolation failed");
+			if (__ratelimit(&migrate_rs)) {
+				pr_warn("failed to isolate pfn %lx\n", pfn);
+				dump_page(page, "isolation failed");
+			}
 		}
 		put_page(page);
 	}
@@ -1355,9 +1359,11 @@ do_migrate_range(unsigned long start_pfn
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret) {
 			list_for_each_entry(page, &source, lru) {
-				pr_warn("migrating pfn %lx failed ret:%d ",
-				       page_to_pfn(page), ret);
-				dump_page(page, "migration failure");
+				if (__ratelimit(&migrate_rs)) {
+					pr_warn("migrating pfn %lx failed ret:%d\n",
+						page_to_pfn(page), ret);
+					dump_page(page, "migration failure");
+				}
 			}
 			putback_movable_pages(&source);
 		}


