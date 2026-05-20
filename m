Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A97F3EDAC6;
	Wed, 20 May 2026 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301687; cv=none; b=k18NH6Vu4gOQGN5dy2hr6nVSF4sRj4SZ8cbeN1qRDX4due4D06A8lgG/bJbx6jlzJk4lnBxxn3g5fbA8QqxKxBvqImDKnT5R24DFDguR91vgCfPFQO4B8QMAmRtcbzDURoyhjOygw4S5zWJWHxyPnewz5NBs+8Hcw5UCjSXs9ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301687; c=relaxed/simple;
	bh=iVBBSDw1EvdLBVEcG8hY6IsC+HutZ0TB5Gd+2OcEjr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF1bocrITlkao2o2tk1OD0PhbvV51IH9zwH2PLgDddEb5IHzVCiXsTOiwJFF3p2/DaAWhlefFRHvWAVg7cU9E6cvzWQVzfR8pOtKodTIBNttT2j3A9JW1Qe7hlCTH/UNYn6QQWuGfp4iqKXFMx2Y++Ns6D1YYgsE5rHsKUnKEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjRfLZmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjRfLZmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE381F00896;
	Wed, 20 May 2026 18:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301686;
	bh=ccnDe62tZgy3tGDQY00kFPYEdGDSlWkc8Mt1Se1UuiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjRfLZmv+75vdac2O4A1M6lps7IgA2CQDrW/qT4S1MjyY2RaOYzcXq4WzwSHemt8A
	 Tc/dKkQNinhpoC7AKVpt/s2A/slQ70N1EIetDhUClbRZgefazAXzIE6ZLbbZx/SxfH
	 /zFJ7qYvhGYU92K/LYczxQk3oF7G2PwvkjbzycZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 612/666] workqueue: Fix wq->cpu_pwq leak in alloc_and_link_pwqs() WQ_UNBOUND path
Date: Wed, 20 May 2026 18:23:43 +0200
Message-ID: <20260520162124.536405218@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 0143033dc22cdff912cfc13419f5db92fea3b4cb upstream.

For WQ_UNBOUND workqueues, alloc_and_link_pwqs() allocates wq->cpu_pwq
via alloc_percpu() and then calls apply_workqueue_attrs_locked(). On
failure it returns the error directly, bypassing the enomem: label
which holds the only free_percpu(wq->cpu_pwq) in this function.

The caller's error path kfree()s wq without touching wq->cpu_pwq,
leaking one percpu pointer table (nr_cpu_ids * sizeof(void *) bytes) per
failed call.

If kmemleak is enabled, we can see:

  unreferenced object (percpu) 0xc0fffa5b121048 (size 8):
    comm "insmod", pid 776, jiffies 4294682844
    backtrace (crc 0):
      pcpu_alloc_noprof+0x665/0xac0
      __alloc_workqueue+0x33f/0xa20
      alloc_workqueue_noprof+0x60/0x100

Route the error through the existing enomem: cleanup and any error
before this one.

Cc: stable@kernel.org
Fixes: 636b927eba5b ("workqueue: Make unbound workqueues to use per-cpu pool_workqueues")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5568,7 +5568,9 @@ static int alloc_and_link_pwqs(struct wo
 		ret = apply_workqueue_attrs_locked(wq, unbound_std_wq_attrs[highpri]);
 	}
 
-	return ret;
+	if (ret)
+		goto enomem;
+	return 0;
 
 enomem:
 	if (wq->cpu_pwq) {


