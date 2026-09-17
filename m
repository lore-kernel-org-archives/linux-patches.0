Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE6E4DDB32;
	Thu, 17 Sep 2026 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658749; cv=none; b=EPK3bg3foHdNjcMxjVcwL7+2JJFlXe/BVlupn/DSaPLldgNzLWoZezi9yDOs+dMB9t9hSqsJXqbRBrHpM7MN+7ZyHabDS//GrSyI3anflBMU2hcH+kpVi9IIZfVgP7hhqJNiTOCYiEBSakojLtv4fJqV4Ftin8kvBNRIns2Z6EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658749; c=relaxed/simple;
	bh=C+n4rByTaTxj5w75ZIC/MwupwkG9qUuLyWNP5KhXo3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=am5FWqv/9evMAVPwsQ4jW6OjGkqua8h0xPXs8scoBNkgpnb12I1VpMnTW93z+KSADzsA3v3Bp/4gLRJWmNNwVTFqzhxOP9bk5eM03E/yyinO0FLOp+61Kw8oxdOwU0jtrf56qr0DDscjce0ZNZVr07r55DIMtcPiave6d0aEZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu9f4D/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu9f4D/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AB41F00898;
	Thu, 17 Sep 2026 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658734;
	bh=EutgHvZlzcpHvQAqYRyyTl2VRkV714vCxENBdjxGZwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iu9f4D/bIyjkXv1EU43o3f4eX3Ov67ggXxBId89SVL23Bu4gpzTV/KC9tCJmDo0Mc
	 tvEv1eCTmvFkirc16GFydBjmYD5jwCuo5q1Lo+UOwy5SqWmgYZ2hltwhcqc4KoPVpF
	 Yzp//0lpy5spYCbpJE/pVto1BuQFLtqcIYMCUl6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 022/733] selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter
Date: Thu, 17 Sep 2026 16:05:30 +0100
Message-ID: <20260917151351.245995072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cb47561b4b443..437f2d35f205e 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -145,7 +145,7 @@ static int cg_run_in_subcgroups(const char *parent,
 			return -1;
 		}
 
-		if (cg_run(child, fn, NULL)) {
+		if (cg_run(child, fn, arg)) {
 			cg_destroy(child);
 			free(child);
 			return -1;
-- 
2.53.0



