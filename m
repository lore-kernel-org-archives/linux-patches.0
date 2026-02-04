Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5BE1E520C;
	Wed,  4 Feb 2026 15:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218014; cv=none; b=f/UKHLy5dFsUoExTuqJnrGc1sNCwYChk2ciVYmMVsbNPWeMxUBRhsQwClEy8HXi4xNWvRlS6vidF3zkYUTQVIjLQprNjoOAXBX6O9nqVi/KzOWPsurXUGeOCT0qBiedSlSIP2YycXq0x9lqPsjgoPhKIy9MEECOD+fg5wkr9Aa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218014; c=relaxed/simple;
	bh=iD/exxZ00/GVD4vVNVXzqhp+W6e3y1oTYKL0Z+J56H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el9zloIV4aU720eFbRX5Di8etVJ1soZmmaMNiCtF0UnjgVlPxWpGTIQhZDXFlMae1CG+4XOw+jik2SJLArEBd8RlD95WW5+NnBN/rU2+ciLW0ucKofvuDuGbOnt8GcNLy03wpegUFf2ZB2Y8VF0VGSTLeoLHqZk56VC2xKhWA1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COTBCwKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COTBCwKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D98C4CEF7;
	Wed,  4 Feb 2026 15:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218014;
	bh=iD/exxZ00/GVD4vVNVXzqhp+W6e3y1oTYKL0Z+J56H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COTBCwKKj9jJBraN5pk8BFyC2nMV+w1rLgVyE9mzPp+ke0JVMozdPiiA2xaX+5JPh
	 ODAn2jcWd4nUAB/Nev/30Na72od+B0Or/K4gmypD9Jj4pRGzJxfetPxv6sZTOO1vtd
	 MriiqSDFqAffW5dJW6jmj3ncoBm35VGhQYchnbxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 186/280] mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed,  4 Feb 2026 15:39:20 +0100
Message-ID: <20260204143916.304302865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

commit dc7e1d75fd8c505096d0cddeca9e2efb2b55aaf9 upstream.

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
quotas/ directory, subdirectories of quotas/ directory are not cleaned up.
As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-4-sj@kernel.org
Fixes: 1b32234ab087 ("mm/damon/sysfs: support DAMOS watermarks")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -859,7 +859,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_stats(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -868,7 +868,8 @@ static int damon_sysfs_scheme_add_dirs(s
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 put_access_pattern_out:


