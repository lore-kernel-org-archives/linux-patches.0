Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68003C199A;
	Sat, 30 May 2026 18:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165749; cv=none; b=I7RwTTfuF7DF6jCMYV+7FhdIh7gnK8oAusbHp/3S1ybo74nMMpVlofRPaAp0u0x6XRFVs3vmP9Ez0Pfr6yIJ5XsaOsIc8dst+ds5NnapdRzNxlIuDut+BXj7kazdHzD5WKqA6F5kqx5Qzg9CtcOD5mehDEW/DPo4YMlfW6Q6PuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165749; c=relaxed/simple;
	bh=YouFtrKGQwiZSfdRidCk6xiBuH2+9iG5gYELzcOBsPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYkYab95sexrgwSdwPeuV9OcmAryVmX/3pRWMV+dHYI8sPLG3t1tVBiumBbAiLj9lyn33JlBGQZ8XQM3EBQxAwCsYU5+/fpK2CVLb1Njsw5kr7Tb6w1sNgAb1ZJ07zNZvT/P/dooW5IppZm9cni9/IF6OMmbH8cg3Xm9L00tFQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TQKWDih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TQKWDih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665E1F00893;
	Sat, 30 May 2026 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165748;
	bh=3fbbWE4hSiIe5YJpvta9lnhjOAPeXjSj5LGkV+uO+iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TQKWDihTuquEFKkXCjG72Mb6kot32hI7Ey3jYRRPdRzmhClJLYKzWrTLg223tpyn
	 33Q6eLfXBdYzs1wgZ6jKOKLrMEz0as0oi4iYJWQceo7ZXa1niLA1BmG2dTeGK9SK5Z
	 zPEM2ygJkkHpa8czNI6xTmsgBb1uz5omzyQKEPuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ao Zhou <draw51280@163.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 169/589] net: rds: fix MR cleanup on copy error
Date: Sat, 30 May 2026 18:00:50 +0200
Message-ID: <20260530160229.236134891@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ao Zhou <draw51280@163.com>

commit 8141a2dc70080eda1aedc0389ed2db2b292af5bd upstream.

__rds_rdma_map() hands sg/pages ownership to the transport after
get_mr() succeeds. If copying the generated cookie back to user space
fails after that point, the error path must not free those resources
again before dropping the MR reference.

Remove the duplicate unpin/free from the put_user() failure branch so
that MR teardown is handled only through the existing final cleanup
path.

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ao Zhou <draw51280@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/79c8ef73ec8e5844d71038983940cc2943099baf.1776764247.git.draw51280@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/rdma.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -326,10 +326,6 @@ static int __rds_rdma_map(struct rds_soc
 
 	if (args->cookie_addr &&
 	    put_user(cookie, (u64 __user *)(unsigned long)args->cookie_addr)) {
-		if (!need_odp) {
-			unpin_user_pages(pages, nr_pages);
-			kfree(sg);
-		}
 		ret = -EFAULT;
 		goto out;
 	}


