Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBB2183CCD;
	Tue, 30 Jul 2024 16:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356449; cv=none; b=ldfjfx8xWIvStXfMgF+cW7YrZo2Y9JuRzlCfthVwe2wj8DCAoib6GoJ/RyaA/WyHG3ErVTKJXxHa7I7ktBwyiQjHEg6EUPknEtpAw2O34p7H2xvmU10z1Yl2+lAKa2EMHOQfylzDGay6ZC3l9AXFmO3ZS/TVfzWIY3gPbMwXLWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356449; c=relaxed/simple;
	bh=gE3YkxPR0Ta4mAHc2H3vBCsqdf8QmXRpUtgzSBg1eSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bxr1taL8EBdECvMvaCX8hYBOdhYaHOa3ZQb7UQj9BOdps8pPe023XUeT4cwVzNMtYID/TB79Ksak/K6l7fOKXwfPFWKlHo2qt3rZnDVxnZAHDy5mJOeA5Qzq88azlsjKFaC34U5plf3ZTMMXMYYBwQ1pMJZRJKEYa7VoCCMLKcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXV63AJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXV63AJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B915AC32782;
	Tue, 30 Jul 2024 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356449;
	bh=gE3YkxPR0Ta4mAHc2H3vBCsqdf8QmXRpUtgzSBg1eSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXV63AJEduV8+XXrb55rK+x6bW/GIN/2cmXNJZ/ZFpyZSnjxrqEAvgjmvqf/yQIjs
	 EnxK78YyLm1EJCcXs/FrlbddBDzDyKAo5Umi0lx2tbFrQi2jmciThytNTpvx+eroeT
	 gGuJA18iXoGz58Nb8u8HgTvsyoYv2+5PW3/or5YM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/568] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Tue, 30 Jul 2024 17:44:16 +0200
Message-ID: <20240730151645.700684186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3e0db5b5a1835..32723d53b970b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6478,6 +6478,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



