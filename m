Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D0330567C;
	Thu, 30 Jul 2026 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425226; cv=none; b=Tgx20/qwOmiGrPBacRBDDAmM8P9PeXztqFu/Rbx7BW8QwROGX4PoqHQktCkm+zsd9xPvJsNnt4nfgY7MGUHPVFEgyn/WltoHc4PLapQLmjPrAhm66Tu/iHM8Opwv3tQwbVaPVxdGhFvfgUZjs7LD+I6c+vBVYpbhxShy7ONYhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425226; c=relaxed/simple;
	bh=ydkdkciBoeIGd7T/y8o95u8er3zrpJEyYrX6YI4KDjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKPaF0awrzMQTdaOgZHBdhCyqnHnL7glkUpddiJ2NtLjr+IqbTszDFW7qvHfwAM/rxk27p35YTdM1Z80HFd6A8fI5o1/CwI4JN6SWEFDm9HOXQueQaiK4BWjCLX8KzKcHyi9rBBab8xGMtkb49c2EeNHp/YXMGX3529+I5MHzFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1II/Tmse; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1II/Tmse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CEA1F000E9;
	Thu, 30 Jul 2026 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425225;
	bh=+09vLN/ja9MytuWrzXa+n7UJyWsbC58tJ331viC1x7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1II/TmsePZ3VW0vUESj+c6GDaKVB0vWGX5Q/rQH9MxToWbtw8u5yppQ5A4ocbul6W
	 3MccgSJ2ohR0iqDaFMR+lviLG22nP8cL030yXb5lVRGUiuFFIvf7kop/FlrJIyGbx+
	 oeJ3gTfEMu8OzpkKdLIs++11dB1cDtUeJqOwe8yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Yang yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 667/675] mm/damon/core: validate ranges in damon_set_regions()
Date: Thu, 30 Jul 2026 16:16:37 +0200
Message-ID: <20260730141459.334804982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 1292c0ecb1caefb8ca064a3639d5673991e8810c upstream.

DAMON core logic assumes zero length regions don't exist.  However, a few
DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT
allow users to set empty monitoring target regions.  This could result in
WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel, and
divide-by-zero from damon_merge_two_regions().

For example, the WANR_ONCE() can be triggered like below.

    # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
    # CONFIG_DAMON_DEBUG_SANITY=y
    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/targets/0/regions/0/start
    # echo 0 > contexts/0/targets/0/regions/0/end
    # echo commit > state
    # dmesg
    [....]
    [   73.705780] ------------[ cut here ]------------
    [   73.707552] start 0 >= end 0
    [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
    [...]

All DAMON API callers eventually use damon_set_regions() to setup the
regions.  Add the validation logic in the function.

Link: https://lore.kernel.org/20260630035221.146458-1-sj@kernel.org
Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -215,6 +215,12 @@ int damon_set_regions(struct damon_targe
 	unsigned int i;
 	int err;
 
+	for (i = 0; i < nr_ranges; i++) {
+		if (ALIGN_DOWN(ranges[i].start, min_sz_region) >=
+				ALIGN(ranges[i].end, min_sz_region))
+			return -EINVAL;
+	}
+
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
 		for (i = 0; i < nr_ranges; i++) {


