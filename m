Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9214C33D1;
	Wed, 30 Sep 2026 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786379; cv=none; b=spuGwI6KWzsVVYARG5J5ykpi+rhhlCBCTk52R/HIHTrraBfRSqYP6Ym1iWYNUzDsNR5UbETroXEs70jZlYfbpf+mxmWXi6fL0YgydIGmALR3xTjSy33G2GI0cythxTKPCbLvMczRWTa8tygiaoDwXp2C7opVB8JX0TwExe2Dd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786379; c=relaxed/simple;
	bh=NRA7+itvUq1+5H6CaBF0fq5CBFfgCKq4lbM42WCPbB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7+behsIoCwVyeq3aP8MUdkP72j1F3JhindJ71DzPB+X3hY/jLU0wRYnTp95Md6NYxHrL6m0Osb69hN5tnIjzNAOhS1CK1KNYUYfphSCWqDv3dfqZX5d9cynEfnZNmNpGRCzkI5OxnVtkhm6ZxZZpmL57uTv/otQLY2E9MXP2f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9q+evtv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9q+evtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290451F000FF;
	Wed, 30 Sep 2026 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786378;
	bh=CC1ILpBtopKW8308sk3Km9zqcRhHAnqsaFPTlZ4HEsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9q+evtvb8dDyuuyN6iZbEtYV+JW0/EwXP0HP1K7Ks99viIB+AmX+Vc+jqe65IoPE
	 wxHgXF3B//D0fDzR2iQsHnfTNnDUC6k81UFDfKIFa99XsiT2uzFu1w+9xYw0SGIaoE
	 ccmR2NbMfSIgh1D4rMKnKgW/zkw7yMz7N8+6IquQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 842/982] net/sched: act_ct: dont WARN on benign flow_offload_alloc() failure
Date: Wed, 30 Sep 2026 17:26:18 +0200
Message-ID: <20260930152434.837362319@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 47abe7a5c4eb53269aca3506446f851572a059a3 ]

flow_offload_alloc() returns NULL when the conntrack entry is dying
(e.g. raced with a conntrack flush) or when the GFP_ATOMIC allocation
fails; both are expected under load and neither is a kernel bug. This
path runs from softirq on every committed packet, so with
panic_on_warn=1 an unprivileged user can panic the box just by racing
a conntrack flush against a `tc ... action ct commit` classifier.

Reproduced with a custom repro under QEMU: a small, fixed set of UDP
flows through `tc filter ... action ct commit` on lo, raced against
threads flooding bare ctnetlink CT_DELETE (flush) requests. Hits
WARNING: net/sched/act_ct.c:437 (tcf_ct_flow_table_add(), inlined
into tcf_ct_act() in this build) within ~15s on the unpatched kernel;
same setup is clean on the patched kernel. The fix itself is
behavior-preserving: both branches already did `goto err_alloc`
before and after, only the WARN is removed.

Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
Reported-by: syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6cc37aba98dac721c415
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915150816.36487-1-ngocthang2710.1999@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index fd5de2ed900a5..5e23f8d932ff2 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -428,11 +428,10 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
 	if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
 		return;
 
+	/* NULL if ct is dying (raced flush) or the atomic alloc failed. */
 	entry = flow_offload_alloc(ct);
-	if (!entry) {
-		WARN_ON_ONCE(1);
+	if (!entry)
 		goto err_alloc;
-	}
 
 	if (tcp) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
-- 
2.53.0



