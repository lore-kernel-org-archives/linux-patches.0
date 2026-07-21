Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7F46C4CF;
	Tue, 21 Jul 2026 16:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649658; cv=none; b=dPnyv6LGwUUt/rx31IMTjnCM4lfVR+WZ/ZSDM1vyTjunpbX7IsMXdz+k4ZBYpwpxxqrCszoZ6E+qByaQNUl0UJ247Oiin5CZsz01Zc8lTfHWmYS+p4RkqGwt4nwnN2bs5sg05jghedxnK8BxWW6PmKd3Hv5tbgQxs42bmJoPafw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649658; c=relaxed/simple;
	bh=jxDS83N2erW7XB2xSZUebeCm03pN5iRDsC9Eoku2b1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2GSg9vId2/TJX2nLmhGXh9M1H3Nmg5hKeMk5sRj61IJdFG/sEzUa2KGiQPaVHuMyPTRBLlrHVPrf6efPOHvqVeIQZR+G78I6wOQBlb25ALaBht6BruOxYj/L42jJiquoTvXidUrKulxjcUylj5YomFF4Hv0MsYoP8M/sF1GjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAAB+XmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAAB+XmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23851F000E9;
	Tue, 21 Jul 2026 16:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649657;
	bh=E3QFyEygmmeYXO6Ie+6oebuUOs9gB8FU/n4HDoIzm1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAAB+XmWfYtH7E+Z9qs79lUiJUxCYThQA2wdzdxg3p6rdqhHh0td4FqgvHTUqfYRN
	 nGp5V6tIve9Un+C5hTtyukohYRI2HyyhPD7f0ttWBK5eQUll1eT0arsZSh2chpGYnG
	 GqWGozMh4AXgV8dyWTduWBMXDXol9h6O/hnShHXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0660/2077] bpf: Tighten cgroup storage cookie checks for prog arrays
Date: Tue, 21 Jul 2026 17:05:33 +0200
Message-ID: <20260721152608.371857251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index de61e1894452ef..f5d9c27e654d40 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2527,7 +2527,7 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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



