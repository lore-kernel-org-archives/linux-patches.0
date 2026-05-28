Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBFB2C15AC;
	Thu, 28 May 2026 20:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000436; cv=none; b=d90wM+ZJvhnLOpzSYt3rIDYJoYNEICAkJhUkeztT6e4mNkHozCQwBSA1bTI+sUPXh0vx960A2rq3aQInaRQuyvqOOntRDU2nPPPdqTMpwyOWZo1zzRGOKLE8ytHo6YByYtc3K0gjmushzKmmTgwOKICCCN+nPLD4hnO7Sqe+acs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000436; c=relaxed/simple;
	bh=GxRniUo5F7l6fR5iEF4kTpofml50JwwAdlBNbXyBKfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmuArj1G9CQozimx1y549KmIZmhwmSfF93Acvp1kDfvOg6Qs/89wL1VPPEp+1y3uJU6GjpUhOUuQfYmXZk30Sz7yhHn9mh5sPPfF0IPpv3bEdvOMVYADwSH2jauXmCoudAuVNRasrQIA1gZ7Dpdn7fQs37Y27D+CodanjqPvvTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgnTmu2i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgnTmu2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A78A1F000E9;
	Thu, 28 May 2026 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000435;
	bh=h73JLyVf8FF2UPSRcq7kP8Ww3WUdVPtSOsuAALRgtCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgnTmu2iWvu4yQEo/Swte2aK0k/vBHvScp/YFKMkongoMvpMl0PtxqZHatI9jcwLM
	 WvC0/iB102nPA+sLalz2vNyz/pn2II1VP6sDx/vkWnRR8HRY5uHn6wFC0X4pW7kycn
	 8N7JFOpuPDQW769PFdv7vEWZOtne7/gapRI5HELs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 043/272] mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Thu, 28 May 2026 21:46:57 +0200
Message-ID: <20260528194630.586460802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit d4e7b5c4cc353f154d5ab8bb2e1ce7714d77a6e9 upstream.

damon_sysfs_memcg_path_to_id() breaks mem_cgroup_iter() loop without
calling mem_cgroup_iter_break().  This leaks the cgroup reference.  Fix
the issue by calling mem_cgroup_iter_break() before the break.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260426173625.86521-1-sj@kernel.org
Link: https://lore.kernel.org/20260423004148.74722-1-sj@kernel.org [1]
Fixes: 29cbb9a13f05 ("mm/damon/sysfs-schemes: implement scheme filters")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1913,6 +1913,7 @@ static int damon_sysfs_memcg_path_to_id(
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}


