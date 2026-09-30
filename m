Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5986250276F;
	Wed, 30 Sep 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782859; cv=none; b=RxX2n2FT+q7nLBrApkDkAYZ0qPu8MMZ/gnEo2mSZiJ1EJXoJTccARPPgrySxv9LIaw7x3BJQdjdY2vUv2e7r6AlOGd1z6U7UGuS7BMTZ55h+17J1L+QwU5xttkJvcnHWX/OSagOaDPlkl6v0KeCxY9xw5Debq6B+NkcUnjjLxUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782859; c=relaxed/simple;
	bh=rdqWCEawE3bYHmGcdKbCqTWVg6H2hyK9wXwE77l1qDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2/OY4d9f68GsuhhwUtWjgZrDSa36zFrGj/T7syRGQ8YsDoojVTEozIK/9oKFwrLwwR7X0Iikp/0IU3Jb77CCAiyvDitfo5WOyU6ElDSfr/asdSHFmY9F4eYyHPKiDnmpDB2Ctg/6e3caeoco0JhAym/5vChKqH1r3jirvwJXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoipnQpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoipnQpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04781F00898;
	Wed, 30 Sep 2026 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782854;
	bh=R6GMx+dPguYD6nk6PQ8s9sKKtvcgv/GP0RMiMd+A/8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DoipnQprw6JJe4RgXMiCkAxQZpw9wk33aoqEFpFigKRFfbNELfJ5FQRMhiynmgbon
	 +Y72NByyOwMBhZMEZR0Z9pmv+A9KqsbLoAI8jd0rk00KJOdfauDRmlqvZRFPoaBxza
	 B5ucshzOQ1/eElOiVkzOw8gqf4A1ZOORAQbgYy8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/595] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Wed, 30 Sep 2026 17:21:25 +0200
Message-ID: <20260930152351.870653099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit a8c6daab4b0e276508b7ffdd66c60fd3020a9178 ]

cg_run_in_subcgroups() discards its arg and always passes NULL to cg_run(),
turning the (void *)100 from test_kmem_dead_cgroups() into NULL so no
allocation occurs.

This makes test_kmem_dead_cgroups() falsely pass without exercising the
"dying cgroup with charged slab" scenario it intends to test.

Pass the arg through to cg_run() to fix this.

Fixes: 933dc80ec262 ("kselftests: cgroup: add kernel memory accounting tests")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_kmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 0941aa16157e3..3810dd798aebb 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -140,7 +140,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.53.0



