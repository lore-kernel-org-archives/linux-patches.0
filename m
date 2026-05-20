Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0E515E8B;
	Wed, 20 May 2026 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298657; cv=none; b=b9WForIn6MRMaF2Z3a57VjhyxaP3gAsTR5elSbYSu0RG1e45+7N7VWacB6XQQAdZ6Jb9KpMxaqzbr2IDxZpa09qkFZDCTP8bIC0pu31fkHV9g7yGFFb3cxnK+n7JNKVCHD7tJLYRo9J2+axmgRlC01KCdcxXD9whQRfsqsiJHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298657; c=relaxed/simple;
	bh=4ZZU91mx0HFY55MMAd+rj38qapUduNYfgw1TW+AUwO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw+L9U1UY4vaEuI2lEg88Bi2cNuh0POWYIz5aTMN62b/O8kWk+Ots/iPqRfZ4OhNW6uKa3lZMXYK98ttLd9yFrIy8E774qA57/LOwyJLAxJ/cJ/juFYjY4WMUFgJQEBC/cLId7v4vkK/VNV2WoIKPmuX8+hGx1gOcirL7hTwMUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1jKtY7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1jKtY7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62AB1F000E9;
	Wed, 20 May 2026 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298656;
	bh=mHqf1VDMp3r3m7tV69UMCzSDJH7qslYvG95flz3MHgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1jKtY7J387CD6QTtRlm3k/egEk4oyeClw8HA23yAhjMPKy8a97lASHifSXfonQHT
	 LwXR09ZRAuqhBVdl8SAnyin8/mFjQ20sKPr84UoJZeYEgWHIyX/IvxyryWrFDirzdg
	 8oLg3wxR5fwWQd/euvXJp8ROcv/cc1+64CXcKohk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 495/957] bpf: Validate node_id in arena_alloc_pages()
Date: Wed, 20 May 2026 18:16:18 +0200
Message-ID: <20260520162145.261025026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 2845989f2ebaf7848e4eccf9a779daf3156ea0a5 ]

arena_alloc_pages() accepts a plain int node_id and forwards it through
the entire allocation chain without any bounds checking.

Validate node_id before passing it down the allocation chain in
arena_alloc_pages().

Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260417152135.1383754-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index c67525847687f..dafa179da0c9c 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -446,6 +446,10 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 	u32 uaddr32;
 	int ret, i;
 
+	if (node_id != NUMA_NO_NODE &&
+	    ((unsigned int)node_id >= nr_node_ids || !node_online(node_id)))
+		return 0;
+
 	if (page_cnt > page_cnt_max)
 		return 0;
 
-- 
2.53.0



