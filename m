Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011D288C2D;
	Tue,  6 Jan 2026 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721119; cv=none; b=nlFcPp1cgW1TrAtewSVjqvPU56gCUenqq2mPRcHMneGRa46N98oARSiTOxN1SmsMu0fMlpGh80bGeFL4awNmzD2z0ciCwfW4uvuGkxwtyolEDjB+9jeMgHMOx8/V+kT+mIN9XavmvS3zKCqpYZJORFKX9v07Gptmy2aq2Nx88Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721119; c=relaxed/simple;
	bh=n+47NVzc0nHQBiStI77/MJm+1tznnsXv8eqiW9CGCLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6PZ+nd2YghFkJ/4gIg2pB828A+0QxhB9RVVdG5Nwp0QVZ8mB/aOXcj0Gs4knTWtzbVvVSHgVQf0wof3Rgz/FA3OzRmSNlBsiV1Tf1EDLXGhE+zTE0FGTsh8vDVItgRPU/qK2D1BYkDa8LSBSYCi3P1fTeoDh8NuNSQ2ZB3XOF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrEIb4fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrEIb4fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF26C116C6;
	Tue,  6 Jan 2026 17:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721119;
	bh=n+47NVzc0nHQBiStI77/MJm+1tznnsXv8eqiW9CGCLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrEIb4fpx7Xyf646ljwJ7SM+GOlzUUELMT6QWlcvmLuN4fRKMYYSKw/Z8nXIvO4Vs
	 K9jm+r6I/Z4CxVakfWOpbiYN/Ejjf4mJSI5II+gik7l+ecWJxAGhjkg90Go0eOC3G/
	 ROvPc87XQHfvKjv6xOfFnMWUmMm/3w7zrfl/Z1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Marco Elver <elver@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 441/567] mm/page_owner: fix memory leak in page_owner_stack_fops->release()
Date: Tue,  6 Jan 2026 18:03:43 +0100
Message-ID: <20260106170507.666343896@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

commit a76a5ae2c6c645005672c2caf2d49361c6f2500f upstream.

The page_owner_stack_fops->open() callback invokes seq_open_private(),
therefore its corresponding ->release() callback must call
seq_release_private().  Otherwise it will cause a memory leak of struct
stack_print_ctx.

Link: https://lkml.kernel.org/r/20251219074232.136482-1-ranxiaokai627@163.com
Fixes: 765973a09803 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marco Elver <elver@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -933,7 +933,7 @@ static const struct file_operations page
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)


