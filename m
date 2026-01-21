Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EC03A961E;
	Wed, 21 Jan 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020397; cv=none; b=TV2r90A8cMc03VGA/EIu5hiYDklgRo+2HBlXhbR6UQKNNd4qtnFPMqkbuF3dfYULr9d81Gmc/Kif16/JjvBSNmqnmdfH6OyoxWFci2XaGj5oQGOpKnfHzku8WWQN1wZIH92wqO1NyklmOq4gcjnc1uoSvnq/k8veA6d5T+XVIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020397; c=relaxed/simple;
	bh=PY1PeRMiAConk3AmQKE1ug9Whe4+wqg5e9b9tERYgiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5S/9CF3Ys6J8mBUJjDejxTQX6U3yhVhad5/6Pbg2/8dJJ3E7Hy60roDJSYHGGwY8k3cgqaErcd7DHrsnW3VBprLCovKc5jIYt7v/dUeK8zvipuMS1dX/dOis6WJusKGlPcXcY2m7trus7BeazwoRjYvxDym0bFx7KnGAu5U2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpUcDEuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpUcDEuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8067EC4CEF1;
	Wed, 21 Jan 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020397;
	bh=PY1PeRMiAConk3AmQKE1ug9Whe4+wqg5e9b9tERYgiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpUcDEuhk7d5DqwzvFovtd3Fp5yi33b/sQemPVMd1gyi/gUfm6GFTb7X4TPmySUo9
	 ZISvryHxu1zVbLEltdNaocfz2X7mNG5TAO0tLECGDDcS6iMVDDh4xm1War2h1Z8oFw
	 91Iez2mnOBnj5rCZbdBP3ywnHqVUffjD1fBIOyRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 146/198] mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
Date: Wed, 21 Jan 2026 19:16:14 +0100
Message-ID: <20260121181423.814298944@linuxfoundation.org>
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
@@ -922,7 +922,7 @@ static int damon_sysfs_context_add_dirs(
 
 	err = damon_sysfs_context_set_targets(context);
 	if (err)
-		goto put_attrs_out;
+		goto rmdir_put_attrs_out;
 
 	err = damon_sysfs_context_set_schemes(context);
 	if (err)
@@ -932,7 +932,8 @@ static int damon_sysfs_context_add_dirs(
 put_targets_attrs_out:
 	kobject_put(&context->targets->kobj);
 	context->targets = NULL;
-put_attrs_out:
+rmdir_put_attrs_out:
+	damon_sysfs_attrs_rm_dirs(context->attrs);
 	kobject_put(&context->attrs->kobj);
 	context->attrs = NULL;
 	return err;


