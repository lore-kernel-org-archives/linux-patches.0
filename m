Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734BB3F1ADC;
	Wed, 20 May 2026 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298981; cv=none; b=siTu3G3B5qyrrzLrcaRfXvbJa8x8pPrxfpyI/j4mXTsm0PZJPq70nob1WARga8duRfiHtq/RMKUaYZqgUvTea3fRxf1AHsfZ1Ahxtv+0Lj+Upjh9MBs7jHsSOJC5no2MH2qufqWYL/LiY8xGbiX6WmcW95ItHok6gvTEyhsh1b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298981; c=relaxed/simple;
	bh=Bhtm7ZVhlGmR5cnK7cPeaqMkHpB2KVUvWkI5Qze7MCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKsYJ5+C3WNFR0YlnR32hj2idMIC0nk1gM0PEirg6eIuqkV+80A3ejhTpaZk1CFlRe4W8qjHT9tnfi8/QOR4Jq9bHJuTN4playh4i7gUx/FL9z0Q816yygx2ryh6KkhuEeovO+QzxCng/U3hz1VSKfWvIxD3x7RLNT8BAsnLZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7ljWNO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7ljWNO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CB71F000E9;
	Wed, 20 May 2026 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298980;
	bh=++oIMLFvzU/pNuVERkb5ygYeaAxiR/XhRV0QdMlFIic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7ljWNO3C/gie61r5A/fBkWZQqDfng0X1id9lFqNne6AWorc+A/mfbeO+ffYHEnvX
	 75OUCWOYnpnoUrAzCyOwU03iW480Npu6gQrWAND2k/rTXakazkq5Qbvjbs3kroaQ/O
	 yWw7USa6GMdplE+Fs7g3mK08qriMx1bq/PSzJOCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 615/957] net/sched: act_mirred: fix wrong device for mac_header_xmit check in tcf_blockcast_redir
Date: Wed, 20 May 2026 18:18:18 +0200
Message-ID: <20260520162147.871428149@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 4510d140524ca7d6e772db962e013f26f09a63b1 ]

In tcf_blockcast_redir(), when iterating block ports to redirect
packets to multiple devices, the mac_header_xmit flag is queried
from the wrong device. The loop sends to dev_prev but queries
dev_is_mac_header_xmit(dev) — which is the NEXT device in the
iteration, not the one being sent to.

This causes tcf_mirred_to_dev() to make incorrect decisions about
whether to push or pull the MAC header. When the block contains
mixed device types (e.g., an ethernet veth and a tunnel device),
intermediate devices get the wrong mac_header_xmit flag, leading to
skb header corruption. In the worst case, skb_push_rcsum with an
incorrect mac_len can exhaust headroom and panic.

The last device in the loop is handled correctly (line 365-366 uses
dev_is_mac_header_xmit(dev_prev)), confirming this is a copy-paste
oversight for the intermediate devices.

Fix by using dev_prev instead of dev for the mac_header_xmit query,
consistent with the device actually being sent to.

Fixes: 42f39036cda8 ("net/sched: act_mirred: Allow mirred to block")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260413084927.71353-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 5f01f567c934d..18d9378a9c113 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -370,7 +370,7 @@ static int tcf_blockcast_redir(struct sk_buff *skb, struct tcf_mirred *m,
 			goto assign_prev;
 
 		tcf_mirred_to_dev(skb, m, dev_prev,
-				  dev_is_mac_header_xmit(dev),
+				  dev_is_mac_header_xmit(dev_prev),
 				  mirred_eaction, retval);
 assign_prev:
 		dev_prev = dev;
-- 
2.53.0



