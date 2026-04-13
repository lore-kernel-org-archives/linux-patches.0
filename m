Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A9D31E857;
	Mon, 13 Apr 2026 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099416; cv=none; b=YCXSp2Yo1j7nzK3qWk49kxpjO+l/jnaHUwxR44IdFCWf1IvOtQRETqnftAX3zWV4y6bJMsZ92J4bRhV820YdM/6BJWwoGzFB2Kus6CeI7NELZgKHzQyMOSs4j1OEEtM7u+EFxAkViKQmKRzrl3Ss5LBUAyLA6pzq1K0sbFRwgaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099416; c=relaxed/simple;
	bh=xoyKQ71ZeYTjxseSjyntSth4b7WV4wLRA7V9MBm3gmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCQTvLOJmKtleUxErDX00EFK8SgcLvZE0HTy5onfSLfldX419Kj/9rFte/rlkYU31JIiXbD5cDwdexcBNv4pCyF7ocV7eV/8/NwLisJ4b4pObhVAKxVYTVt7K0wFHr4/pKE5AAXiVcwIaPFrNPGV9IrP+gFy/Ib5jqMv8Pe7a/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0PwfVMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0PwfVMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA6C2BCAF;
	Mon, 13 Apr 2026 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099416;
	bh=xoyKQ71ZeYTjxseSjyntSth4b7WV4wLRA7V9MBm3gmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0PwfVMmHCB7W0GncXEKGQo31tpnFCojda5F+MZ2wNNqzWbp8wi8o+GCTCdr/4r97
	 osNXR9tfl94mSPOUNjrXjnZBi3bpwgNPPX0MB9wUpZcviuVh+RxrJ5bgp46J2Xiddl
	 e1VNZ/fPfEp7Y5u3tOVP2HvLHX5ArCpVsH5VOrK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yochai Eisenrich <echelonh@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/491] net: sched: cls_api: fix tc_chain_fill_node to initialize tcm_info to zero to prevent an info-leak
Date: Mon, 13 Apr 2026 17:59:37 +0200
Message-ID: <20260413155831.470342906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yochai Eisenrich <echelonh@gmail.com>

[ Upstream commit e6e3eb5ee89ac4c163d46429391c889a1bb5e404 ]

When building netlink messages, tc_chain_fill_node() never initializes
the tcm_info field of struct tcmsg. Since the allocation is not zeroed,
kernel heap memory is leaked to userspace through this 4-byte field.

The fix simply zeroes tcm_info alongside the other fields that are
already initialized.

Fixes: 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
Signed-off-by: Yochai Eisenrich <echelonh@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260328211436.1010152-1-echelonh@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index beedd0d2b5097..27847fae053d3 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2669,6 +2669,7 @@ static int tc_chain_fill_node(const struct tcf_proto_ops *tmplt_ops,
 	tcm->tcm__pad1 = 0;
 	tcm->tcm__pad2 = 0;
 	tcm->tcm_handle = 0;
+	tcm->tcm_info = 0;
 	if (block->q) {
 		tcm->tcm_ifindex = qdisc_dev(block->q)->ifindex;
 		tcm->tcm_parent = block->q->handle;
-- 
2.53.0



