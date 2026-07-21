Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F73146EC7E;
	Tue, 21 Jul 2026 18:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658863; cv=none; b=YjhHO8lhs3bltgJ6e3bQQCBeSuwCUt4uiejdpxWTb44UoNF+DXb203UZ7oT7yDx0aw8HGm+hUwm6LdHZrEGz+wmrDhvvTuXXjzIMITr0q5EePxR/NTBScAjbKeWlF1AE7aqSmDI6cUHgh02GjC9PkJAzbj/1u4+7Cr5kN3MtS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658863; c=relaxed/simple;
	bh=JbdUphpmGbYWRVueG3ugJfpGjL29S2yCOypIhpTTrGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAsf9TRAcy/Z/VSOU+KagGRE9hNUVcJH/3or8Re20KhwWAg7hT30iJACE4xgljeEYGwCo4ajX9Q7DVi5WVYGC3ojIaMyN/rxOIgWmqH/c/KBAGVSNKU8IBPPLZPITlggT8CqclGK59dEJue6FUzs6QHu+FDmbxcZh1PIlglyD68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOHQVjI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOHQVjI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963061F000E9;
	Tue, 21 Jul 2026 18:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658862;
	bh=W7ZK8omQlgqCEQurY7evQekGJWk+dlJrUFeFqhizTQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOHQVjI7vZRUsYa8vSr0Es1jXbT9BWhrtDqPMwzC6TAFuXErGiAXgx0cJbq2dVYGn
	 nbmzlZJzljbDy8T93yOGdMQVUFdyQFyHdfPshwW/+vdsFT91QKe9nElv+6fvkmEy2c
	 ENMwc136TUrDrdns8Jidz8U/HipUN1gQl6MmXNyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1251/1611] mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Tue, 21 Jul 2026 17:22:47 +0200
Message-ID: <20260721152543.583376442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 05ea83ee88ca70f8932906d9f2617ff996f45b50 upstream.

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after the
stats directory setup is completed.  When the tried_regions directory
setup is failed, the setup function ensures the reference for the tried
regions directory is released.  Hence the error path should put references
on setup succeeded directory objects, starting from the stats directory.
However, the error path is putting the tried_regions directory instead of
the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation, the
scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260618005650.83868-3-sj@kernel.org
Link: https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org [1]
Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2132,12 +2132,12 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;


