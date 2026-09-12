Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D57F2E7631;
	Sat, 12 Sep 2026 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221755; cv=none; b=av8YuxkAvV3pKPkaZocZbHvpysHYaEakrLYmLFXxvVNwruMembIX/96pUPPI0qg4kHqbfuQhA+l2BcP7s733CaZrOK+EsVcnlrOhHGvF6cgGkevMVYnx2+IhME/WBukEfWkOL87HpraEsh2+vQaIyDwYO8CCYm1+/sXDI2i81P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221755; c=relaxed/simple;
	bh=RYepw+ruX76q5hfcac0KltvBdjbXSEpShXvWaLgZiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T91+5DiRLlx7uKOmZt8qGoWwbC40HuxVWuPIqAN+L6j7NoAV2GcGv+v8dDEYkZh9IYWh1SaVPKQhjQaDZjpOLbA+s4Dbh3KDemcCrml4JWV8UIIKsbVCVMuUZpttAyaht/+nKrFlstZEwGCSIVJhE0w0eNDfazjLPefKnw4OPY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b86M2v9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b86M2v9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8128C1F000FF;
	Sat, 12 Sep 2026 14:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221753;
	bh=HmQ82dQcu3foDPCl9m7WnLXV5Lq0FpKJkPGW/X5f3dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b86M2v9J0+UEQwTTdwwtXVnqhPt0P+lGfCb6fd+YEch/yo326DFSZqJD7d3SgG6w1
	 xWoowU45rbgCSIhC/4XNCKCKX23Uyt6O2djzKPX9WcRJGOGBsQpSeDJMAYdSSxs6bY
	 5ihJozE7MPQxSMy3AE8wXIUn2Nsn18Y6rnq8mmUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0448/1424] media: cx23885: cancel NetUP CI work before teardown
Date: Sat, 12 Sep 2026 08:48:00 +0200
Message-ID: <20260912065617.317683991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 4e143d662ca94888b494b2427fc9e34494eb933a upstream.

netup_ci_exit() frees a netup_ci_state while its work item,
netup_read_ci_status(), may still be pending or running on the system
workqueue. The worker obtains the state with container_of() and
dereferences it, so it must not outlive the state.

netup_ci_init() queues the initial status read, and CI GPIO interrupts
subsequently queue the same work from netup_ci_slot_status(). During
remove, cx23885_finidev() calls free_irq() before the CI device is
unregistered. free_irq() prevents further IRQ handlers from running,
but does not drain work queued previously, so the worker can run after
netup_ci_exit() frees the state.

Call cancel_work_sync() before dvb_ca_en50221_release() and kfree().

This issue was found by an in-house static analysis tool.

Fixes: c184dcd28233 ("V4L/DVB (10798): Add CIMax(R) SP2 Common Interface code for NetUP Dual DVB-S2 CI card")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cimax2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -528,6 +528,7 @@ void netup_ci_exit(struct cx23885_tsport
 	if (NULL == state->ca.data)
 		return;
 
+	cancel_work_sync(&state->work);
 	dvb_ca_en50221_release(&state->ca);
 	kfree(state);
 }


