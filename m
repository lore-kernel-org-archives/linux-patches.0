Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D02915A4B0;
	Tue,  9 Jul 2024 11:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524134; cv=none; b=mTzEfeoVOjMzbPCnoCnttoyCP2DyDdtRsZkPwq2BUcpP2hHjjYSSztGWMz1DoE9JS84t4iMzNMUwQ9ZER91ZZam/ppSWR6BinM6pERhsbffEEr33uw3dX9tKiSMfVdVvxpRv7VToerSsL5Qj2d2MfeViq2GTDDlf3Id6EBWtKMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524134; c=relaxed/simple;
	bh=HiLZ3CtVdIHwL7mWdj7CTqSeCGK1/nx3cdLQcc7em44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCG0l54vpSSzQ3+X+UuT2/XT6tnDrahNPJtPLB64/7wWucdqnpcz44aIwpTDIcM0XjimZWz9ZO0z3y59KNa+sskdl6EGt4/mSZJGJVyTpgss58sGfcAjhwUpwabGz8XtUTitUFV4M9UkgPsqIhgXwGnEa3D4/G/UcBhnbWH6m9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5RTmKwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5RTmKwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59C7C32786;
	Tue,  9 Jul 2024 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524134;
	bh=HiLZ3CtVdIHwL7mWdj7CTqSeCGK1/nx3cdLQcc7em44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5RTmKwZx88itzky/UKsl4rLszFPErSENccpde//uYuORTEjoq35ljyyfRsNYvFYC
	 TNeNtmHhxf4KGynwz6u1HWzhYr41Fws1Fl0+aVFl+tCO7voNg644rWH3p+1pdRGsVC
	 JyiPebG0TKxLUn8l3BS4j5NWxAQq8tw5PcX7x21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 081/197] vhost: Use virtqueue mutex for swapping worker
Date: Tue,  9 Jul 2024 13:08:55 +0200
Message-ID: <20240709110712.104170679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 34cf9ba5f00a222dddd9fc71de7c68fdaac7fb97 ]

__vhost_vq_attach_worker uses the vhost_dev mutex to serialize the
swapping of a virtqueue's worker. This was done for simplicity because
we are already holding that mutex.

In the next patches where the worker can be killed while in use, we need
finer grained locking because some drivers will hold the vhost_dev mutex
while flushing. However in the SIGKILL handler in the next patches, we
will need to be able to swap workers (set current one to NULL), kill
queued works and stop new flushes while flushes are in progress.

To prepare us, this has us use the virtqueue mutex for swapping workers
instead of the vhost_dev one.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20240316004707.45557-7-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: db5247d9bf5c ("vhost_task: Handle SIGKILL by flushing work and exiting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8995730ce0bfc..113b6a42719b7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -664,16 +664,22 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 {
 	struct vhost_worker *old_worker;
 
-	old_worker = rcu_dereference_check(vq->worker,
-					   lockdep_is_held(&vq->dev->mutex));
-
 	mutex_lock(&worker->mutex);
-	worker->attachment_cnt++;
-	mutex_unlock(&worker->mutex);
+	mutex_lock(&vq->mutex);
+
+	old_worker = rcu_dereference_check(vq->worker,
+					   lockdep_is_held(&vq->mutex));
 	rcu_assign_pointer(vq->worker, worker);
+	worker->attachment_cnt++;
 
-	if (!old_worker)
+	if (!old_worker) {
+		mutex_unlock(&vq->mutex);
+		mutex_unlock(&worker->mutex);
 		return;
+	}
+	mutex_unlock(&vq->mutex);
+	mutex_unlock(&worker->mutex);
+
 	/*
 	 * Take the worker mutex to make sure we see the work queued from
 	 * device wide flushes which doesn't use RCU for execution.
-- 
2.43.0



