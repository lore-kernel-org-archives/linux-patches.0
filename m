Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166C73264D4;
	Sat, 12 Sep 2026 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228074; cv=none; b=oJFCoOO5j0Z2uHr9q8W3DXzvLO/jfKPzUy1Urbhk38t1KR0//YhjBihHqTyrIYg5uoZ2TMycQ1ZK+6xuvrHgb/HcVnPn1D+0KSOno9sSPdUP6racvY5JkU3pDyFB38Oqkz9U5pThEgjXAwZekgM0VLshWn8x4BCcJWLmQNjZcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228074; c=relaxed/simple;
	bh=4rc+k/LhhIEevLvvZf6sdVjFIsJwe/cIeYNDPsRZQLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkOclVlZHvrA1xYbpLDJeTHuhorkC31Ykawed2zbbJ+Nj1Cna6/R9//bUSBy3nbzqDFnf5whsSrlZqFO5XYo4iuMElekL/CN2cO8RvF+XngzZMBEVA+AsRaAjbZkfPlxfjU7c7089Y5VBglumeVwN4+1hJQ+0t5mf4Z2qwcQb/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tozV9nYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tozV9nYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41471F000FF;
	Sat, 12 Sep 2026 15:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228072;
	bh=UjgZDSLRVtDTyVmuX0+3birtdAXVG5RwIEBjlgp1YZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tozV9nYD76jY32tnFyCr2xqPtM6azbmHfKn0JVdIgat0KbNKTElUJJ9GvRjccQCTF
	 1Z9mqtc9jUr2ob3WsFiWf+OYFCnea2IBl3x9IglIzM6681Ts4qOau1jSJvCStJdI1Y
	 PL5SnOLP16W78ZNqlaT6x0maZoi++dVjHcz86soI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0284/1191] mm/damon/sysfs: kobject_del() region and target (error) dirs
Date: Sat, 12 Sep 2026 08:50:12 +0200
Message-ID: <20260912065554.605926157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 2603ef6f6ec3d3f7de2d6a07e7c9a683cebac419 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for the normal creation path of region directories and the
error path of target directories, by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-3-sj@kernel.org
Fixes: 2031b14ea757 ("mm/damon/sysfs: support the physical address space monitoring")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1162,8 +1162,10 @@ static void damon_sysfs_regions_rm_dirs(
 	struct damon_sysfs_region **regions_arr = regions->regions_arr;
 	int i;
 
-	for (i = 0; i < regions->nr; i++)
+	for (i = 0; i < regions->nr; i++) {
+		kobject_del(&regions_arr[i]->kobj);
 		kobject_put(&regions_arr[i]->kobj);
+	}
 	regions->nr = 0;
 	kfree(regions_arr);
 	regions->regions_arr = NULL;
@@ -1398,13 +1400,15 @@ static int damon_sysfs_targets_add_dirs(
 
 		err = damon_sysfs_target_add_dirs(target);
 		if (err)
-			goto out;
+			goto del_out;
 
 		targets_arr[i] = target;
 		targets->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&target->kobj);
 out:
 	damon_sysfs_targets_rm_dirs(targets);
 	kobject_put(&target->kobj);


