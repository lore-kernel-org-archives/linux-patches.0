Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA833ADBA;
	Sat, 12 Sep 2026 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207004; cv=none; b=I2KSQuOhSeveMgvD2RItPOpaIgvwYuXGgZ+zyz6IYlh1lItQG2dVgTerfL0HNL3r/WEC+Sm6C4o0ZPteAhUtzlt5SM0R4iJznBCnMYrbh9IqnqTHEnemMDJm3X84LVp1CkuSVfAVVSVLtTT6GwI9+6IDkaeNNe8Fzi/4JEg8ra8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207004; c=relaxed/simple;
	bh=jUPENSzDCZ5hkSwVN11EJTuhUro1vmY4giuWUSSBSg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1RtYARx2RoUL32lcmzpEwBKkFRRL/xCYVvnDC25R4gvSipXqiA7R5LLbKcWhExRrHxj5QwS0wTkmXbSsnSllUu6HJtPOXQnFt/QTHpJVDncpdf/XJer82N2Dbqvdf6oXk49ONPRbwrnxNOasiFG+MMY13EyrToAOMKniMC/raI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m812/2KV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m812/2KV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15351F000FF;
	Sat, 12 Sep 2026 09:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207002;
	bh=pJ9uP8tQLw80XeJ3HD2SHMrtFVOFLJPphruaTwmaiUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m812/2KVhajh8qTqeSmIPJs7akHnIdMStDmu28zvvUSgKFAKV3bFI/Wi2mUKDAJnK
	 CWqnYZ8zmK5OQ782xxkJvlYz7A0MaLKVcpD6esxJGDBGAWEiIJMJ/d/W20oWI4k9jq
	 bO24o5Z4Ix3p1xQnKqRehadCHRE9kjGS2Hd1k3uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0280/1518] bpf: Fix security_bpf_map_create error handling
Date: Sat, 12 Sep 2026 08:40:49 +0200
Message-ID: <20260912065629.815891163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 36ffa86c42f91c8a57071e024afc4ffb51a8958f ]

Commit 5816bf4273ed ("lsm,selinux: Add LSM blob support for BPF objects")
made the LSM hook wrappers for BPF object creation clean up the LSM
state internally upon denial, e.g. security_bpf_map_create() internally
calls security_bpf_map_free() when the bpf_map_create hook returns an
error. map_create() however still routes a denial to its free_map_sec
label, which invokes security_bpf_map_free() a second time, so the
bpf_map_free hook fires twice for a single denied map.

In-tree LSMs are unaffected in practice since the blob kfree() inside
security_bpf_map_free() is NULL-safe and idempotent and none of them
implement bpf_map_free, but a BPF LSM program attached to that hook
observes double invocations. Route the denial to free_map instead.

Fixes: 5816bf4273ed ("lsm,selinux: Add LSM blob support for BPF objects")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260709073422.379247-1-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e92fd2bec98c7..b8937bebf5b81 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1593,7 +1593,7 @@ static int map_create(union bpf_attr *attr, bpfptr_t uattr)
 
 	err = security_bpf_map_create(map, attr, token, uattr.is_kernel);
 	if (err)
-		goto free_map_sec;
+		goto free_map;
 
 	err = bpf_map_alloc_id(map);
 	if (err)
-- 
2.53.0



