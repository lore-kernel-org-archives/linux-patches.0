Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC6E4119FA;
	Wed, 30 Sep 2026 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797044; cv=none; b=n2heVPEkBLK7bvK8i+rdC+/1nDYAkPipGpH3QHJa72OZyGGzMQ04wnQ7qCB07PpMBUhi5zRMZP504osSfLQBC+w+LY2e8XMBPGrDY7F9zYfaGDTJyRdebGqIFKfyHWjRU0EJUl8SpbwtJC1E0N1TCjRwbvD91L8rn/acnZLe+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797044; c=relaxed/simple;
	bh=Bwjhjv+r4OahIURieiusK0Vu4hCSa1KZcAHY1tW2ReM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+Ad08kb3qF4q2bga+5Ig68mxJytQZ3FdDdhyToShOwbW5F/RhQ+nJinpm2vC+nrxWeORqP2RoaqUwy4Tnhc8Ee/Q8IhMJnpWQq+MZOb2LAvY3mKCF8C/FYqi2IFkYGwnuPIlkTuqLv0N3iSPdUf1oGHRfcMgHw+GyH52WdM/qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ekqyx2Pm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ekqyx2Pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831381F000FF;
	Wed, 30 Sep 2026 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797043;
	bh=WdMmDrPzSWMX4XpmWuFmz5mpdGaoFLlNhMsrSKnaTQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ekqyx2Pm28WiDP5gzVx3zYRjy6weK7e0A+pMyFOhc45SFutsUInjnJVxyR97L7QzU
	 B8tVRizt/u1PkrG4FXGnDqg/pMxAD4RQY6fm/SaJMjczYKkFhY3kJK33z0nvNR0kTr
	 NeMO6kCaYSU3aMozIRvv3IU5AlpkIfQcjLS/Y6Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1126/1193] net/sched: reject IDR error pointers when deleting actions
Date: Wed, 30 Sep 2026 17:30:10 +0200
Message-ID: <20260930152459.254819361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit c82b797abe668d0b668601a93ba2c0b071a63574 upstream.

tcf_action_delete() drops the reference held by its lookup before calling
tcf_idr_delete_index() with the saved action index.  An unlocked
classifier can remove that action and reserve the same IDR slot with
ERR_PTR(-EBUSY) in between.

tcf_idr_delete_index() only checks the lookup result for NULL.  It
therefore treats the reservation as a tc_action and dereferences
tcfa_bindcnt.  A hardware execution breakpoint was used to schedule the
interleaving without changing the kernel source.  KASAN reported this
decoded trace:

  BUG: KASAN: null-ptr-deref in tca_action_gd+0x5b9/0x1010
  Read of size 4 at addr 0000000000000010 by task poc/150
  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002
  RIP: tca_action_gd+0x5c0/0x1010:
    arch_atomic_read at arch/x86/include/asm/atomic.h:23
    raw_atomic_read at include/linux/atomic/atomic-arch-fallback.h:457
    atomic_read at include/linux/atomic/atomic-instrumented.h:33
    tcf_idr_delete_index at net/sched/act_api.c:766
    tcf_action_delete at net/sched/act_api.c:1859
    tcf_del_notify at net/sched/act_api.c:2014
    tca_action_gd at net/sched/act_api.c:2064
  R13: 0000000000000010 R15: fffffffffffffff0
  Kernel panic - not syncing: Fatal exception

R15 contains ERR_PTR(-EBUSY), and adding the tcfa_bindcnt offset produces
the address in R13.  With the guard applied, the same reproducer returned
-ENOENT without a KASAN report or panic.  Treat error pointers as absent
and return -ENOENT.

Fixes: 0190c1d452a9 ("net: sched: atomically check-allocate action")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260914065123.4109709-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -711,7 +711,7 @@ static int tcf_idr_delete_index(struct t
 
 	mutex_lock(&idrinfo->lock);
 	p = idr_find(&idrinfo->action_idr, index);
-	if (!p) {
+	if (IS_ERR_OR_NULL(p)) {
 		mutex_unlock(&idrinfo->lock);
 		return -ENOENT;
 	}


