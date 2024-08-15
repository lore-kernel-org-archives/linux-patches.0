Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6291A705B;
	Thu, 15 Aug 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732035; cv=none; b=lJXotQxzRKO+5v5AjsaPgKyVNvZTQwR+U8K3NU8TdxCEOE6ZFdlpn29Mkxkb6Q4hBmRQy9dFoE2XRiwz5h8bs+wH5t1Qh/0EVUCV6sLog65ht4JXNg2Trqdoou/gjFJbu0VcdkMOnV7YCsBee62xbk16qfWoAJdHy3xA0q7seZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732035; c=relaxed/simple;
	bh=DQf0JD3MXXY4U5simKbGOzeXmwQdgAscKX/0+Imh20A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0C2QdnoDjZsbucGvK1oB3M/u4ttE9BEiHlapPhXeUMK8ugHNgCOeVKTlDaOrj2hcALNXBerjiIBNvtDOR8jtFN0F3oZJQ7Z+RopqMAX+KfdydAf+BTacnsMX5ejNz1jOY50HCmEVh4Ki+Zz8zJYinKAZIwKOYpom1m2dulw22w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtX3JYkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtX3JYkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1FDC32786;
	Thu, 15 Aug 2024 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732034;
	bh=DQf0JD3MXXY4U5simKbGOzeXmwQdgAscKX/0+Imh20A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtX3JYkfisvpRSAJ/Suvogd4aZb3hhyb/42wc89G+9/rm9Z4kEYHdi2E075QvEaX4
	 AcpTvDMObUROvhnsb4YZruDVPLTxipD5ImGl3mMJPkdfB9eJdIyti7Uue7xIHgJYgK
	 YDUarENOpBkFZlTVVb+oB24AYPq72JVBTHPFWGrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/352] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Thu, 15 Aug 2024 15:22:01 +0200
Message-ID: <20240815131921.365829505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
index 3a191bec69aca..b60325cc8604d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6239,6 +6239,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



