Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438ED8F6C;
	Tue,  5 Dec 2023 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YBmD1r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C557CC433C7;
	Tue,  5 Dec 2023 03:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746607;
	bh=0Le3UZWSYrAFajV33gcuv4SYuXr1wPvUGT5bF5E2z90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YBmD1r5TJZ/VpQWJR9e5oYw0DpiRf3U7Ewlp1OMjOLqr1cp4tS+s7IYn7eChtewT
	 Y7cgTkNEZP4eaZvXoASbM9YBTsM0Aal4muSM7y1I5NUvGtui+3bh+PJIO9VE7i9L0V
	 rHrIvNPLwriHAePHfNCHPuxV+epjlkeNlU6G0KzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/134] bpf: Add missed allocation hint for bpf_mem_cache_alloc_flags()
Date: Tue,  5 Dec 2023 12:16:01 +0900
Message-ID: <20231205031541.082719903@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 75a442581d05edaee168222ffbe00d4389785636 ]

bpf_mem_cache_alloc_flags() may call __alloc() directly when there is no
free object in free list, but it doesn't initialize the allocation hint
for the returned pointer. It may lead to bad memory dereference when
freeing the pointer, so fix it by initializing the allocation hint.

Fixes: 822fb26bdb55 ("bpf: Add a hint to allocated objects.")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20231111043821.2258513-1-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/memalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index d93ddac283d40..956f80ee6f5c5 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -958,6 +958,8 @@ void notrace *bpf_mem_cache_alloc_flags(struct bpf_mem_alloc *ma, gfp_t flags)
 		memcg = get_memcg(c);
 		old_memcg = set_active_memcg(memcg);
 		ret = __alloc(c, NUMA_NO_NODE, GFP_KERNEL | __GFP_NOWARN | __GFP_ACCOUNT);
+		if (ret)
+			*(struct bpf_mem_cache **)ret = c;
 		set_active_memcg(old_memcg);
 		mem_cgroup_put(memcg);
 	}
-- 
2.42.0



