Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D703155757;
	Wed, 28 Jan 2026 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614276; cv=none; b=H5/uR7xYjLGNN8yMtc6dZFsjEGpoBKR1gs5CCEzti/7ZK8CPW4saehs+ggDDdSu6JAqS1mpNg/ko/+F4MgvY6TZ6J8jdjcPuSsgzogZ+J1ovrKd9PZCnrzi5fPuAzpEyYGUU7lWybHApoPCLOxECBTDf+rjRIRxhRiaH9XVzOm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614276; c=relaxed/simple;
	bh=gpeNHWzhI7tzEw+Ps3MIod7zh1+FfBmpSZL557ANRq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQEHk8POCSVWO7nk+LapPQY9YSfqFpUPVUeY2kDj84w3nIfOAHY9/b09pkrtfyo65oA3ZkpGqJ3h1AIUD1aHrR0mJ8pG9iU5KnIRiDYgeBL4vi4BkVFe0vtwU71YB0uMMJCHudlDUhfJAD95ZzGlwHGKm0tKAyXWFKDVmbK0tbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXDECCgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXDECCgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3998C4CEF1;
	Wed, 28 Jan 2026 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614276;
	bh=gpeNHWzhI7tzEw+Ps3MIod7zh1+FfBmpSZL557ANRq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXDECCgEpOUBncQiCcwv8Rzofelni987QFLKcc/mPgvzrJ4U+auGU5YXODwfGfCQO
	 yts8hNHIPjRbNQY85BOrfwZcYLHdtsLMQCpPtaRqbYVSSPtw8StqyY1s/ngYdJ3PAe
	 OC4laICTJAMrO/WDimdxYxNiv2wSmUlDxr+XZ+xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 070/254] mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
Date: Wed, 28 Jan 2026 16:20:46 +0100
Message-ID: <20260128145347.215359414@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -716,7 +716,7 @@ static int damon_sysfs_context_add_dirs(
 
 	err = damon_sysfs_context_set_targets(context);
 	if (err)
-		goto put_attrs_out;
+		goto rmdir_put_attrs_out;
 
 	err = damon_sysfs_context_set_schemes(context);
 	if (err)
@@ -726,7 +726,8 @@ static int damon_sysfs_context_add_dirs(
 put_targets_attrs_out:
 	kobject_put(&context->targets->kobj);
 	context->targets = NULL;
-put_attrs_out:
+rmdir_put_attrs_out:
+	damon_sysfs_attrs_rm_dirs(context->attrs);
 	kobject_put(&context->attrs->kobj);
 	context->attrs = NULL;
 	return err;


