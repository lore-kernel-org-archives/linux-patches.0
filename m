Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBB41FC7C3;
	Tue, 15 Oct 2024 13:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998444; cv=none; b=q3pLySzpHGWv7Sq8770u7EmUtNrclJgYneLsnWKH/Bx9n3WEStoaYb5Qzg9BJCXIS7GUNwzlwOIH5YtfmHf2PJRoHbRXb9o+e+HKjZ+mBa74m3PCQZmJQyGP/OzsKyuJ22vvep5lgzZpwZyI6zHrslpmdS9zRWyZ0G3QKpSA2w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998444; c=relaxed/simple;
	bh=nbkbrpYouLVnRJPlCr+ITtNs85GPtZAEl8401lTovnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moIbBxwzkt4RXv6B7WpWJr3rvwqzpUr5W4YGR0CCm0Rsa+SQ53YWNns0Khf/wEQYJ80WIfT0Gr5Ut7wUrhmN1XynZ2cWuytnjgfkLFwtcgpled6zmw+mAuaVnluYAUSnLGS9LsL/TLWVSQAh/ReLzkXq5EasKpBTmta/eBffqTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlKr6Evp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlKr6Evp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6ABC4CEC6;
	Tue, 15 Oct 2024 13:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998443;
	bh=nbkbrpYouLVnRJPlCr+ITtNs85GPtZAEl8401lTovnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlKr6Evp6Ilp2GbzgUbMbCsBkGiJaL9Ffpuc+kDX2zhZv3Xc9dJbK9D/euKeiDQ9h
	 JLB9Ioc99pz2D/hQG98kA+4Hp6+uIuRbuVnNYEZ6RSB/PPRGlPdwabjyYe3N2Nf8HH
	 2yFaohSXxwz61qWneVKCg6tXScvxsSYZme+j2Fs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sherry Yang <sherry.yang@oracle.com>
Subject: [PATCH 5.10 471/518] RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt
Date: Tue, 15 Oct 2024 14:46:15 +0200
Message-ID: <20241015123935.184179165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Pearson <rpearsonhpe@gmail.com>

commit 2b23b6097303ed0ba5f4bc036a1c07b6027af5c6 upstream.

In rxe_comp_queue_pkt() an incoming response packet skb is enqueued to the
resp_pkts queue and then a decision is made whether to run the completer
task inline or schedule it. Finally the skb is dereferenced to bump a 'hw'
performance counter. This is wrong because if the completer task is
already running in a separate thread it may have already processed the skb
and freed it which can cause a seg fault.  This has been observed
infrequently in testing at high scale.

This patch fixes this by changing the order of enqueuing the packet until
after the counter is accessed.

Link: https://lore.kernel.org/r/20240329145513.35381-4-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Fixes: 0b1e5b99a48b ("IB/rxe: Add port protocol stats")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[Sherry: bp to fix CVE-2024-38544. Fix conflict due to missing commit:
dccb23f6c312 ("RDMA/rxe: Split rxe_run_task() into two subroutines")
which is not necessary to backport]
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -123,12 +123,12 @@ void rxe_comp_queue_pkt(struct rxe_qp *q
 {
 	int must_sched;
 
-	skb_queue_tail(&qp->resp_pkts, skb);
-
-	must_sched = skb_queue_len(&qp->resp_pkts) > 1;
+	must_sched = skb_queue_len(&qp->resp_pkts) > 0;
 	if (must_sched != 0)
 		rxe_counter_inc(SKB_TO_PKT(skb)->rxe, RXE_CNT_COMPLETER_SCHED);
 
+	skb_queue_tail(&qp->resp_pkts, skb);
+
 	rxe_run_task(&qp->comp.task, must_sched);
 }
 


