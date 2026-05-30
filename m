Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6E7342CA7;
	Sat, 30 May 2026 17:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163310; cv=none; b=pUIfzDJZENIlbTWxUn7e4obHehCvxwiuXoEpDMq4LKxOnVq7SsMO3exsp2rMpZAtizTnrydYQFtjRa3ggtJzfcmnrbIGpGZ5EXXM3v1peAb/R/zu718bgUO56RIboHzXNXLRu+qthC2u7CRobSRYXfXMjiQu9U877rY2OAwC9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163310; c=relaxed/simple;
	bh=GaEMNNZFJVkYl2q1g+qSZSWqauBqqwk37/xgrgi+r70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1WFMeeFxVVu/mnX5SXpsS3zVhmOmtK21VYBkcZKGNzwWrDxeRQ/Um4MkpwLPICs1WEL6m0JSEjvRr0IrAAJnnLuS953QdqfjkUaZFPyOuSdqeqSqoayiI3rlOl/ufgQLzJDXMoxTL4OXLgfTxDNmf+ZGtXI2b/nPOExbaP9v6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ha80hOTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ha80hOTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5501F00893;
	Sat, 30 May 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163309;
	bh=mzrIL+8tkfVbBn/qKXkXJpb6mHzvOiffq/G6mf3acac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ha80hOTFZ91A+yQYa4U108Qv8Tcv1kZDpcQ+mFLxTEh54K5vwXKSrEKnPUqe7i3in
	 JbQnNhYd+aEW180Lo3Y45o/RxFHGkAnFpXwZGFMiB5qNG07YaO/Uc8OWKYLzt9MHJg
	 yEuzDipHj2uffC/knEwW9pmNsdCiGXRpVUu9AZxQ=
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
Subject: [PATCH 5.15 219/776] net: rds: fix MR cleanup on copy error
Date: Sat, 30 May 2026 17:58:53 +0200
Message-ID: <20260530160246.180498437@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


