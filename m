Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5EC1DDCE;
	Tue, 16 Jul 2024 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145705; cv=none; b=O5qmpobskV63ES9mSf15W/gzbqFhs4Ymkdkoa5J38YdIxkFjyDBsfH0SR+dYu2PzeHrzb5VwsYJQJY4JkxlqiEwgZJsQ+BynlvFMtnkACAfUZNFIRtMQ7k/uBJrPgJY+CSaGE549cRWj1pCytT0fPIGZ3hImyzaSNarIwbGxrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145705; c=relaxed/simple;
	bh=zo4qLkkYm6RgtBEgS1emdjbbHig8Y83nEYEvBUmWbmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtW+Jt32CwxAAanaC437k5T10BAIdXHv7DfVAUDlQtkCEFYRVnO1bVzYv1iXSZhlQHilmgFBD8McL9Rw4q2S54DvRBHiM+UwZWM92H7gXNe4IHZhdsMjGwuuBbTUw1SmFPm6VN3H+HPPcmy5h1tM3ABZdmZtCyklKxr2cuhXCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTGjHAtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTGjHAtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF3C116B1;
	Tue, 16 Jul 2024 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145705;
	bh=zo4qLkkYm6RgtBEgS1emdjbbHig8Y83nEYEvBUmWbmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTGjHAtj6JH3xYIVB1+fcurPnLwaMLe+P34CVybiS3XfXlmJ2MXC7h/vDFc/Xx+Sc
	 U8yDuwN0guiA6OGMNu54gSRoqwGI5ZKfe9uz3Sdcm1FrbDH8QI06LvKh/cbPiNqyQY
	 2+gdgSF4BjeiZLPdABNgzaFTBVrnhIlqpMIS1OSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Kujau <lists@nerdbynature.de>,
	Mohammad Shehar Yaar Tausif <sheharyaar48@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/121] bpf: fix order of args in call to bpf_map_kvcalloc
Date: Tue, 16 Jul 2024 17:31:28 +0200
Message-ID: <20240716152752.330773729@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mohammad Shehar Yaar Tausif <sheharyaar48@gmail.com>

[ Upstream commit af253aef183a31ce62d2e39fc520b0ebfb562bb9 ]

The original function call passed size of smap->bucket before the number of
buckets which raises the error 'calloc-transposed-args' on compilation.

Vlastimil Babka added:

The order of parameters can be traced back all the way to 6ac99e8f23d4
("bpf: Introduce bpf sk local storage") accross several refactorings,
and that's why the commit is used as a Fixes: tag.

In v6.10-rc1, a different commit 2c321f3f70bc ("mm: change inlined
allocation helpers to account at the call site") however exposed the
order of args in a way that gcc-14 has enough visibility to start
warning about it, because (in !CONFIG_MEMCG case) bpf_map_kvcalloc is
then a macro alias for kvcalloc instead of a static inline wrapper.

To sum up the warning happens when the following conditions are all met:

- gcc-14 is used (didn't see it with gcc-13)
- commit 2c321f3f70bc is present
- CONFIG_MEMCG is not enabled in .config
- CONFIG_WERROR turns this from a compiler warning to error

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Reviewed-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: Mohammad Shehar Yaar Tausif <sheharyaar48@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20240710100521.15061-2-vbabka@suse.cz
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 146824cc96893..e8d02212da703 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -808,8 +808,8 @@ bpf_local_storage_map_alloc(union bpf_attr *attr,
 	nbuckets = max_t(u32, 2, nbuckets);
 	smap->bucket_log = ilog2(nbuckets);
 
-	smap->buckets = bpf_map_kvcalloc(&smap->map, sizeof(*smap->buckets),
-					 nbuckets, GFP_USER | __GFP_NOWARN);
+	smap->buckets = bpf_map_kvcalloc(&smap->map, nbuckets,
+					 sizeof(*smap->buckets), GFP_USER | __GFP_NOWARN);
 	if (!smap->buckets) {
 		err = -ENOMEM;
 		goto free_smap;
-- 
2.43.0



