Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7370C3BBE1;
	Mon, 15 Apr 2024 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192062; cv=none; b=ANOPw8y0bB3sDPyLblKMd88bDiQ6CmMKXkw1tMvKD+yhYx66MQ70z3l5O5VXjwRphTQLoR696kRIrqsiZINjBiy+/n/69/miihkDz8WUHRknF1yMThLjvvLVhiqTeL0kT1FMaPoPT+zET/R/tfBJMpzG1FBuYaQ3B6+QsbxTxCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192062; c=relaxed/simple;
	bh=tQn8snFk165neIsk+g7fMS1P6KjPIIEgsMlyHcIaReQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3U0Xkwz/+TWCVw4On9Q53cYADxz9amW5qrnUFBCGXuGhQ2n9n0MQu9yIGjQkdR7aS8kMee3areURZIwgWChd3kMk64n7dMwiUMGhhvzmnfHiOBb4a1D4SPTIfTrwNqKvKtFziFKLODIdFArL+NzbDwD29r6+3LKIYiPMhXwKtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nX+ve/O8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nX+ve/O8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED000C113CC;
	Mon, 15 Apr 2024 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192062;
	bh=tQn8snFk165neIsk+g7fMS1P6KjPIIEgsMlyHcIaReQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nX+ve/O8ZtjqskRwWKCudOf7iYIac3t47qRD6/LRWUZbNBzIUNZTmv97msLky/r2t
	 0e3F9cK+I4vgZrmJysUQP587tI9hArSWdDqaKqUI/Yegv+fLOjL1A0IccxxhhDVlKh
	 sJJGwmujGk8r0ZBCbIrIcw0PsoSnwY/MJjM0O+Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/69] u64_stats: fix u64_stats_init() for lockdep when used repeatedly in one file
Date: Mon, 15 Apr 2024 16:20:46 +0200
Message-ID: <20240415141946.630784598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

From: Petr Tesarik <petr@tesarici.cz>

[ Upstream commit 38a15d0a50e0a43778561a5861403851f0b0194c ]

Fix bogus lockdep warnings if multiple u64_stats_sync variables are
initialized in the same file.

With CONFIG_LOCKDEP, seqcount_init() is a macro which declares:

	static struct lock_class_key __key;

Since u64_stats_init() is a function (albeit an inline one), all calls
within the same file end up using the same instance, effectively treating
them all as a single lock-class.

Fixes: 9464ca650008 ("net: make u64_stats_init() a function")
Closes: https://lore.kernel.org/netdev/ea1567d9-ce66-45e6-8168-ac40a47d1821@roeck-us.net/
Signed-off-by: Petr Tesarik <petr@tesarici.cz>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240404075740.30682-1-petr@tesarici.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/u64_stats_sync.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 46040d66334a8..79c3bbaa7e13e 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -135,10 +135,11 @@ static inline void u64_stats_inc(u64_stats_t *p)
 	p->v++;
 }
 
-static inline void u64_stats_init(struct u64_stats_sync *syncp)
-{
-	seqcount_init(&syncp->seq);
-}
+#define u64_stats_init(syncp)				\
+	do {						\
+		struct u64_stats_sync *__s = (syncp);	\
+		seqcount_init(&__s->seq);		\
+	} while (0)
 
 static inline void __u64_stats_update_begin(struct u64_stats_sync *syncp)
 {
-- 
2.43.0



