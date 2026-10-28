Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209005;
	b=RHq2oMR2qJWiyuFE+WrttXd5xruQq6sbBtxAwgbuXknYj4ttEyDeMdE9j9HM9km91NsR
	 7Y1pbZ5xqm2Nr8KE0Z/MoLkD7RMS/WXHVBV9siYLXW35IJcNQT9xx2BysnnGP7HBI99Uc
	 xY9lsVbShU6Z+gwv8xEwL7CSEDa/2g7ZFVW4+NvNcxaRkFXBHDBxY1g4tRpzT5TGvB/Pg
	 dFVqeovoATmvens8PXanD6dKnKXcOsZTRAcffflGR+DlLv9Zic5RyNeNc14wSFGdC8i1w
	 +WefbKnVA+Cpud2qZz9POkTVPxfboVJdMeuzqmx2KnFiJDy7LUfmLuvQrXLy0GajF7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GfhKEo3CkCLW+MHsXp6lK69vrsIJZmeGlJ7j7E85NEg=;
	b=2t1DXbyA0XVEU9xTatQhsQUFnlaoMMWyBx/DGNgr0fhdy8S7iRUX/dqUKRGRDoIl5sxv
	 cislt0apnjWgFLU1NKFheVFnQtFxQjT2OPGUiBbcaIWbvDRaNV38+Zk47ZqRBPBvkndvV
	 gdlyaiE0ziPqM+6XJWd9eEKiSgCI4eN5CbgGxh9rlDg+njF5FVgkcR86VRv8s2yW7teP+
	 baGlHCMIVCuB/XTnIezmFcYM0LtuW7dwScX9V+CwO5iY8le6zDEaFbigkijbjPOAw/kqp
	 7P6pT5KKOJBrgdjw0j3uSSABefZMz2em8XeYPRnIurlqlkp7H8hEOVX8FRygyDj9jGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2C8NGFxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E05606A31D;
	Wed, 28 Oct 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2C8NGFxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04911F01825;
	Wed, 28 Oct 2026 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209005;
	bh=GfhKEo3CkCLW+MHsXp6lK69vrsIJZmeGlJ7j7E85NEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2C8NGFxjAAqWZN8/yGTbmH2GEk6Fvz9ZgbQGqcVrq0ZSy4y2oJC0b2sXXb2fkRmWh
	 +2SE97cK5c4iOtvcNhiSvCLyRtb8ZVYbPeKWAsvnOg9crGYMXzRfzpjfAQ+BQfWSKW
	 gtE4qZ/tL3wzsX3JugAdRdVflK/bz5YfzU+2+2UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 318/516] workqueue: Fix NULL current_pwq deref in chained work check
Date: Wed, 28 Oct 2026 17:57:50 +0100
Message-ID: <20261028170011.023453303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>

commit 980db94e3eeefdd8a1c46f86412c33a7f7806f51 upstream.

current_wq_worker() only tells us that %current is a kworker. It does
not guarantee that the worker is currently executing a work item, as
worker->current_pwq is populated only while process_one_work() is running
the work function.

is_chained_work() can be reached while queueing on a draining or
destroying workqueue. If a kworker outside work-item execution reaches
that path, current_wq_worker() returns a worker but worker->current_pwq is
NULL, and the chained-work test can fault before it emits the intended
warning.

Guard the chained-work test with worker->current_pwq. A kworker without
current_pwq is not executing work on the target workqueue, so the helper
should return false and let the draining/destroying warning fire.

Fixes: 8d03ecfe4718 ("workqueue: reimplement is_chained_work() using current_wq_worker()")
Cc: stable@vger.kernel.org
Signed-off-by: Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1369,7 +1369,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


