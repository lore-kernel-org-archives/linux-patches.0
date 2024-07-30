Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957221A619E;
	Tue, 30 Jul 2024 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357278; cv=none; b=B9bYdmQC2hD5nVk1JwkfcazNASmqD/IMHmA+nVB4D8GNGIpZSK05RWqWilDr/UY4iid8g8qgDgI8Nsh2ZdckvCz1yzQ+ZDwIL4KKY8BURmUJ+tCGKOjI7Np+6kmwvvbSZMstTky6PS7MjYDa8upqElqvL2V9bpuHH2s9azl5Dug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357278; c=relaxed/simple;
	bh=l8mAyWG9By/MPXtKtWLfeDnAnLzJ+VhTpSMOJvuDao4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLccxk8KvRrfaZs363sScaU/FKxoKjbuY1fPaNPnNgLCWwBL9oLk/RVybh9hRIeL9Auj0btzixA0LAQyip/TshsQT5CRdWQ92oLIi07meDyMTuO4VzCxCzN+Y5xcI2twpE2MIVqHpoUIIMDiGnveknKMoDAZVw1ALkfEdE3P0yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgUfI9Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgUfI9Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059AFC32782;
	Tue, 30 Jul 2024 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357278;
	bh=l8mAyWG9By/MPXtKtWLfeDnAnLzJ+VhTpSMOJvuDao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgUfI9BvEREQ+8VwqAmoB1T1SOMGcRcyfeRhAxQ2j4DWSHslcq5Fvhy+mrogfCVuV
	 7WXhs1kZotUW0r+ileVQqyBL8nNw+dzISCHGhF3ErkjbYEOb/v+6D/UrlijagID7Y9
	 ojOoVs+tkS2oWZedY11g755rlbWG4jJmZPWETS3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 224/809] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Tue, 30 Jul 2024 17:41:40 +0200
Message-ID: <20240730151733.456651209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8f908f0779354..053e546d5bf07 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6509,6 +6509,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



