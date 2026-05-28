Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A18F31159C;
	Thu, 28 May 2026 19:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997976; cv=none; b=M2EEy0gcGRbgXBkWnHrgA+hRQvfV5094fBS27gRvaT6cN4JdjtGSBvey0D0Y5Xv9QOmLu17RRXqoCaIDJK8sdHkFtEnO7E2kIioe4gsjSzMVht49vQX0xTAbz+gDMwc/QdriZtpUhqesueYFFIO3tiTNsCf0v52qlCzBfO6gqnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997976; c=relaxed/simple;
	bh=iymlFJRWxbRKZuzf2kXTZ3KCrfqaEPWk8bafW37N0x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvRuiOnDhQqDrz2kqKCl0h4PUCWp+KKdCbO0aqMHCRexzpB+3/dJClR9dKgHfFgKpFbU2tqYn5X7FQejCvSBfq9gsH4BKFEkKw1THmDSowW9D3a3YQsGcBaTmRd2OX/9CtvSEBePlc+Oba5MqhWxV1QWQEEN73QgCHIi5UTEw58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDJz3VXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDJz3VXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427DF1F000E9;
	Thu, 28 May 2026 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779997974;
	bh=qYs+Hc25GsIvivGsvSDByMZc/x1eN0cSKgGFfe+RFv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDJz3VXJ8jZb/kGbHwDuuwEDqQL4wgzkELyc9iirQqURM3P5Ornol8cvXXmv6lmjy
	 mjm8/0coDfNjdEsWIJXW/pUoIkE925X4apfThKr3hfLVKy6yo8Ri/uYsBY+bVHvKXy
	 fe110VgL+bXvnFcx4cPEg9eTQSOKF7MiiXKWAWPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 010/461] mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Thu, 28 May 2026 21:42:19 +0200
Message-ID: <20260528194647.145459409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2537,6 +2537,7 @@ static int damon_sysfs_memcg_path_to_id(
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}


