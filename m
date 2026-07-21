Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8E44AB62;
	Tue, 21 Jul 2026 21:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670737; cv=none; b=EacAYNp/k8H52i8Ufjbr1E+b3rpVJbEBgb+1NqmGmLFG97Whubtn5sS/9aln4ddhMYi8YH6rRhSFKjpostiD5s5ymqyARh5XCZdfOKoIQiM94LknXatzMqaokSU0/xPSRG5pQHDvBycjFEz0RfGq0CO7rH0VgpGogMR6/Yhx1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670737; c=relaxed/simple;
	bh=ZWx9TpiInU3/+qW1v/WL/Y+zz1u8TSUIdHBt9QoRubA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uew/Y8pkXmsIGjzNS/qQQarLktSY/mjwWtt2WrerXngoRPJDSWuRZ8XR/nzagaeWkPu6KSUqGU9PpfAKY2/ehCZutQgS5dTFJeahQio892BhP62TpxlZcbc81W55L98ioxGE2Qbdrw3JCN4KD/f2zohV5cMGqZc+FrzniUYRdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKp8sIMx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKp8sIMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6705C1F000E9;
	Tue, 21 Jul 2026 21:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670735;
	bh=5faTtcQuWoQ5pB0epXWIR3rqt60K2rhZjiO4/6b7UPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKp8sIMxnMf06s+aT9mXeqvZawm5b7Dcf8751ijJcNgGqUTZIDwHj86I60nmBF/j0
	 syXD71oZ4UsEv/J3Z83KsY4pp70I6D43NrZy1azcJMBzbrG4hbTD9eSR6PficM2itH
	 HdjA3oYzKY9vxuMjK9PEpJhlTn5XMVpAT54f3eus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 1045/1067] mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
Date: Tue, 21 Jul 2026 17:27:26 +0200
Message-ID: <20260721152447.969569601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit d58fdbe37a829fd2e5803dd4e5a72992dd8c5368 upstream.

Patch series "mm/damon/sysfs-schemes: fix wrong directories put orders in
error paths".

Error paths of damon_sysfs_access_pattern_add_dirs() and
damon_sysfs_scheme_add_dirs() functions put references to directories in
wrong orders.  As a result, uninitialized memory dereference and/or
memory leak can happen.  Fix those.


This patch (of 2):

In access_pattern_add_dirs(), error handling path puts references starting
from setup failed directories.  If the failure happpened from the initial
allication in the setup functions, uninitialized memory dereference
happen.  The allocation failures will not commonly happen, but the
consequence is quite bad.  Fix the wrong reference put orders.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260618005650.83868-2-sj@kernel.org
Link: https://lore.kernel.org/20260617060005.86852-1-sj@kernel.org [1]
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -679,22 +679,19 @@ static int damon_sysfs_access_pattern_ad
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->sz, "sz");
 	if (err)
-		goto put_sz_out;
+		return err;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->nr_accesses, "nr_accesses");
 	if (err)
-		goto put_nr_accesses_sz_out;
+		goto put_sz_out;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->age, "age");
 	if (err)
-		goto put_age_nr_accesses_sz_out;
+		goto put_nr_accesses_sz_out;
 	return 0;
 
-put_age_nr_accesses_sz_out:
-	kobject_put(&access_pattern->age->kobj);
-	access_pattern->age = NULL;
 put_nr_accesses_sz_out:
 	kobject_put(&access_pattern->nr_accesses->kobj);
 	access_pattern->nr_accesses = NULL;


