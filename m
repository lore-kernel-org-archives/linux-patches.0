Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC93F38837F;
	Tue, 16 Jun 2026 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623850; cv=none; b=VRZI1PscH3saUdjFKmHE/U4YQnGHq25YgxzRJHAL9Ygg+9u8nOIfFNtQCj867LBeMq9fw2siftzHiRPvb/gWLxlDHspiHaaibTn39XtsaTdhyp47iSeAH4H/w3uoMwJW76DTpvz5W9uZKMLp5Qk0rK9pgLHiPgx0OyvNgpoAk0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623850; c=relaxed/simple;
	bh=zA9R1AgPUhfeQKBgnKjOxqnpyoQCghL3XG9b0j+1K/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PytLMFUTL47FMMSH87fjQMXxx/fvM7mSfHIhH37SLhBFh5NIOlgp973oq/oOSHXxEOqtZNvOt2+wLlGQZhjr7Bi90fZxm06V0Z3whKFuxwjb6LbUMAmu2A8LzexIGkdW9fPgG6xq/6Uw/ab4LVcIwjVdA1aBNXlNvaJZH4QjgJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3OInZjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3OInZjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915111F000E9;
	Tue, 16 Jun 2026 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623849;
	bh=eeUCacx9DrE4X2fZJK1nZH9fck3KkZJttZLpPVIpwRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3OInZjIs1eJTmN9jx4QHKvxP7/5Q/bLBYwaWLuAVgrBhqsoNAePR66OhQnEmB8pd
	 X0QjOX6h7XQE33dmcu6rxBo3/dTVjAtvXbftZ1tS6rFBPE8FWkDNO1ez/0+XV1CYLZ
	 +UWTvVl30EOPhwOq/niJJJRU3VSUBG78EHPJ5qJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tip ten Brink <tip@tenbrinkmeijs.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 213/378] io_uring/wait: fix min_timeout behavior
Date: Tue, 16 Jun 2026 20:27:24 +0530
Message-ID: <20260616145121.563729313@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 29fe1bd01b99714f3136f922230a643c2742cda9 upstream.

The wakeup condition if a min timeout is present and has expired is that
at least _one_ CQE was posted. Thus set the cq_tail target to
->cq_min_tail + 1. Without this commit a spurious wakeup can result in a
premature wakeup because io_should_wake() will return true even if _no_
CQE was posted at all.

Cc: Tip ten Brink <tip@tenbrinkmeijs.com>
Fixes: e15cb2200b93 ("io_uring: fix min_wait wakeups for SQPOLL")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://patch.msgid.link/20260606201120.1441447-1-lk@c--e.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/wait.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -102,7 +102,7 @@ static enum hrtimer_restart io_cqring_mi
 	}
 
 	/* any generated CQE posted past this time should wake us up */
-	iowq->cq_tail = iowq->cq_min_tail;
+	iowq->cq_tail = iowq->cq_min_tail + 1;
 
 	hrtimer_update_function(&iowq->t, io_cqring_timer_wakeup);
 	hrtimer_set_expires(timer, iowq->timeout);


