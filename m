Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C703B3C03;
	Wed, 30 Sep 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791745; cv=none; b=OwwAEX5oNNtb3FHjd/A6OuAp/aA+yyqdzTJ/aYEWjSaYE6V+ytjbOuu5XcspHADJy+hD2iMkO6tgRZRvgnNdyXOJGxB4NJGjmCKRLyEJuYxrbvxwsS/5pYxWli94lyOTXeIl/lWAmo6jdv9aTacmXlvwZZSjuI0dpqqiy+qmwwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791745; c=relaxed/simple;
	bh=sBxO0ItJPIUHNY2hw2uizUYtJT+A2G82kC/ma7uK9Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkUIDHUz6CAsOZGnuDyiHkeZQgSi/BSwCXi4E83TPzeJaEQ19QaYiC6vGhH9a/+ErZpdJ2ajCzQR1IfpZTbfAhw9qNa4lmuJYTLOxCD26zXAMDAaoo6bbs8bF8527wi+GVuzOrGBubMx4MNYK7FK2wFl0EP4ewDBFN9+2nBInDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9oNPGF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9oNPGF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A40C1F0089B;
	Wed, 30 Sep 2026 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791743;
	bh=PSd0LU8KHsslTlBr7K8ZnfN5qK0MMzOv5OZwAKFxnLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9oNPGF3/A0xYxwRxi48OO0hZ2D8M0xJFQ4T5TCnxOqoNojbv4HJZLuCKnF6Bs6fg
	 C3bm89F/9XT9lAZLMctZXnOcEVFOv46p45Z9/SXvuVbEffVfqpnyGyViq/e4aTpmZM
	 I9W3+jA0piMOzkVzIsMNfbD9VZ8wZpcmBb6MHdG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/752] bpftool: remove duplicate free_btf_vmlinux() definition
Date: Wed, 30 Sep 2026 17:24:38 +0200
Message-ID: <20260930152407.105151850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Jitindar Singh <surajjs@amazon.com>

v5.15.221 backported

  a9e2496111aa ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
  [ upstream commit 66d7e39e49b0 ]

which re-adds free_btf_vmlinux(). However, the prerequisite cleanup

  52df1a8aabad ("bpftool: remove function free_btf_vmlinux()")

was never backported to 5.15.y, so the tree still carried the original
free_btf_vmlinux() definition. The backport therefore produced two
identical-signature static definitions in tools/bpf/bpftool/map.c and
the build fails:

  map.c: error: redefinition of 'free_btf_vmlinux'

Remove the stale pre-existing definition, keeping the one reintroduced
by a9e2496111aa (which also resets btf_vmlinux = NULL). This matches the
current mainline end state.

Fixes: a9e2496111aa ("tools/bpf/bpftool: Reset vmlinux BTF after map commands")
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index cf257da201951..54d855ac54080 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -828,12 +828,6 @@ static void free_map_kv_btf(struct btf *btf)
 		btf__free(btf);
 }
 
-static void free_btf_vmlinux(void)
-{
-	if (!libbpf_get_error(btf_vmlinux))
-		btf__free(btf_vmlinux);
-}
-
 static int
 map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	 bool show_header)
-- 
2.53.0



