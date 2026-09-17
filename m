Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA963DAAC4;
	Thu, 17 Sep 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665157; cv=none; b=UJmuW+/9yrGVAoOqYBsGJOTWXCY0LuQCbfTYsOgs35vLgzMXQhfiLrTfVOF2BxArejubb5p0HLLQZ88+Js+ULbVmYwsbxKEyr0tMSxadCX9DLCT4z144MYGGCjm9ZIFFFB/bPp1nlI1hBu/HU3svvju0VtMMtwYE7kJ1nQCAVjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665157; c=relaxed/simple;
	bh=K8Ww0U9UYkmo3k7qSCkDXbww++SpjumCrH48WV28y04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDNxopOYFn5NGl3ouXyre3ht3rv21f03a2hi2xwLgxyJgzQZbjEs08COpwY4vIv1NlmyEk3FItWDnHSFlfg9d++s5xa9go+rrmh2yc7ablRdsckzyKHa3bbLd2d4Uspk+DmSy+/md6GZyNhLivMJ7S5OJQdWL8Dtl6tbZURLvtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JD5OpBj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JD5OpBj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C128F1F000FF;
	Thu, 17 Sep 2026 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665156;
	bh=ptJRfzSXK7S2miLoJde++dFkqKY+OT/ZJE5P3f+YXZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JD5OpBj4zb3GuC4vvFkLXsbsHk5JbsUCDPTEzwswrddLA5Rcx1wDuj1TvLM0j7QL0
	 jqcGsYk4KaWqY0II/jte/3N2mvUVzlzM/XGCS4mr28Di+lhmWN5QVYN4NUcdlwlKGe
	 7HHtyfd1P3SB3Gya+kd8sgKrXgvCeKZJALKmt3Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0612/1250] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 17 Sep 2026 16:06:47 +0100
Message-ID: <20260917151608.464134057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 63b3c9aad399a..b362eb9f18409 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -144,7 +144,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.53.0



