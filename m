Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBFF515978;
	Wed, 30 Sep 2026 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784927; cv=none; b=a05K7mZkMwHzuS3lP7WkHx0UYT1yLBqrt4r7yATr8fKg/3C3Xs2M/hUP5xk+eNLLIyw72fdGZsUb5gyX/3+6fwj0DTFL68XkuVbtwTmv6W9yvqve2IWXoa6l+70kPw7UAk3tzUcuSLg+Yp4WXJqg5+Yh8Af2Ay3THVdJrn2W/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784927; c=relaxed/simple;
	bh=A6mL8dbzOSjCWFpocCaO2+P+xX6Yy3MyQz1Q/eJciag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NeiS2i3XAPIz83YgELm50l83hgMnJ6+VObBTqM6PQvkYj0azVKiWDtHF8i8MoPcPjLBHOgM96ubbt5WhKQQS8zUTEKM14gldu0JLJeuBvc8arz6lmwyR/maGDNCGAhSFxU/pPsF3XfAVN0drBHRByg3LlUp4/LYKW9Fk4NcQMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7W41rb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7W41rb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DED1F00893;
	Wed, 30 Sep 2026 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784921;
	bh=tSE9PYxU2M0NJZEXW3BgmXUrZwVgr5lmNlzFlF1gyOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7W41rb2097lGE/5rIpento56jJseoULzE2ywiD9AO4ZLDGe0wykKizwY/cGb4+je
	 ZJWv8Mw4CRGxXQOYIGUFxV0Oee1e0KLA5/gxMkDe5SAiWO/W9lzNRtus5l7mZ/WOgZ
	 Mtc7VFY7AGhpuuV6BqBVU4oWVabzON3au+ZlSNTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 326/982] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Wed, 30 Sep 2026 17:17:42 +0200
Message-ID: <20260930152423.821027332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 258ddc565deba..89823fa0cf6d9 100644
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



