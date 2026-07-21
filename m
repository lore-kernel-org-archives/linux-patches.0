Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4407146D084;
	Tue, 21 Jul 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656627; cv=none; b=dnFVJF4gMW2eb4l7jeGwMjAbyflJnW6ZQmpUOX/anr4/s3FLGo6wB7+MModsNXiT5902X9Np91wqT0FvCIv+Oiw8byz0JFMf5ACo5NM6t2iZ7Jqs1fYpl0qQg5Gr99LHXdl/diZe4jx06A/rk8xibixfuUnAH+13rRXSWASbugo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656627; c=relaxed/simple;
	bh=4Lrmzm0TD6fT3ZAh3iqlsit40j5eOBMFC5E/FRFot8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Khj0yL199p3iQABBgMU1LiXzaCHX5Z9HYF13hswKv1aXDuIlE3K/78dPnn4rDf5U7WwGjYSVQYExWL0d0eX0DsmuUrGxSEWYAx0HJaW//ijrEpGF0CeoqM79iGO7nToIZVBcDahosQdryGDSEoSl6ea5+luzRpwX4jMDOmGzZww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dj8SQKhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dj8SQKhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2F31F000E9;
	Tue, 21 Jul 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656626;
	bh=ag0a/SApC9T6UMZEIdyLLYeSVwzvjl8NlHmAufQIRUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dj8SQKhY5KlwIH0YoegAtOGW9MiT6NUmAYOuT93VQZlSJny5mbxj0y+lw+SpuwLT5
	 N9EvX2Dk80BLtYqBaNLdmh4xhnb+bPJ0j9P/BxTNB2Z2wxRxYVD8x7AOD0QZoB5v7O
	 JLJq/XF2qeEeHrBSlrbCvghg80+jNpHwUs1U1WoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0457/1611] bpf: Tighten cgroup storage cookie checks for prog arrays
Date: Tue, 21 Jul 2026 17:09:33 +0200
Message-ID: <20260721152525.587111814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 10627ddc0167aab5c1c390a10ef461e9937aba08 ]

The fix in commit abad3d0bad72 ("bpf: Fix oob access in cgroup local
storage") is still incomplete. The prog-array compatibility check
treats a program with no cgroup storage as compatible with any stored
storage cookie. This allows a storage-less program to bridge a tail
call chain between an entry program and a storage-using callee even
though cgroup local storage at runtime still follows the caller's
context, that is, A -> B(no storage) -> C(storage) path.

Requiring exact cookie equality would break the legitimate case of a
storage-less leaf program being tail called from a storage-using one.
Instead, only accept a zero storage cookie if the program cannot
perform tail calls itself. This keeps A -> B(no storage) working
while rejecting the A -> B(no storage) -> C(storage) bridge.

Fixes: abad3d0bad72 ("bpf: Fix oob access in cgroup local storage")
Reported-by: Lin Ma <malin89@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260610105539.705887-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b102704f89bc77..c99d3f396fdc0c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2468,7 +2468,7 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
 			cookie = aux->cgroup_storage[i] ?
 				 aux->cgroup_storage[i]->cookie : 0;
 			ret = map->owner->storage_cookie[i] == cookie ||
-			      !cookie;
+			      (!cookie && !aux->tail_call_reachable);
 		}
 		if (ret &&
 		    map->owner->attach_func_proto != aux->attach_func_proto) {
-- 
2.53.0



