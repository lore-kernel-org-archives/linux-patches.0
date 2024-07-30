Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EF0187FF2;
	Tue, 30 Jul 2024 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355618; cv=none; b=fw77q71Lb/oKD1U8N06YNr9r0NiW7yx38s+CUSYGePwCchCQsifg0e1SmhLognCwLEsrThtPpv9O+TbvG9OnDiez5mzU/+7BqkNWWK5aOy8K7lN7lOVP/Fk9/UsSzysmBwlTJy+ZyXBBQvTUQiTnRgTygmP8pD4WJAoaxlnklw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355618; c=relaxed/simple;
	bh=jRyw7OYceTvh4HMWnFwKjbLdQdrsJAgN268a16fMmN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4zmGLrcCa8w/oOx2ram3TdusVQedIJzguaVNQIABQZDsgZkDyYMumMHkNYe5PERIcy6rzugiG+tRE+bySM39xcxGk9PIwR/pDxD1VEvgp98AzQz4+Mp943KycH2YNXdFLJNeP90ttSY2geIhWjrjuKO3ue9kOdqGU0znJZiteI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nK8nmgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nK8nmgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E556BC32782;
	Tue, 30 Jul 2024 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355618;
	bh=jRyw7OYceTvh4HMWnFwKjbLdQdrsJAgN268a16fMmN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nK8nmgje6iinCPTBvMkAI8U0X+Tto6Wl1drJOeA66vZrKIiEt+DCpiRE8+lJv1Js
	 ww6xJlA9YCX8Egq/gO5lYn0MB4TeQGZz5R1AwhAWrQVUpwuzpp0TBBrrhpHBw3lvL9
	 A0kLZCrwH3d93F9cMmkAHFOpMVDknIvFucci+tAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/440] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Tue, 30 Jul 2024 17:45:44 +0200
Message-ID: <20240730151620.227877381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 413a69aecf5c7..b8333b8e6a782 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6307,6 +6307,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



