Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB2242B75A;
	Thu, 16 Jul 2026 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212058; cv=none; b=X/3Zvy3DNO3g8mLPSb6ZW5njoH1SO8Ho9JpikUHrHYBYWE7PCIjORBDQZYh67HjP1samsZQ5VfRNumGmSX2SqAn5EZQPZIwrBB5ooU0wffypW0h81gZYjfgrBKT58gJUTFBc7mT2xi0003+XWiGvmzWEdbNILzlr+AKY2pvO2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212058; c=relaxed/simple;
	bh=j6CIlLnYXbLVVpntFjZzJr9ljukoYUF0LSimURj4Y7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAO1zo6/R0PIwSKFuIo/gdYZkE45t2zTwwicz4puXzysD1kVVGgoLntUmRC8Jp+zB3HO11pT/qzRzwEA8BYdSzdT6Zs2+xHlFmYH/gKbBDE59x/1zN5fwdIfOnanUPnTAK5C0sR4F6DqPXLwARDWUJaPLCoqZc+ddTMxp0L7W0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pqNNBZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pqNNBZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC8B1F00A3D;
	Thu, 16 Jul 2026 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212057;
	bh=Zd7XFta6AXPdfIq2xwC3n9LS8SN262TAKygApD9T3+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pqNNBZDlLgrJQk8puFATcZTHrPVphrsbDLQ+dq1VLFaTGnZ/hZCBnuFVRRUjxeoU
	 65KnfFZTUidWpSxi2rZlceJbeR/QOwuvCDVV92LrQPtvEMjYw18rQ2WF1GVaXM4Kqu
	 3siiuiO0ABLWeUUiZlBnZEHXt+WuFkf0xyBCOLkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratham Gupta <pratham36gupta@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.12 146/349] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Thu, 16 Jul 2026 15:31:20 +0200
Message-ID: <20260716133036.639956266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Pratham Gupta <pratham36gupta@gmail.com>

commit a7f57320bbbc67e347bf5fff4b4a9bab980d5956 upstream.

Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
introduced exp->net so RCU-only expectation paths no longer need to
dereference exp->master for netns lookups.

Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
updated the proc path accordingly, but ctnetlink_exp_dump_table() still
compares against nf_ct_net(exp->master).

Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
the rest of the March 2026 expectation netns/RCU cleanup.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3154,7 +3154,7 @@ restart:
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {


