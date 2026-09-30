Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BC150E5B0;
	Wed, 30 Sep 2026 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785687; cv=none; b=i6WTEZYuZlny1z7xBNiewxe4vnxxGovseRDubm2o2LuOFnHyzolLn71mdW5Bloku1+TzgnSwwBshCGdh+GcS2qBJSbQWpakzYhIUIMtIw7D8uiKAfDZ9dNwPe3s9Lbh4uxCTFfh3262iwYdeoN9R/6wznCF3WWJIDOE7EQMAQxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785687; c=relaxed/simple;
	bh=daAmoYgNext3SqVi0Mpc4ViV/2UZ5cd4oDxKuFicBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7EiZmu/8eryzigzOQdLFNPPnelmhNzQ7BSFbZsPZZJRNCm1PjhtomT2Vc39R4xcrjZa66oVN63/Ag4Z0ARABBQpkQ96U0fcoB1gk3FyYIeOHuyJNUgl9miFEfvCP2+y0ykRfBEcK74jpMT8by2Uz03opvHl37CtvECS48VIjPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTuEFg2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTuEFg2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC051F000FF;
	Wed, 30 Sep 2026 16:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785679;
	bh=6SK7NdJcjFPjWZkBWJl6EJnQSsPca9ymoGuNriQl4Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTuEFg2TeKBJ5niFqsbWdDCTRr3DtA/GT3QCdmgh2ZnepYfrQ1eZoIEo8XwvrvY0+
	 v2fcV/r35igkinKs1CGLja9zZQP2EwvZfE80SDmiDjixgcUPAn/yShMUTuxSYSkYpj
	 aOBHoMTYD+7WX/R+X1dS4U7PBmq8vrmpb0r8GY8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 548/982] bpftool: remove duplicate free_btf_vmlinux() definition
Date: Wed, 30 Sep 2026 17:21:24 +0200
Message-ID: <20260930152428.542108167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Suraj Jitindar Singh <surajjs@amazon.com>

v6.1.188 backported

  660a19e46942 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
  [ upstream commit 66d7e39e49b0 ]

which re-adds free_btf_vmlinux(). However, the prerequisite cleanup

  52df1a8aabad ("bpftool: remove function free_btf_vmlinux()")

was never backported to 6.1.y, so the tree still carried the original
free_btf_vmlinux() definition. The backport therefore produced two
identical-signature static definitions in tools/bpf/bpftool/map.c and
the build fails:

  map.c: error: redefinition of 'free_btf_vmlinux'

Remove the stale pre-existing definition, keeping the one reintroduced
by 660a19e46942 (which also resets btf_vmlinux = NULL). This matches the
current mainline end state.

Fixes: 660a19e46942 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index a77bf45d6f834..748b3def6b2c2 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -817,11 +817,6 @@ static void free_map_kv_btf(struct btf *btf)
 		btf__free(btf);
 }
 
-static void free_btf_vmlinux(void)
-{
-	btf__free(btf_vmlinux);
-}
-
 static int
 map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	 bool show_header)
-- 
2.53.0



