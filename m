Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C2A34E75D;
	Tue, 16 Dec 2025 11:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885603; cv=none; b=QAdCglrOuAwAbyVGovyh9G8z/RE7+t3m7HWUkR8bpooSnDbc9RoS1B/femQl6GtBgx7gfEwBYszlqvMeP4G4/tzGoWkucscWNtT2QlFdnEyEupZ0IlaohskO8hnxCIukqZ/99yrliIJoopDkwFmIKuqt/gScbPhjasLqAO8/sb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885603; c=relaxed/simple;
	bh=S5w4xo/ogjz52YSVSfBC2K0YGxM+jz8mv6ou7UGDqhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXuRgcnn/IpCeodt4mLLIGPybt7lBf4dD57iRVbb0o6FeSOtpOy1uKfgxiia0ynMpyvcsN34oyE73BIQ0bvlKN2PlT9e4lqaX6uO9m7O8h7AYdQa/k9T/dJzkt+XaNQEuXuFJdV2jm18mbF0e9o9wMTSpX7hIiKDT7bSgdoZVEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KqT8Opy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KqT8Opy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8799C4CEF1;
	Tue, 16 Dec 2025 11:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885603;
	bh=S5w4xo/ogjz52YSVSfBC2K0YGxM+jz8mv6ou7UGDqhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KqT8Opy9s8bJ7TdJ10gYEyEQ7bpykQSL1Y4PuaYiAj05h41NDfAETOMmSzxXtxCa
	 VllkjbGn6rDWcFY+cwq2cXI1NUIThogYRJI1K/j6/9H1PRGf8OretR+iYaRuDqus+r
	 G0pWpoNpgKwS/WAQ5Uhdh1bcqRNGIpx7Qn+FmV4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 171/507] libbpf: Fix parsing of multi-split BTF
Date: Tue, 16 Dec 2025 12:10:12 +0100
Message-ID: <20251216111351.713300006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 4f596acc260e691a2e348f64230392f3472feea3 ]

When creating multi-split BTF we correctly set the start string offset
to be the size of the base string section plus the base BTF start
string offset; the latter is needed for multi-split BTF since the
offset is non-zero there.

Unfortunately the BTF parsing case needed that logic and it was
missed.

Fixes: 4e29128a9ace ("libbpf/btf: Fix string handling to support multi-split BTF")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20251104203309.318429-2-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 37682908cb0f3..ea9f3311bbac6 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1062,7 +1062,7 @@ static struct btf *btf_new(const void *data, __u32 size, struct btf *base_btf, b
 	if (base_btf) {
 		btf->base_btf = base_btf;
 		btf->start_id = btf__type_cnt(base_btf);
-		btf->start_str_off = base_btf->hdr->str_len;
+		btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 	}
 
 	if (is_mmap) {
@@ -5819,7 +5819,7 @@ void btf_set_base_btf(struct btf *btf, const struct btf *base_btf)
 {
 	btf->base_btf = (struct btf *)base_btf;
 	btf->start_id = btf__type_cnt(base_btf);
-	btf->start_str_off = base_btf->hdr->str_len;
+	btf->start_str_off = base_btf->hdr->str_len + base_btf->start_str_off;
 }
 
 int btf__relocate(struct btf *btf, const struct btf *base_btf)
-- 
2.51.0



