Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3767168A9;
	Sat,  3 Feb 2024 04:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933387; cv=none; b=mDF8uqTmHkKjbBX8m/uD5Ds54NbG/IcR4yjB7g7r72tCrhpEOegS5/J7hrthklD2dU0kcUHfGTfyqId2ChYy18PYE9WVgqb3GSjHbczW7/hIsmyqqyOB4VziP13/v+NhjaNkgTb9+wQUn1BASELvezSclQ/QEa72GvCdtWmqDBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933387; c=relaxed/simple;
	bh=qjLCcTo+LV50YtOH5Qh17Mr+p8yN1GYGUft6tFCrGIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHePfUXLhuRfXIubtTmLJTtAWvqg0wC/n00QSKDjt3inlM72XJyyLstSoKcllc8QKOEOut1AevQJbKMhOQ/Iy1pz1IG9t5jciCVOb1pcZ+IiFnn1FqoSVfO5QtXEdYFOe2DchvMQE0WfaPH+rKoEeZy+1NtHal5osUmPtAxKO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApPG+w/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApPG+w/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C09BC43390;
	Sat,  3 Feb 2024 04:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933387;
	bh=qjLCcTo+LV50YtOH5Qh17Mr+p8yN1GYGUft6tFCrGIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApPG+w/UZpqsUE4sX+x7N70hL0qb98V7pqVMcCR/krNaJatMkZNCsYoYG2Jnx1FV5
	 DUPw/q1exo5rz4PJfy9D9ln2pRxECjiSnNINyapUp/oruQkcPU8IrsaCqramoTnhEf
	 t0mBZmWyYy145fN8jNkK1P8xLfZCbijTmRlXoWko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/219] bpf: Set uattr->batch.count as zero before batched update or deletion
Date: Fri,  2 Feb 2024 20:03:59 -0800
Message-ID: <20240203035326.039915430@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d0c38a8dcf2..1e46a84694b8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1598,6 +1598,9 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1657,6 +1660,9 @@ int generic_map_update_batch(struct bpf_map *map,
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



