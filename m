Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D4C3EA960;
	Wed, 30 Sep 2026 19:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796821; cv=none; b=YLHe/8d3o4z8n+HCJUu37L6jSLguAPkL6neLJkiDB9lW71uxQa+epjQ4ftwoDSoGlyFwS8B+5JDKDhk78CGtQcTwusm7E8nxPh1m2IvZTRcXsBbiSah4LwJ1NtopHWeyC/xHziwbpTwZBTjguuODJiUH56+myWUaBbL0cFiLeoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796821; c=relaxed/simple;
	bh=/ZS6mYc2YAc6DRhSGvZug3fg54aIcGME7O+evvBHMU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj57/MthoZcIaDkxNJ6pUT6QHAAeEbMnIROyTUK98GJuGfxPiKUxa0OXrX3JUqZtkHLoDr65x5kTH1vge6ZUOJcHSSNRSuIn5Yv441DyhmmwmXwfZJVhF/824azWcuNIFxo7S7B+8iDiw89ISGAyd6XJ30RUU5U2dUGgIvDLDk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rECbHis; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rECbHis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520A81F000FF;
	Wed, 30 Sep 2026 19:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796819;
	bh=py87iymF/vDc8QliwR07XI4CeCLxWtY/LFVI9FTV6+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rECbHiszDnpfmRkm5i846tzvtA8dBFek+FcX+laFakuJGJqMutNkKaZqK1LtC4Kf
	 MfqBzprOlIX01i5fu7bG4kZECdy8r85Pkb4LBasxgZkoLimg63pCSDLboZ7Lfyao23
	 Hw5KFvvWVHN0gSNfKbHXEoSoBx0vIvLfv50NCZb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1002/1193] net/sched: act_ct: dont WARN on benign flow_offload_alloc() failure
Date: Wed, 30 Sep 2026 17:28:06 +0200
Message-ID: <20260930152456.502784869@linuxfoundation.org>
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
index 7a0dff24c5d15..096adcf2209a7 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -432,11 +432,10 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
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



