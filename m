Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78FD39B971;
	Fri, 15 May 2026 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860875; cv=none; b=V44joCwrujuD7tgETgu6LEqhBPzjYJ72o04nQkTMeZNhf+1vFvGLF8DuX1Jwa3d788xmSLPoR+XXh/Sc5bw6aQh97FCY36fXBOADh2AuqGJgFR6L+7aXYERHbNv6VgJaK6d8Y51vGBEy6tLNTe92FwP4WqAu4XYTHvqLzDP7/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860875; c=relaxed/simple;
	bh=T6Hg0vB1i8/I8v3HYwxjWcsaqpAcBG4DPMnwdw9rMAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGtoqr8mCowt/b16rLzD8E2V1FjGvXFX/nINBw0hE3lqOBERXoJt6mO0Fx4096gebH2swZRuJq/W+PH4DIrrUKTWgZ7zPtM7/isvgkjnRkdmdepCZ2DfeUpqviXSbhSZIY+s1NluNHM+e62o5VK2hEVi/2WLTHNVyu4BgXlGee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8cuM8Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8cuM8Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D53FC2BCB0;
	Fri, 15 May 2026 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860874;
	bh=T6Hg0vB1i8/I8v3HYwxjWcsaqpAcBG4DPMnwdw9rMAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8cuM8HdHx6toNaqqui5KIkXoofXHknqbnaWDC+fxwKx8kBeCz8ww6iyyVgOUo+wL
	 MKsgfkwPwSIbypdYL5BS46OyrxS948AGtxrX2apYlsVA63QowLWnnWM9Xj22Wy0Huo
	 +N03vOinf1c6H6mREkzdMEKYI6lame+jibm1SEG4=
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
Subject: [PATCH 6.6 070/474] net: rds: fix MR cleanup on copy error
Date: Fri, 15 May 2026 17:42:59 +0200
Message-ID: <20260515154716.556966265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


