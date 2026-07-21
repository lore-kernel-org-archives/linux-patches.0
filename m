Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9193B1ECC;
	Tue, 21 Jul 2026 20:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666086; cv=none; b=So5L6c5p101c+TccnenZrxr8CIMdc5NuAY5gnl9FPYjUFnCaBLauDplbNLL1kaCRSFvd/+v+lg+dZWrC8N9UtZFRRQ3Nf0GQJIUJrvTtL6USHHKArBjwplVuSB3rSwvaZat7wBetCAHEtKIOxXyvKedKz5fVjv3eN1b0gA4kjkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666086; c=relaxed/simple;
	bh=VL5YkoMcDOhncISEqJduD7/A3tfTyHzG+90pdy0x/3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5kBaLuZSNKba02s17vFrxIuKZnwA8UhT1lprJbNUxdJ62vOt/DV8EhG1QKLV+/1lb2YCP8BQUlxWLQvFxInUm21Zvmf3XGt2hIW8BJky/iR2yDKgZSbkBspUAeo2vxRikLLG1C3aGyFdwYtKa08I/LIFY/PKCQNBQCbZhUqS1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/0ofTWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/0ofTWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852541F00A3A;
	Tue, 21 Jul 2026 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666085;
	bh=DtgK0sCdeSimxENOH82oD6V3xERtX8RCWwbKsJ962JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/0ofTWympghjWQgg+xC5ML9rgOk3MVFW9+eV5lj4EBenuGnzK1SK0AUjFJtxvtty
	 7G5yCjYp09DFoy6q4HgtsZcuTnK6gxIS6gd3a2TtOkPsxG4MChFUyKDl129EDv5sqW
	 aJ23Ggaa8XTC/Fe2fOyIsbLjW6jW+bD5c585q7Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <malin89@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0547/1266] bpf: Tighten cgroup storage cookie checks for prog arrays
Date: Tue, 21 Jul 2026 17:16:24 +0200
Message-ID: <20260721152454.107337566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4669a57265ad75..9fa984ee076bcc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2365,7 +2365,7 @@ static bool __bpf_prog_map_compatible(struct bpf_map *map,
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



