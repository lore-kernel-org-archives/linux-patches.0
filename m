Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A401C21D596;
	Wed, 25 Feb 2026 01:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982956; cv=none; b=f3o47y11d7r0WWIzGm5zWqiFtyp7/qYwUWTchkUUfwkNLKtuKvx4+d54UsuirkIs0wQvrBI/4++nq68Z2PMrzIhmcQn2Wb6XHMOoNTKG1v0Q8TZPuVWgcgEH1Asdi5/LLzd/Bmcp88XRRzmzjHAL55pzKbYYrq/Akcw+orQLxp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982956; c=relaxed/simple;
	bh=/Z/V4S0G2xqJqfA2UBSVHLLl+PhSVWE9cAT81boftaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrIdeixZFD+Wow61wTjZp08wYo9l1OvCsuI6lT2UE5yFPU9qus5qyHcpjTu2ReUWPsWafGsGu1hbhA15g9Bz4JkU2Y2pqe1OX0hgKanfwQ6ec8H5BYMOppRHJ9ydJoJxXTwSduIO0mNeILt/85hvBHDuRAbyK+y2SgDj4OKAgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMwwURzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMwwURzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FD5C116D0;
	Wed, 25 Feb 2026 01:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982956;
	bh=/Z/V4S0G2xqJqfA2UBSVHLLl+PhSVWE9cAT81boftaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMwwURzsev+gIhEv98gQVsZa8XWCfrCbMgzoDiiKGGQk+CPbVWebHJghmEFRoY3+K
	 pe/MgnEA+uSnh7TryWMxqHzdjymZX8ZhmdtfKJJzgZ5BtwNQJ2zJlt8mlcbclsj5bp
	 kG753YusSfngdXfpip2E3zZ5TbnmWg+pS2Jed8b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toshi Piazza <toshi.piazza@microsoft.com>,
	KP Singh <kpsingh@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 133/781] bpf: Require frozen map for calculating map hash
Date: Tue, 24 Feb 2026 17:14:02 -0800
Message-ID: <20260225012402.931400348@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KP Singh <kpsingh@kernel.org>

[ Upstream commit a2c86aa621c22f2a7e26c654f936d65cfff0aa91 ]

Currently, bpf_map_get_info_by_fd calculates and caches the hash of the
map regardless of the map's frozen state.

This leads to a TOCTOU bug where userspace can call
BPF_OBJ_GET_INFO_BY_FD to cache the hash and then modify the map
contents before freezing.

Therefore, a trusted loader can be tricked into verifying the stale hash
while loading the modified contents.

Fix this by returning -EPERM if the map is not frozen when the hash is
requested. This ensures the hash is only generated for the final,
immutable state of the map.

Fixes: ea2e6467ac36 ("bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD")
Reported-by: Toshi Piazza <toshi.piazza@microsoft.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260205070755.695776-1-kpsingh@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f89aa142f71b8..ce7db2f3be6f6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5314,6 +5314,9 @@ static int bpf_map_get_info_by_fd(struct file *file,
 		if (info.hash_size != SHA256_DIGEST_SIZE)
 			return -EINVAL;
 
+		if (!READ_ONCE(map->frozen))
+			return -EPERM;
+
 		err = map->ops->map_get_hash(map, SHA256_DIGEST_SIZE, map->sha);
 		if (err != 0)
 			return err;
-- 
2.51.0



