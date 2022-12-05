Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5460115C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E12C433C1;
	Mon,  5 Dec 2022 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268557;
	bh=NUFv0DyH18mwJW/mEY+OBgsT0PSVlZJOKqeBg1PceQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrUuVztqDjRa6G92H/CbsEGBNSzLgzuIO69TwzZ1nc7taSbjZDqmkYfPKZ5eWSuXy
	 dO1P42LTkYbqAEfKojTRRFUFPaU0b4Iu0amrZJqsC3MVKqmcjb1fX7ogyPCEWVZs3V
	 nt5ryMTxJmON3GCp+F7/jxK9iGwQpym+S+4eu0T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/92] bpf: Do not copy spin lock field from user in bpf_selem_alloc
Date: Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190804.180781359@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 836e49e103dfeeff670c934b7d563cbd982fce87 ]

bpf_selem_alloc function is used by inode_storage, sk_storage and
task_storage maps to set map value, for these map types, there may
be a spin lock in the map value, so if we use memcpy to copy the whole
map value from user, the spin lock field may be initialized incorrectly.

Since the spin lock field is zeroed by kzalloc, call copy_map_value
instead of memcpy to skip copying the spin lock field to fix it.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Link: https://lore.kernel.org/r/20221114134720.1057939-2-xukuohai@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 5d3a7af9ba9b..8aaaaef99f09 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -70,7 +70,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 	selem = kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
-- 
2.35.1



