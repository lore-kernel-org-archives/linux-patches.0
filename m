Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0415151812D;
	Wed, 30 Sep 2026 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791265; cv=none; b=Y8K+BSrGYU0Y+79qv4ctu+qSUySfhUijckP7QXjhg26WrGMGHua4D7lAg6V67DQuDSQsyT+E/TrWXhPJr831irnihRXVhVfi/fFLwxTVAuG5O1oGwA7mKXVDet6tQpDCpBy8Ee4Vmr2VqbC6LHANMQ4BNnhsbUyMAUa8eCSxueU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791265; c=relaxed/simple;
	bh=pCoyP4f6qRD/kfgLPRg2QWXpOi8PDDVKEOnU/EDVeEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahOW+PPpkklfjlgGL7rh8XMViUuBMHzU7z/eza6FZqS/l/dZWm4lv6HGv4eL+amonnc4BgMjKTojxCE1uJXPnRLaR+3+BW4pljrbLZKz4XbqLy6ubzVw8R8hxQ4wTMnsv46axT8NYtp/IPZ/DpTdiIf+IOplQmxE606a+LYziNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdM1BCXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdM1BCXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7D81F000FF;
	Wed, 30 Sep 2026 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791263;
	bh=RUWYUpB4L2nUyxxxJRgdWV9zesWGVhppGeW3sS2YIlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdM1BCXc6jkE9YRvbbAo7l03gTnd9sF9gHpJf+HESZgrAAWwS89HFGAeGeq+XR/4k
	 l5Slef0z9GCLm3h9w1KrgqW7pCJotii72Ws0OwloMty6wAGlIq8IzQ+990/S1l51SC
	 u6ei0V5UNFU0hBWzC48UlrEboDGx2BJ6P0xID6k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/752] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Wed, 30 Sep 2026 17:21:51 +0200
Message-ID: <20260930152403.482839177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 22b31ebb35139..c960289a4f09b 100644
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



