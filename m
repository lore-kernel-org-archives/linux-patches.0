Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41773D3321;
	Tue, 21 Jul 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654495; cv=none; b=TERwnaLlitt4Lw36ox5a573gCPnoWUONPDAUcjk0dP9JD19I0rFLQmkxx2eTQJTFsTluUWiEQSkMfnESmXbnMsBWf/TaC77MDk3jKzRoH6R8vDfjBXmRyYFBEDJLYzUNcWPaQeAgvSuWXtDV0qNF1xQ/Cd2mEmlS27bRIXe3eRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654495; c=relaxed/simple;
	bh=j/18pwM4Y4CDsGVrmEPbSxD3n7Us+//GHpJOubHZTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAsjG2OWHBci/LpkxgsFwrXUBvgqxG2YzczOaQMSRaJKDpx3YYkjQjq1sJH/zuI43TX4Rt0dOHpJ2JvoBjjVK88eZkVjizg152hL4IE92lxUFkTzcQBh29I65yaCCeX1BHbWv7GVedsDYB0BJPT4+zkAUg651bQnZ6X/EL0K3l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcRqDdqB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcRqDdqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AD41F000E9;
	Tue, 21 Jul 2026 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654494;
	bh=1DREk57KiJMiaCys/fjdO/nwlbpUMIql7x+hov3cT/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BcRqDdqBNtmuH2G7fqF7ann/Qd9P48f5hTeiZk3xCx2+jVJ0EuplE6NunQy3ABXS/
	 xTU9alN20GwKB3ybDJfoebCooxksu+kq1yng4kZciHC0TTp6nKhnqed+9WJ0cHGywf
	 aeGDKHwyoZKEA49R55C2/sQ2V7nE0oI+zjqW4WG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1726/2077] mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
Date: Tue, 21 Jul 2026 17:23:19 +0200
Message-ID: <20260721152633.462099363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 mm/damon/sysfs-schemes.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1767,22 +1767,19 @@ static int damon_sysfs_access_pattern_ad
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


