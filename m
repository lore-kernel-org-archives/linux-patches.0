Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6574A8BF8;
	Mon, 15 Apr 2024 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191628; cv=none; b=nqkVhVyVDN20CeXeR4sSOj0p39Rf7z2FkMMI6oZqaQaT9bre/C77GvsEGLHl2JxtbQf0sNWz97JLz9nwUoBHH+yaX2VFERY5IbiKbZzYUlNEKovVq3MVoLYRybVT/5StY58roXILskmYMzPF5KU9wvwy8SvMcMxHr0KwdCeYxGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191628; c=relaxed/simple;
	bh=iRMlFMXvmlzcmAbME2y2UwtpY2SyG1cX1p5KhqS++RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkAUCG9rOlgHe4ppchfZTuGOGV4o73nKJIC6AqLRLC0LZzjPs1xzpWtC9PwjbnBv/97BaJaCW877qBduy/etdiS0c5lyvqq9WjtX/t++oUq6i2VberUbFCsCmilCCFLttDz3PVasyjNE1fcQghQbK5DVifdXCqwt7Nx4e5pal9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8l6CgMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8l6CgMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E4FC113CC;
	Mon, 15 Apr 2024 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191628;
	bh=iRMlFMXvmlzcmAbME2y2UwtpY2SyG1cX1p5KhqS++RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8l6CgMTjLtUwYLMvv4o8sDpANtk23VwkEIwMaQcXNfG5yW9HvJQhlumrXYCvdUwr
	 TM6tl1zzYxwhXelTc9NqkfH3gl7WLSgXtXwuOlNwUo7VyAsk32ae+O81ycsY3sqCbg
	 rGJ5Nbafy4f0dkkTfGSfwQcIPt1gjJMlRisxgu8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petr@tesarici.cz>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/122] u64_stats: fix u64_stats_init() for lockdep when used repeatedly in one file
Date: Mon, 15 Apr 2024 16:19:57 +0200
Message-ID: <20240415141954.333608150@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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
index ffe48e69b3f3a..457879938fc19 100644
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



