Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6041755E;
	Sat,  3 Feb 2024 04:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933555; cv=none; b=EtRqwqwS8L/AFNpTuea9GfC7VUzuyuCb8MxLsvm0ieukCq0/36wjFjM8OUYqhoZg/215m3N3HncEqDf8kX7UnRP9XorgIcdmxlPe3ICoGBpJcXMON4HlMJuOPAd1uG/ot4UbrUafShX0h2geIALUEoKwvRM82T66RDTt81fqadM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933555; c=relaxed/simple;
	bh=tVujJEXi6KX5dxHmo8JccmDWs+tJBjXmpt6DYyutUn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxZUGRCuiwfd/rgh+NkudeZ9weTtC3qkV8rTCp3r/Fn14GaVmsG/ch1LyWRk3d8f8NPOsu65WMZyInH+DSVnROpjPovb1FaecYgYpDAn4DqQZyoXlXdR/oYfoxMB5DCpRUMUlR0cmSifF3r+v6cOht1i/lKENfvt4dycpsMb9/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZ1ifuJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZ1ifuJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242F0C433C7;
	Sat,  3 Feb 2024 04:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933555;
	bh=tVujJEXi6KX5dxHmo8JccmDWs+tJBjXmpt6DYyutUn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZ1ifuJ0MJqW9Zr/gt9cyolmFA4oy40Lbs9h07TzdFwNmq4bQgneGltkiiDjh5J8r
	 83gQj7nInYcnsculNncfBI4uMyU5Ov3iFJ/8FMfMiwtwCpepFop70t7Lgkr+jYB976
	 Hpk35+JUY4TdstFlEirepSf+BSBRg6ZFSn15I0Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/322] bpf: Set uattr->batch.count as zero before batched update or deletion
Date: Fri,  2 Feb 2024 20:03:24 -0800
Message-ID: <20240203035402.614106252@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index f61c53237c19..4b7d186c7622 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1699,6 +1699,9 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1756,6 +1759,9 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
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



