Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BC9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08EAC433C8;
	Sun, 13 Aug 2023 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962031;
	bh=tr6jEyLlBDIdM8vx8Fa82jezzI4IohXavw1kuEqk9ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/XxSlY6CP20BI3E8uqnAqe2VEbRQ1l9nGjwcW1UFFDgP/PWFO+YtZk0ROQdRbMhp
	 UkgQDUEOXhkyUYBevbXqGjbBLYvY/O8MnY9sP6XdrZ/mcg3MRhlEClyx2ky6OPZaIz
	 zDdgHc/4mGdFntEESr5SSowqWHdOFvbbj3IzdBg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 060/206] mm/damon/core: initialize damo_filter->list from damos_new_filter()
Date: Sun, 13 Aug 2023 23:17:10 +0200
Message-ID: <20230813211726.789359655@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: SeongJae Park <sj@kernel.org>

commit 5f1fc67f2cb8d3035d3acd273b48b97835af8afd upstream.

damos_new_filter() is not initializing the list field of newly allocated
filter object.  However, DAMON sysfs interface and DAMON_RECLAIM are not
initializing it after calling damos_new_filter().  As a result, accessing
uninitialized memory is possible.  Actually, adding multiple DAMOS filters
via DAMON sysfs interface caused NULL pointer dereferencing.  Initialize
the field just after the allocation from damos_new_filter().

Link: https://lkml.kernel.org/r/20230729203733.38949-2-sj@kernel.org
Fixes: 98def236f63c ("mm/damon/core: implement damos filter")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 91cff7f2997e..eb9580942a5c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -273,6 +273,7 @@ struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		return NULL;
 	filter->type = type;
 	filter->matching = matching;
+	INIT_LIST_HEAD(&filter->list);
 	return filter;
 }
 
-- 
2.41.0



