Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76BD19DFAE;
	Thu, 15 Aug 2024 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728522; cv=none; b=QoW5QqVK1XJg/0Dq+8+IpFWXndWXnhmpkFWjt8Zw8GmsgZfxnPW8a7k5dzYrE5st3u6uwL7mzuzD6X4KhXAOdghrU/8ryfE4Goks4wKmQ1bDv0gOosPxu7WkWlxs8S9cvIA22tbuOhdAbhuo45LD7/y8s35Ht8Vb9c9274GDij4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728522; c=relaxed/simple;
	bh=jGRPQNGljoxX0whuqLZBlLrCFJhlsz6Ibkks3xDT6kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAmZea6nsuMFVglpTaS1+DiWpEXHZ0SOL0js8Mq4seykV4jeHrrjZbAK0rBcCAICfO9frzlTaies5BjlesfWfE83/C7w6VmV0cOHqJZLdry4PYIpMQprHiV8cFPKU+tOgHUfLekIox27SZpyeONv2Tp+CYgyESZnV+9TVr6pZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ChTMS5qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ChTMS5qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188E9C32786;
	Thu, 15 Aug 2024 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728522;
	bh=jGRPQNGljoxX0whuqLZBlLrCFJhlsz6Ibkks3xDT6kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChTMS5qnD3jUNXIP3Yd+0ADrD0febzgih9G/hAfkes4HOK/cy7FB8yUZ/ZaF7xKPb
	 zB9vr1pXzlP0sp9urFpQb/hZYVkOuRL6yQA1xEehsMtLXIJnXVu4LRRGp0xLJfdzlE
	 5Tpg4XtQCfy+/QklSBMk0XSTpLfmns/QTiyitUGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/196] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Thu, 15 Aug 2024 15:22:24 +0200
Message-ID: <20240815131853.125624946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit dbc48c8f41c208082cfa95e973560134489e3309 ]

nr_pages is unsigned long but gets passed to rb_alloc_aux() as an int,
and is stored as an int.

Only power-of-2 values are accepted, so if nr_pages is a 64_bit value, it
will be passed to rb_alloc_aux() as zero.

That is not ideal because:
 1. the value is incorrect
 2. rb_alloc_aux() is at risk of misbehaving, although it manages to
 return -ENOMEM in that case, it is a result of passing zero to get_order()
 even though the get_order() result is documented to be undefined in that
 case.

Fix by simply validating the maximum supported value in the first place.
Use -ENOMEM error code for consistency with the current error code that
is returned in that case.

Fixes: 45bfb2e50471 ("perf: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-6-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c7651c30eaabf..4f1b0fc2e74d2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5730,6 +5730,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



