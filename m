Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211365;
	b=C7z3v8X6dCUYYOOEqdcZMTEE+pXorD75OpVWOOw80vBY2OM4qDkX1DTEp7eUa6qiOK9T
	 4f5w9TqrWEhrFJ/LC6CS0NHikc/88l+b9Ge5zllfKxMWlu6VFG0Sau/bab4+xnvuqFAjb
	 1TlH82sfOoez24Z9Lm3IoXqaUbe2uoJ1SvG7JnIzIFSBL0rNAW+E6KSfH8UhVvYiHp24t
	 CJoY4h0tNzNLL0hlaKokyBKFK7K+6Q0D6buQkz7Qo0BloRfuPX44XaMaay6c2oyeVb0km
	 tXD2bpQj2UfzPrh/a84JDRSgv5lZS/rZN1J/yCGKD7bbTxsxEm2UdxZeb0Ak5E6v3Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHtA/uptFaSGIHV4TMGE3WJ050biqV9p7CY1NHhB+T4=;
	b=KsVLPvKjR1BnfJAcVZe0PyP3SHd+HYvl5qtM9nE/eO/JXXRkyotpexVPFhgAXr/K+CN2
	 achJgh1c8yLFR+23Jw/l24gKvgER77MCU7WMZMEdEIHNopcwf06zG/GRjuLEsj9JCHFDj
	 0DWvMXrH3JOCg9ho6kvxtNj6rOY5Luh40DPOKk4R0LH1oxFXxQsyWFsx7FShB07anD8/l
	 g4TdrG5otPC2W4Mhf/NEO0UFDeL6lmRpExUq5gE9mbpFmEGn0267JX1S8Of7oOThzpuL9
	 OrpEWV4p6x/+vagA7Dsy/wnNX2PhY/Qtqry9orgZAjotnxJ6InbcRhGq5KZ5xbeKJlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpDvbpT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1371A606A334;
	Wed, 28 Oct 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fpDvbpT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616FA1F01825;
	Wed, 28 Oct 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211364;
	bh=zHtA/uptFaSGIHV4TMGE3WJ050biqV9p7CY1NHhB+T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpDvbpT5LrdAMDVBR4h0YlY5ZG5YBj5dAo+jghxn2eyQIIJ8aEFrbhNmG7q2osec8
	 R0c8JBjYLre9GRyZNOLAPQ79wn/w9Dxz0GUy0E1g2f9E1Aj+5A4WCG4atUfTaJLG1H
	 P5NaV7Ljs5CqtHU/KgkaC4v2s2QMJMz7h8kpNVGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.15 351/571] workqueue: Fix NULL current_pwq deref in chained work check
Date: Wed, 28 Oct 2026 17:58:18 +0100
Message-ID: <20261028170016.344939353@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1394,7 +1394,7 @@ static bool is_chained_work(struct workq
 	 * Return %true iff I'm a worker executing a work item on @wq.  If
 	 * I'm @worker, it's safe to dereference it without locking.
 	 */
-	return worker && worker->current_pwq->wq == wq;
+	return worker && worker->current_pwq && worker->current_pwq->wq == wq;
 }
 
 /*


