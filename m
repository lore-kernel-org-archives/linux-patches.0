Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AAC44AB62;
	Tue, 21 Jul 2026 21:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669091; cv=none; b=cf2aWPqAqcMM1RA/dujFXBjMgYiGXWVetpbURrPfX6cr0Xb+aPO3qJgzFHU55cQwlFa44O6h8Obnr1G2zQZPG2RG91J1CRt5YV6RH/w+CmfHJ3DxOmgNXDhZzxIfPmYYx9exZbUbfRQ1B4YiAOg88ejpzeTeHT/6ZdWmeUwqvO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669091; c=relaxed/simple;
	bh=+AZcSVHnu40MQ6/rJYulKAWCDHRWL0LPTHbVhvzToLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vz8ZLC0OzhD1IlO2PhVDVW0u9anPR5farjc1pIu5m8f/Ct93Gn8TcsvxgNiyRZHaicj6Sfm0AwcGCwuMzEV20FDyIRcJdYGdbTUFKUAajNECUJRQa5k7nUREbERBwcP5D/cbc7o+SnG18l0QwnaT2WdbrwwqlSEhfPap9ofsZqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWZ6v+3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWZ6v+3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6F31F000E9;
	Tue, 21 Jul 2026 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669089;
	bh=0JMROPqAPX9K9jJgEKnTm6I8LKDEQ/xARYMux9FksWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWZ6v+3SPE84sHsVUOFm8rHO0+saJ+FJt8UpCYn6o7+js/y56zO3hZ5OO0x4A2tLc
	 ul80UNOnBPKQaMHCxTfEtQJTCZH2c7GokQHNCqYUqvjW9i7S1l5NX9m9AhtaTLoTpQ
	 7CTBh+ujUwoxSONzMxqlTfofZnbv6H9bYXKQSVIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0421/1067] bpf: Tighten cgroup storage cookie checks for prog arrays
Date: Tue, 21 Jul 2026 17:17:02 +0200
Message-ID: <20260721152434.040001074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6924f86a8a3ff1..77044d4a80cc16 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2159,7 +2159,7 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
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



