Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF27502D76;
	Thu, 17 Sep 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668703; cv=none; b=Z+Lsp3btMX6gf/uEkCMptPtqfjR2xpiF0l1jyHbIPotJONRF8soExfZLah48pIT5GOb9WxSHtJ8TpwNCfdlNwjG2PgCnLZyPReBMxb790GAeNGL7aqvAlfaGeI6+ETNeuwyPfJVq+fV7SYnLwF1QWu0ujtNpcZPtNvA3C5OEIm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668703; c=relaxed/simple;
	bh=7Kyt5wVtxpiFbLkm/5QFU9VkXDvZKd3zuejkD7izfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eOSTgTuSulzK3AvmJuus97aBF+eJgbhmRLNcwrHQAhqMtFMHHykV+NopQSIe8Hf4nUidb8qhafeNtFeyXNLDaXqQK/mGuhpmaz1YIE3EdPHCrp5DdlWI4pIHi0Lft1G7Lh4T3yq/UiEeYgmGmGQltBn7c1hmAH0WuRlzb6B3vEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPznhedB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPznhedB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE091F00893;
	Thu, 17 Sep 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668702;
	bh=DI/1tuWSJI4Xi/3ZjNBUH26ad88Zj8fNiKZGkpbtTm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPznhedBxwoQgy8qswxUbGi78boY0YUQOFY/mWM5dF2andkJelHzvrPa4bjkhOWr6
	 Snl6SYC6Zu11/llvDV1F1PbGf4nM9PXfjAYl6UyLhBDAxibvna1fEKsgpyJ9zOT2Zt
	 JXTQej56eXv9qKAlsZciYrDWdYGm4IlA/R+TMaTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0510/1102] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 17 Sep 2026 16:07:33 +0100
Message-ID: <20260917151552.547109563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96693d8772be2..4f5dbedbce757 100644
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



