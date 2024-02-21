Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBE86F074;
	Wed, 21 Feb 2024 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522606; cv=none; b=lQMPvhDOY1BGRs1fSCP1tHr9lk37W25s7eMLIhEvjfNze2hZR9kiuV8ssNLGDraI7DVkkxssKiMu6cg4G9FBQS/xg4/W1aMPfFyEpDbrChLeVrJhm+8wlQ+cvIwvE5jOahoep60dMQGi33sWyB/5WcP9AN+dh3eFPtmQy8bAWyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522606; c=relaxed/simple;
	bh=ZRCXTLPJIPYw/fwZM5N6yqLKSJ37XJBlmgPb9He6Cfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2Xdgp3MEpWqGWc4LjDy7R+QuK34iS3z755b6d3eS7AXglnvziPrbTjGKRvr+fJ2QvpcdUViOeh/PiFmAlA+OY3q4dzZRHapeAw2Qd6WShXHXFnXx8jxLMBvaaV0z5rWBomA5vtXmYS52Nmdnxg3MkZ0Ty8C9kqXTrkcddCu5tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+LSDayv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+LSDayv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46739C433C7;
	Wed, 21 Feb 2024 13:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522605;
	bh=ZRCXTLPJIPYw/fwZM5N6yqLKSJ37XJBlmgPb9He6Cfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+LSDayvnH2f99TcjlA9Tkug3NZJDy2w8u0kFizgaXHBLMxJXimOVdlR1U958PZTj
	 gpfq0o3YSZ1VcuOMTepTu5Zr2UjjsRtPX/hC2wjulwKSkmB2VNSeDbXGnBYfwOlZCi
	 56koSj+54M0wrJCu3Nar5Pk3Yqd1Nvoh8jVYHjWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/476] bpf: Set uattr->batch.count as zero before batched update or deletion
Date: Wed, 21 Feb 2024 14:03:51 +0100
Message-ID: <20240221130014.557139494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 06e5c999f10269a532304e89a6adb2fbfeb0593c ]

generic_map_{delete,update}_batch() doesn't set uattr->batch.count as
zero before it tries to allocate memory for key. If the memory
allocation fails, the value of uattr->batch.count will be incorrect.

Fix it by setting uattr->batch.count as zero beore batched update or
deletion.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20231208102355.2628918-6-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index dbe98040e855..64206856a05c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1314,6 +1314,9 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1372,6 +1375,9 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
-- 
2.43.0



