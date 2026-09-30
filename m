Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E410451CF6D;
	Wed, 30 Sep 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789231; cv=none; b=iIDDlHXAxJJG9QsgyAkc4tuBGCTW0c62goh9ON1MOXiYZatCYOk6pWMbUQTOt1NcyGYGsgQ3T/mpxvbwmTchkq3YGToEgYXdm0lYp7RsljOCJrxio5Db8pgdCN0mR8EwcQ/XptUM+Tz1CBdm5yFm0F/3j25sVIOBy6YBWIPRAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789231; c=relaxed/simple;
	bh=I85JsAUJyus3aYEh/21Pn0JsIgEKeMPO/hWItlYq468=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+0KAWQDtHX7v8WVL302ObVOYwWPBEGpiONTFRvIv6+ef1CGjxG+evoMPYDh/sxLyVAoDO2s29FWw18J5Q2XKe8bxezJz3tWn6XF8F1TbVlg5h80zwLGmFeojgmv6HOBS12jF2QL/qZanLt3DfLqK4v6V0uDnqkGemvskPCAuuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBoAl299; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBoAl299"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C2F1F000FF;
	Wed, 30 Sep 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789229;
	bh=5LN4/TBK+BVQ8Z0mW+Kyt7OCdTHiZh/pIVLhkI4e3qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBoAl299xCMULPvUnLe06hkecD7zIJpIzx3wfnBzDhTbEUCXqAkl5Yfp7OYrkBWvb
	 gCaEwpxvgfO2+DUROv0+Eq/x+p/ejFoIboZ9l6OfkelhuD7GsUm5LNU8/sLCBF+bgg
	 k3bi29eQ8BTDARdRccWr5fuy5z+M6ou5xL4uyEOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6cc37aba98dac721c415@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/877] net/sched: act_ct: dont WARN on benign flow_offload_alloc() failure
Date: Wed, 30 Sep 2026 17:21:09 +0200
Message-ID: <20260930152422.402424405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 8aed25cad9eef..46564bfc13251 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -430,11 +430,10 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
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



