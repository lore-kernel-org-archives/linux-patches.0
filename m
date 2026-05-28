Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA98313550;
	Thu, 28 May 2026 20:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000472; cv=none; b=XypQk2ompvU0gIz8SLZqBmxbFxz/+UV3MKn6Pi/zoP+sT0U0dKPAiHOUaPR8ZBkuqAaNPsS+3Lkf7xEGC2q9K44LLySFGf6+hHNM+2H29RvNlceb2o1sWd0PC/+6PZJvpiqkWP9ntgqVmT6O6yGE6zPhnzX1SVt4FCGt3a/n6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000472; c=relaxed/simple;
	bh=hJr75ULpAys4DFgFEsEyiRy4C1YXKYzILDpLzc5YZSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCRXx7XsVXH+ks+D/oqnAQaS/kplbISHFzU63gRYsZLVBphoOcnXo/3f+3z/YzyV9EDS4BDzfOkfjzKczaHyAaJX7ahFoxaJrNdifxXQC+JDeIlF/OqBaeFhMtKkW7kWhY+3ahutqiPmbSRKpW26BeK4Hx3WHnYelMzxccK/8os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj8ne0RW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj8ne0RW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A283F1F000E9;
	Thu, 28 May 2026 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000471;
	bh=2SCSaFDQEDPXI7mbzv9bM8aFmpNuab15SH2woeozAEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj8ne0RWW/l5bTUIwjmDPz6kMYwjuoyPXAtUaOmH6PeIIViCdPg1iaCKbv21wWAAb
	 /8A5KQQjbi4rWkMyFQUW3MeDjiniHHF590JBq2ZVw8JXB1z2mq/pnCsCp/bnmzcug8
	 lgAvyyZia4i8cdhhc5OMBQjwOHmGlFs+stYY1hpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muchun Song <songmuchun@bytedance.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Huang, Ying" <huang.ying.caritas@gmail.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 057/272] drivers/base/memory: fix memory block reference leak in poison accounting
Date: Thu, 28 May 2026 21:47:11 +0200
Message-ID: <20260528194630.978652726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muchun Song <songmuchun@bytedance.com>

commit 03a2cc1756a0570f887d624cd6c535ea0cbd4951 upstream.

memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory block
via find_memory_block_by_id(), which acquires a reference to the memory
block device.

Both helpers use the returned memory block without dropping that
reference, leaking the device reference on each successful lookup.  Drop
the reference after updating nr_hwpoison.

Link: https://lore.kernel.org/20260428085219.1316047-3-songmuchun@bytedance.com
Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1232,8 +1232,10 @@ void memblk_nr_poison_inc(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_inc(&mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 void memblk_nr_poison_sub(unsigned long pfn, long i)
@@ -1241,8 +1243,10 @@ void memblk_nr_poison_sub(unsigned long
 	const unsigned long block_id = pfn_to_block_id(pfn);
 	struct memory_block *mem = find_memory_block_by_id(block_id);
 
-	if (mem)
+	if (mem) {
 		atomic_long_sub(i, &mem->nr_hwpoison);
+		put_device(&mem->dev);
+	}
 }
 
 static unsigned long memblk_nr_poison(struct memory_block *mem)


