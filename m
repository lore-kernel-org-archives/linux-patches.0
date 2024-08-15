Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6519FA9D;
	Thu, 15 Aug 2024 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730509; cv=none; b=OMd6t512jySywtki3JQz+9Nes1+MG/iTSriSD/MxVPS08z01/iUFVdij/ilS4WWZXvBo55sGtMcJWLh8cRKCVtO8He+0aIAP4sm0HI6lo8eoKPHg/sqoCztfL4XrNQUE0layJsPSarMIy316xMLIFmODuQS4IrdqbH2U/n0RK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730509; c=relaxed/simple;
	bh=WeQlKytbYjG/ce8RDe0fJs9FdTZLoaNldIEE/rx7S3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhWYEh+4QzqzHmGdABRDC09QGCzyhDEmpTB8Mn+BZfpuZG1hQIhcCtEvHjpyhbeTiyk0TXm3Vn1W/6/x+5NBk2bVbxQd7tYykxJjH4pGiCOixwrlYCHhNwOYwjy/t38rJrwtM3e6d5NUom6/VreIzf3wo6wlU68ofNZ5iBQU6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMgTtJBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMgTtJBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B649C4AF0C;
	Thu, 15 Aug 2024 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730508;
	bh=WeQlKytbYjG/ce8RDe0fJs9FdTZLoaNldIEE/rx7S3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMgTtJBr5h743OTVhXVJJnH0XDVsihr5rP36e7McrtfYnxQoS5Cxdi/CblmH1dZSz
	 UriwW70QYJgTJJiGyx7E05xkfqfbNVX00xP7LKGNJb5JiEgYkytXFCWNvL+7VALr2z
	 qodwuei+egPcD+k3meYFlydQi/fRe1ak6v/tKv3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/484] clocksource: Reduce the default clocksource_watchdog() retries to 2
Date: Thu, 15 Aug 2024 15:24:47 +0200
Message-ID: <20240815131958.028128688@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 1a5620671a1b6fd9cc08761677d050f1702f910c ]

With the previous patch, there is an extra watchdog read in each retry.
Now the total number of clocksource reads is increased to 4 per iteration.
In order to avoid increasing the clock skew check overhead, the default
maximum number of retries is reduced from 3 to 2 to maintain the same 12
clocksource reads in the worst case.

Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: f2655ac2c06a ("clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++--
 kernel/time/clocksource.c                       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d49e11962333c..2db3d5b6fc038 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -603,8 +603,8 @@
 	clocksource.max_cswd_read_retries= [KNL]
 			Number of clocksource_watchdog() retries due to
 			external delays before the clock will be marked
-			unstable.  Defaults to three retries, that is,
-			four attempts to read the clock under test.
+			unstable.  Defaults to two retries, that is,
+			three attempts to read the clock under test.
 
 	clocksource.verify_n_cpus= [KNL]
 			Limit the number of CPUs checked for clocksources
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 7d6d87a22ad55..38bb654d2a7e1 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -201,7 +201,7 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-ulong max_cswd_read_retries = 3;
+ulong max_cswd_read_retries = 2;
 module_param(max_cswd_read_retries, ulong, 0644);
 EXPORT_SYMBOL_GPL(max_cswd_read_retries);
 static int verify_n_cpus = 8;
-- 
2.43.0



