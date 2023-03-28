Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBC58476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24687C433EF;
	Tue, 28 Mar 2023 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015271;
	bh=uRn9642UYB/ULa9Bl5o1Ykjow+6emQLokVlQy1uB6Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGIcFjXmskbpUX0VF3CKVJ/QDwhSycD/K1RDSi4b/4gRnYngiskquKewMXrqkjYvB
	 21+Cc4q7gLtZLTwB9+m6ahijNfWLMMedAFXsjC0DtNhVj/YcjzGQ7MduvDO5xUul7p
	 88wZqM8sAH+31OlFfR7NhLxW2YrRuRhJIiFwSqj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Jann Horn <jannh@google.com>,
	SeongJae Park <sjpark@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 201/240] mm: kfence: fix using kfence_metadata without initialization in show_object()
Date: Tue, 28 Mar 2023 16:42:44 +0200
Message-Id: <20230328142628.042035097@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Muchun Song <songmuchun@bytedance.com>

commit 1c86a188e03156223a34d09ce290b49bd4dd0403 upstream.

The variable kfence_metadata is initialized in kfence_init_pool(), then,
it is not initialized if kfence is disabled after booting.  In this case,
kfence_metadata will be used (e.g.  ->lock and ->state fields) without
initialization when reading /sys/kernel/debug/kfence/objects.  There will
be a warning if you enable CONFIG_DEBUG_SPINLOCK.  Fix it by creating
debugfs files when necessary.

Link: https://lkml.kernel.org/r/20230315034441.44321-1-songmuchun@bytedance.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -726,10 +726,14 @@ static const struct seq_operations objec
 };
 DEFINE_SEQ_ATTRIBUTE(objects);
 
-static int __init kfence_debugfs_init(void)
+static int kfence_debugfs_init(void)
 {
-	struct dentry *kfence_dir = debugfs_create_dir("kfence", NULL);
+	struct dentry *kfence_dir;
 
+	if (!READ_ONCE(kfence_enabled))
+		return 0;
+
+	kfence_dir = debugfs_create_dir("kfence", NULL);
 	debugfs_create_file("stats", 0444, kfence_dir, NULL, &stats_fops);
 	debugfs_create_file("objects", 0400, kfence_dir, NULL, &objects_fops);
 	return 0;
@@ -883,6 +887,8 @@ static int kfence_init_late(void)
 	}
 
 	kfence_init_enable();
+	kfence_debugfs_init();
+
 	return 0;
 }
 


