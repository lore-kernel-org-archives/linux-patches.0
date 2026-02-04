Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B2542188E;
	Wed,  4 Feb 2026 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217585; cv=none; b=DBFLYgvnlCl534do/08h+Wl88GJkOVETOGoiLaYom8t3ROhjDbeXSZp/4zHanilzQLewJlehy/e6ajoVcgXluDZ3pJERN82MgRiSJ/FpV3UJQB5uCUSQKaDJkr9vBqByAqGCdR7HlZFGOE574/Gm9E0KlXerKLLA4cQ4ed1bRrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217585; c=relaxed/simple;
	bh=qay+nlP7Ma5aspsExp/WzkB2E76fwIVBVQ4O1BQT6oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCpS4nKmgTzKRA5/yaYlpuDhnvPHt0U4XkEIfMREoiWHfGpf4IaLTUCbXtRj3DCggH2+AcKWuyo2MDGj8ECEJ/clD3CBpfzMBbZwIGWPxh9gnrQje6cDXL/Rc4cf5SsoXwdKFbQ3dF5cq7a4ffh+rt8FhSH5oduwyBzHVTBoAxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1MrBTKUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1MrBTKUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DB4C116C6;
	Wed,  4 Feb 2026 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217585;
	bh=qay+nlP7Ma5aspsExp/WzkB2E76fwIVBVQ4O1BQT6oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MrBTKUoF7hzl/vgCPbZrQIfQDY53x9FWWkng7sECv1GabNGYJSEvL//Jl6x8f29W
	 blFnMqgAJCYyA6WuuyJxEFQSzOBlo1fcEUHO1dnWgdVFce23PXDlWlPe8AsDFnqjUO
	 wYpNAbAW8kVlIsKdnHJBGfJGE7AG7HsjL9i6ML8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 060/280] mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
Date: Wed,  4 Feb 2026 15:37:14 +0100
Message-ID: <20260204143911.813062563@linuxfoundation.org>
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

commit 9814cc832b88bd040fc2a1817c2b5469d0f7e862 upstream.

When a context DAMON sysfs directory setup is failed after setup of attrs/
directory, subdirectories of attrs/ directory are not cleaned up.  As a
result, DAMON sysfs interface is nearly broken until the system reboots,
and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-3-sj@kernel.org
Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1772,7 +1772,7 @@ static int damon_sysfs_context_add_dirs(
 
 	err = damon_sysfs_context_set_targets(context);
 	if (err)
-		goto put_attrs_out;
+		goto rmdir_put_attrs_out;
 
 	err = damon_sysfs_context_set_schemes(context);
 	if (err)
@@ -1782,7 +1782,8 @@ static int damon_sysfs_context_add_dirs(
 put_targets_attrs_out:
 	kobject_put(&context->targets->kobj);
 	context->targets = NULL;
-put_attrs_out:
+rmdir_put_attrs_out:
+	damon_sysfs_attrs_rm_dirs(context->attrs);
 	kobject_put(&context->attrs->kobj);
 	context->attrs = NULL;
 	return err;


