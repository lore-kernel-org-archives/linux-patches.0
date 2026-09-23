Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDE3527599;
	Wed, 23 Sep 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172721; cv=none; b=nJGIrtsiWv+9uLJ3IvL03161gv50xs8nNgBZbBzUhtzyV0ZhzDmEJU5QC2FhXqAGGD897IRSsrK+Se4qv7B9H3jRMguOEgDB2KHUPjUToFVcTrUaU5w953kDKkJEINLhpBGUmwzqvHRe0KzjiO7pTAEH75X0iDZAqAJoi+lPMCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172721; c=relaxed/simple;
	bh=E5f6q/xmlPhkEhlk0Oq9fVdzFbDF5VlclxEpbFGUyDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXyM0hJDUJWTYecVfDT9QpoVuvPUb5wPy8nUXPS4B0rVjbM6VClPFvAHrqIcjN/Jjz5V/vqNHuMEWKecZ1L4ToYUi17A3oxwcBCYXJmRIf5B9/w42ve5O3MlADdQC4Xpx9BJHtY6GjehDO6JGbMPs86tOMvMj7mE7freK4/wB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUUb2Wor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUUb2Wor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358CF1F000FF;
	Wed, 23 Sep 2026 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172719;
	bh=F60/+3wyDJLVDF2DAx4HFl4e9EABJrkBtZD/HRH9z1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUUb2Wor/VcOa2TiUy7C2KnadrP+LE4MugZ1vkfSDUd8UVfT9uX/M+GryTljphnUw
	 eHdqmRimTh1ApJvjteKTN7fp1QTmg/y3EMKT/c/4vQH2SLpMM887ldNZjqz0KrMDc7
	 Jxib42fZtcqzudv423aWCzpZlBMj/Ub1COkVJgVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 040/438] RDMA/uverbs: Fix potential leak of resources->collection in flow_resources_alloc()
Date: Wed, 23 Sep 2026 16:01:01 +0200
Message-ID: <20260923140645.823458032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 08d4d9802d58bf032099091e6acf719f3298f28e ]

The two array allocations are done unconditionally and only checked
afterwards, so if the counters allocation fails while the collection
allocation succeeds, the error path frees counters and the containing
struct but never frees resources->collection, losing the only pointer
to it.

Fixes: de7498147d00 ("RDMA/uverbs: Refactor flow_resources_alloc() function")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260826073146.2203-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_flow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_flow.c b/drivers/infiniband/core/uverbs_flow.c
index 1528a294f7f85..de5a2769f0847 100644
--- a/drivers/infiniband/core/uverbs_flow.c
+++ b/drivers/infiniband/core/uverbs_flow.c
@@ -26,6 +26,7 @@ struct ib_uflow_resources *flow_resources_alloc(size_t num_specs)
 	return resources;
 
 err:
+	kfree(resources->collection);
 	kfree(resources->counters);
 	kfree(resources);
 
-- 
2.53.0



