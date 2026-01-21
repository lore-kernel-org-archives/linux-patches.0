Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572D3191A0;
	Wed, 21 Jan 2026 18:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020498; cv=none; b=bXnPTavMO+AQKoN3cuvsZRfoB+XVeXxbJ1E2GizUmZTInQZc6shW2W1tFafZsXuimDT0aJ8YlCfi82vyV06LQiAbDR8OIDH8T9wY1mmgs9CysxbHHcxgIFum5biC8semWVaOqU9tdv9RdnrIy9xlQd7Ho8IF8Y/iey+ju5v4Vn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020498; c=relaxed/simple;
	bh=I+ATSU52BrFY4lKIR2759dBiq8pgx5FX2XUCCizp9q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBtJ1JhtMOKQ7CRqJtFZmLgDQvsNN34kRjthbRGX71nv+dQMM4mzlqRdEURm3cp2Pq56Wu2Dh6laYe+KNBaGDaXkaa4SMAbGK/lmyD60MEs4g2wz7++1R68VRqU/moyLZq/LM/dGZcztH1i8GZ44ipBqrlTn67v1lNxRDp6v9R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baeONCOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baeONCOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DCFC19424;
	Wed, 21 Jan 2026 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020498;
	bh=I+ATSU52BrFY4lKIR2759dBiq8pgx5FX2XUCCizp9q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baeONCORU4JH0fWHTWHtoeZtJSLT711q8zAILcfWOrWh71blZCLg3MRVdD/LXSO0E
	 YGh8Z/K5GmCa/whtHKV6MIxEPsPK2P1WfRvPi5v4ZejGp6GOJT3do/ZBysTyyVdlG3
	 2dxJtwhFhNvCSUCAczeXgFFQcmGxlQMPjqxD3LL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 143/198] mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed, 21 Jan 2026 19:16:11 +0100
Message-ID: <20260121181423.700591087@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2117,7 +2117,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_dests_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damos_sysfs_set_filter_dirs(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -2142,7 +2142,8 @@ put_filters_watermarks_quotas_access_pat
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 put_dests_out:


