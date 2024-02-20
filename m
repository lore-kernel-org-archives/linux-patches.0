Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7117B14A4D2;
	Tue, 20 Feb 2024 21:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464881; cv=none; b=aSMahcHuFf7ZslyuASQ2AQoMW/mYm54HfNEVMnB3zcbrsxHtA99Kg4ZbpWkwq98/5JieOdiPvOnjAZ65uiTzC0Xcu3HOvMNA7Hz7st6HY2VJMKKBBsUopgqDjJyQCytymge9mKjWObNWF55XSrFe9CaYHeZ2llFJHPeXa9Wy7t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464881; c=relaxed/simple;
	bh=O9Eqxok6z/xtkL8/Faveoi1Q5xhkiK/W6sNiuTxb4Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5Og1Nxg8ibLo3U/Ivq3v71imYjE8ta1brCB21Bilhd5RIJD0iIpJIL6U6wv9lba1ul+t3przerG5DfLq/xitvnKR+B02AJWwhXb7hBLCYLG/acM9aB8ybpwV8/T8Uorixxjfp1seucmMt8WNBXNnEUnJxcK6JizKVfj/F8SlsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xbezh/FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xbezh/FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D461FC433C7;
	Tue, 20 Feb 2024 21:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464881;
	bh=O9Eqxok6z/xtkL8/Faveoi1Q5xhkiK/W6sNiuTxb4Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xbezh/FI2FW04eA8HhcpXBaRnV5EJmmw7BQp6Y43b7T4rwuJ5etH5QDFIRi36LgpP
	 kVdyE5cWJqLJr4MztTbUrlyDw0WGRsWVmQu06/XAL/BroArpuIIxIA9cPxJlossmN4
	 TzzWfxtgJhkwYnoWauxcgd4UhaORqnn66ctyiIVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.7 167/309] Revert "workqueue: Override implicit ordered attribute in workqueue_apply_unbound_cpumask()"
Date: Tue, 20 Feb 2024 21:55:26 +0100
Message-ID: <20240220205638.376726013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit aac8a59537dfc704ff344f1aacfd143c089ee20f upstream.

This reverts commit ca10d851b9ad0338c19e8e3089e24d565ebfffd7.

The commit allowed workqueue_apply_unbound_cpumask() to clear __WQ_ORDERED
on now removed implicitly ordered workqueues. This was incorrect in that
system-wide config change shouldn't break ordering properties of all
workqueues. The reason why apply_workqueue_attrs() path was allowed to do so
was because it was targeting the specific workqueue - either the workqueue
had WQ_SYSFS set or the workqueue user specifically tried to change
max_active, both of which indicate that the workqueue doesn't need to be
ordered.

The implicitly ordered workqueue promotion was removed by the previous
commit 3bc1e711c26b ("workqueue: Don't implicitly make UNBOUND workqueues w/
@max_active==1 ordered"). However, it didn't update this path and broke
build. Let's revert the commit which was incorrect in the first place which
also fixes build.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 3bc1e711c26b ("workqueue: Don't implicitly make UNBOUND workqueues w/ @max_active==1 ordered")
Fixes: ca10d851b9ad ("workqueue: Override implicit ordered attribute in workqueue_apply_unbound_cpumask()")
Cc: stable@vger.kernel.org # v6.6+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5793,13 +5793,9 @@ static int workqueue_apply_unbound_cpuma
 	list_for_each_entry(wq, &workqueues, list) {
 		if (!(wq->flags & WQ_UNBOUND))
 			continue;
-
 		/* creating multiple pwqs breaks ordering guarantee */
-		if (!list_empty(&wq->pwqs)) {
-			if (wq->flags & __WQ_ORDERED_EXPLICIT)
-				continue;
-			wq->flags &= ~__WQ_ORDERED;
-		}
+		if (wq->flags & __WQ_ORDERED)
+			continue;
 
 		ctx = apply_wqattrs_prepare(wq, wq->unbound_attrs, unbound_cpumask);
 		if (IS_ERR(ctx)) {


