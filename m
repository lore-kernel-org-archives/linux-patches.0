Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4381F1714A8;
	Thu, 15 Aug 2024 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729447; cv=none; b=Zir0fyJ4NZEu321ic4we5JChH2kJvPcr+ysPP1G8P+DGirqJknPLpr96AyZ+MS6GRTgSHta6KqR+j5n3X0Vd5KvV+yZ0urMKASN1HldMGTywL7hMJYCK9IXg8CR9VLf2Y1OgBtGUwOA5gJv5zAU8lE2hMvtEfAr1526CuTIjN04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729447; c=relaxed/simple;
	bh=I0lh/rSph3GB5lRZBKakdeVtjtUpQeJUAVofFTUUKgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYvLxsy8hfjWxfcxx/zr+D0bI498yZWgRMSOpNiIufoGu+SOWpB2LK08BKlYAEqZKqDP+nCqZoPWj2dmeJQ9O7lspml4UGd3Kh8gRXDTJv1IY5rJqIa8tdTG2bktZUh9ODx22yXHuCMXFu/LXLGjAIAOExVHlx9dlon0dM5fhOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paXlSIHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paXlSIHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB082C4AF0A;
	Thu, 15 Aug 2024 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729447;
	bh=I0lh/rSph3GB5lRZBKakdeVtjtUpQeJUAVofFTUUKgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paXlSIHaFHlGnzSMfpwZoBESFb19DZuqxmy0dz6H3awvlUeCa+E1bk3IyfmZRYfPw
	 Nzz0fc8I61YFl/rOFGQSUExAvaZ/MYBTXxIaVuHTprV6Fzjf8i/nGKINdWhyMG4p35
	 m4ywwXbgf3BtvR+avfSyOrioZ6jr6SgNHZ2yg4oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/484] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Thu, 15 Aug 2024 15:18:47 +0200
Message-ID: <20240815131943.952102157@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index 80d9c8fcc30a6..b689b35473a38 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6401,6 +6401,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



