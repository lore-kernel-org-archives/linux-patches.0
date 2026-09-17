Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A583B4EB84F;
	Thu, 17 Sep 2026 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659087; cv=none; b=OfmIanSGIWbuIWYaXNQassYtKWcSeGixFqygOK4qXpkcwhqjHoMUHuwtKEjO6M+ZntVGZNeJzpKpDi/iZeETHIq1N2Ys4a6cpmJRFB9585je8XevA+yIZlVxY89yennjS9m1fADefTy5actnj9bzQW3FB0S1wDzARvAGWCEuNgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659087; c=relaxed/simple;
	bh=+B7kAO1O4NhosPymq6P8awmuUA3+115Jic0Qeud7N5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgtFjOxX0GEFM9vBdPJIfzuvTm8b4RJYG+FxV8TZdpDVDynB7KVYcla4vIU4K/b5wE7KyPGOV81eX0AlQJorTAoAPrQZqLm7N67lW19mAXTn2jtXLZ1d3QM9p1r/n99APGB8DyoKy5ejfotcc7VDisidpcbbLkizzFlIbgC5crg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDPIlB03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDPIlB03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099031F000FF;
	Thu, 17 Sep 2026 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659081;
	bh=1yT5OYZaUZpnbTEKlwCCWQArZrTBdBuAzbndGAy78/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDPIlB03anAP/lz3kUc8WfrctOsDMjloQ9Lok0f96yjbFRrvwhSEyzsT66qKMWcO1
	 syhwTpB2l2PAbNssiebuBqy9E0SZ/e8sj5NzNQUd0vGwsmdwQyKKbtu/xd7mVymHll
	 H0Toy2Dp16QzU/8wad7ywc9W03SkvpJYFaL7phNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Song Liu <song@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 138/733] klp-build: Fix wrong index in funcs cleanup error path
Date: Thu, 17 Sep 2026 16:07:26 +0100
Message-ID: <20260917151354.471764801@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 4825ef699cda4c6f2f0586b17a5e225560481da6 ]

In the object allocation loop, when kzalloc() for funcs fails, the
cleanup loop uses `objs[i].funcs` instead of `objs[j].funcs`. Since
`objs[i].funcs` is still NULL at that point, it repeatedly calls
kfree(NULL) and leaks all previously allocated funcs arrays.

Fixes: 59adee07b568 ("livepatch/klp-build: Add stub init code for livepatch modules")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Link: https://patch.msgid.link/20260816090442.18128-2-laoar.shao@gmail.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/livepatch/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index f14d8c8fb35fa..16aff8f736eb6 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -51,7 +51,7 @@ static int __init livepatch_mod_init(void)
 		if (!funcs) {
 			ret = -ENOMEM;
 			for (int j = 0; j < i; j++)
-				kfree(objs[i].funcs);
+				kfree(objs[j].funcs);
 			goto err_free_objs;
 		}
 
-- 
2.53.0



