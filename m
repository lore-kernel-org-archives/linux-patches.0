Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F211BDED;
	Sat,  3 Feb 2024 04:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933796; cv=none; b=o83mVWKqeOhi01LjfVpKJlHbQnZHEQMg1dgyuGQQKSPB7EQkmA1mGH0c0pbFU1W/4MZGm5nI7a1XLK/gB3AYxmRZXjBLxEdaMAG35oDrJTFmRrY7MCQcI8DV5usfjkH/7Uz9lROE6mLUMUrOIlKBktv9cJmZXvt4teVjmFzv+Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933796; c=relaxed/simple;
	bh=vqgiZxYQir9bIZDi/NOtKxgeQh94Oim+zKb7xzZSDdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/6svEeSiJK+MJGgq42xYXhQN7/iShwIotvGNehNu0ZeX3Dgwzu6ETtn0lGbiJOITmO5hZol8YqdCD2GH6+DHCWRlXD0cHKThrPDWUGthmTIl9kVVAmJjkf75XaeTf2VJgUEtAJXrHp4EWSN9X0X/VxtomPI3x4mGVB0H+WynP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZDr9QX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZDr9QX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD279C433C7;
	Sat,  3 Feb 2024 04:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933795;
	bh=vqgiZxYQir9bIZDi/NOtKxgeQh94Oim+zKb7xzZSDdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZDr9QX/IFj9mYot4eS6proy4usTnacBGY4pQzN0chCEAAIBdghyaJi0FhmZAkvXD
	 vfmt42IpIdmV+Rzxu3jCs3wKSnLlPlasnyqPXNZZO9VQ0LgFRMoUngKw8NbG43ODaA
	 1xpX/fyMWhZVw/HOD4apcOzFKJFqsiprH5dztb/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 106/353] bpf: Set uattr->batch.count as zero before batched update or deletion
Date: Fri,  2 Feb 2024 20:03:44 -0800
Message-ID: <20240203035407.122785829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 58e34ff81197..349d735b4e1d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1702,6 +1702,9 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1759,6 +1762,9 @@ int generic_map_update_batch(struct bpf_map *map, struct file *map_file,
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



