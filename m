Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFC17BB1F;
	Wed, 21 Feb 2024 14:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524122; cv=none; b=Xxk+uzmGZ6atH546e5SM/Le4oJICBTxF5HPxCNALCnJxQqwXL1bvjyIJ0XpMCUFVUTDPrQEXaJYTUTRcgVhnq3nH6PQuwEXtVP/VjS9SrHWsF8BfDr0i/9SBXylgKwlr/IjZJtsrPGdOfemfSMKapHlDUxcJYRqbaauv4zjqUVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524122; c=relaxed/simple;
	bh=ZfGtREafZdQg5PRM+UNjoyudOdROVroqXadq3SVhKLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9+EA5LtwrYTqxUbraLU76ZUjPGtjoEXuu6VlkSfbjHHVz+QbsS5HFc9hy7tq6nZfgdZjsHk1QidNxSJcorBudgFhGiyqmafdPq/dVtlOQEbysUWAq0h+Ay6ZsNNEW9qA4NBs2prygNAYyZ7O4gZIyQS0yURb2iBFi1/UDt0F18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIIj4llm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIIj4llm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF46C433F1;
	Wed, 21 Feb 2024 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524122;
	bh=ZfGtREafZdQg5PRM+UNjoyudOdROVroqXadq3SVhKLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIIj4llm6MbLq1Pmz8zyOzbLgbLLyY+8lgnsSk6G/c2CMoxEFnbTIbIOJeoZ4SuoI
	 Y4pCbhMs8kUOPoj9vMuzIKM2Mthy/DfcSo8h+imDe6c4D/aTSqzpyiaBlUXtoaU1tB
	 3N5i/g4EqX4SGw8g7G8AMwHz4L794O/2e2grRVYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/379] bpf: Set uattr->batch.count as zero before batched update or deletion
Date: Wed, 21 Feb 2024 14:05:30 +0100
Message-ID: <20240221125959.388446498@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aaad2dce2be6..16affa09db5c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1285,6 +1285,9 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
@@ -1343,6 +1346,9 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	if (put_user(0, &uattr->batch.count))
+		return -EFAULT;
+
 	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
-- 
2.43.0



