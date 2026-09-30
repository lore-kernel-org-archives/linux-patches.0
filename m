Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6351C040;
	Wed, 30 Sep 2026 18:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792612; cv=none; b=hFSc4a0Q7bjcO0OxO9vbaDnF7LU+VmMRkv0hRjbkPJ65tCJfoikWNnCij2tVxNqtwJ9ndDvn/955sRkC0pK9snQ2jbCu1q1lods9LGYEsrEK9aP3zDiBaKBVNI6LX+2fBM/NwptcpSb3xLPyf1YZCLxx+I3D5nA5JGEL1Tki0IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792612; c=relaxed/simple;
	bh=9/NS1Q2TRcIQ44fVAJ3vGtCeEGSXIup4/xa48qjyDlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1AEHRNeuXXCq4fb7sfI4fw7VR7j+nc8cVn4TzbAtqBnZ6DSuoEf/Tm96UQKENrpI7X12fylxVwRp4tQKQSb7hKkuOH/3plopcAtUUX/xeltOwV3aL/S0vF6JZxWr2ZR0M4/SNGxKm7adHvpGpVj59ihq0tmXq/wJgfEfCs5JgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFIm66xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFIm66xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60761F00899;
	Wed, 30 Sep 2026 18:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792610;
	bh=spJPgcE4nd2h66C0PuFjDHAaVmCKAfDiga7y9PBbAyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFIm66xo3PtSOuSc4ifWcwlZu4gUc1tzLi1N3STjYYj+wFvJdJzj5ivMMKud8m5Lr
	 zUMjlqzuz10iGVoZkYDvAbMnluurQzE2nrroTPZ96Y+7hSpGd6VjPfMsKsnISCijod
	 1RsxebULB8TPdx8q1DoXrCN+hPOQuWCoZaq+Chn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 717/752] net/sched: reject IDR error pointers when deleting actions
Date: Wed, 30 Sep 2026 17:29:47 +0200
Message-ID: <20260930152413.740007679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ static int tcf_idr_delete_index(struct t
 
 	mutex_lock(&idrinfo->lock);
 	p = idr_find(&idrinfo->action_idr, index);
-	if (!p) {
+	if (IS_ERR_OR_NULL(p)) {
 		mutex_unlock(&idrinfo->lock);
 		return -ENOENT;
 	}


