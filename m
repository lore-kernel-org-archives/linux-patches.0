Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB631C07DB;
	Tue, 15 Oct 2024 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997536; cv=none; b=ILRYRMDyl3gpueXCINJoxfAhkz+WIt/cAbCQKzwCINv1yc6b0teuo2zvaMsdTyGXNfHwYZJbmRSxbQVJyGbXtp4CP4qoVQC4MB9WyZ+d5YYL0J29IErHp563UBqHqPqkoOUT3PrIPRw6DKmAAcOzulX1mOg3qWzsLQWFFjWmdGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997536; c=relaxed/simple;
	bh=uefbEy/awyczMTJYk8FgDlWJgsB4PVWI7CHP21/2ll8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fckMFAuKU90PWIuJfKi3zoo7cXr6+NvxG86Eot8qX9r8wuir5nXNjeoQNIx/JuMV7XY9nJVn8GI1op6L+r/ic+VpM+F7u95F2egl8C3RYvFpHOFL+EX9YMvmJuaYBdhA/2dMshZJpvZCjGzoEIq1I1G7ZCJVcTrYO4ZfONv/nbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/1DqqXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/1DqqXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A129CC4CEC6;
	Tue, 15 Oct 2024 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997536;
	bh=uefbEy/awyczMTJYk8FgDlWJgsB4PVWI7CHP21/2ll8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/1DqqXGqQ5UlcrxH38kaLB4AVntLsQAEc5/Gg5mI3XOYo6M4uUbxt47PE59slkWO
	 nKg0KbZgGQo3x/3lr48ZUaTnLc+/l3Q7VNNDFmi/8X7MnvaVwtQdTG2C+gL8W9aKCO
	 6cj5OEMTrQ+nTZeSNU3Iaxp67YUSIAuqUTbu/EGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 5.10 212/518] Revert "bpf: Fix DEVMAP_HASH overflow check on 32-bit arches"
Date: Tue, 15 Oct 2024 14:41:56 +0200
Message-ID: <20241015123925.174524418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Pu Lehui <pulehui@huawei.com>

This reverts commit 225da02acdc97af01b6bc6ce1a3e5362bf01d3fb which is
commit 281d464a34f540de166cee74b723e97ac2515ec3 upstream.

Commit 225da02acdc9 ("bpf: fix DEVMAP_HASH overflow check on 32-bit
architectures") relies on the v5.11+ base mechanism of memcg-based
memory accounting[0], which is not yet supported on the 5.10 stable
branch, so let's revert this commit in preparation for re-adapting it.

Link: https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com [0]
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -129,14 +129,13 @@ static int dev_map_init_map(struct bpf_d
 	bpf_map_init_from_attr(&dtab->map, attr);
 
 	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
-		/* hash table size must be power of 2; roundup_pow_of_two() can
-		 * overflow into UB on 32-bit arches, so check that first
-		 */
-		if (dtab->map.max_entries > 1UL << 31)
-			return -EINVAL;
-
 		dtab->n_buckets = roundup_pow_of_two(dtab->map.max_entries);
 
+		if (!dtab->n_buckets) /* Overflow check */
+			return -EINVAL;
+	}
+
+	if (attr->map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head = dev_map_create_hash(dtab->n_buckets,
 							   dtab->map.numa_node);
 		if (!dtab->dev_index_head)


