Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886429B78D;
	Wed, 20 May 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301145; cv=none; b=n1EmNXVD7HJK64psTQFv0LsvwSjAllUd1iC5y0YytKsyu5BuZtZEO6T6eMEjEATzhfnyKfNCJKgJxOmHDiBz/AxN0zFpAYrNskbc2pdUKXyaov6LYYUoJcbdEF7cuqpCZxWt5i0dy8vqIuGAeztCL9RVQ5eRTBilsigoRggwO8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301145; c=relaxed/simple;
	bh=d232ufAf8t3RrWUPgVBglohy3PbUBQt3bp65ld975oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eDoUi06DRDfq7xBPhbukQ7qIGCz+hr1OlWtZJtVkzQHr136O4W1SrO4JfrwlG0D+Pgv6gwJ0gRUlkaIV71J2b7g2zcASJs19Th2nUJrKz614/lF9N7pK3FZ4RzUYd+FCTWBuWF3W7Gw70lYm6UttTD3riWQK/8Pc6GBwniNYYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRpfGOhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRpfGOhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A49E1F000E9;
	Wed, 20 May 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301143;
	bh=yf6dKVe6Sucr9MymKkUeYDivLrcrMa8eMkV5nmDsfqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRpfGOhG/U7vsQVOfaaigL/W2NDmVHAkWkg4aS8Kb2VptnUY1Zh1MXqyoemt7cJX3
	 orHzzsdqcGFlmW0YHnJ5KxXuAnXVCfbwa5YfFtg14LRTYoIuQVDT0fzuujvGfJ5zmH
	 ezos/4yU2P5c/NiDS1lSC/WrYPunG0Op7BAgodZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/666] net/sched: act_mirred: fix wrong device for mac_header_xmit check in tcf_blockcast_redir
Date: Wed, 20 May 2026 18:20:55 +0200
Message-ID: <20260520162120.894792140@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b38143659249..b1b0049d7a0e9 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -348,7 +348,7 @@ static int tcf_blockcast_redir(struct sk_buff *skb, struct tcf_mirred *m,
 			goto assign_prev;
 
 		tcf_mirred_to_dev(skb, m, dev_prev,
-				  dev_is_mac_header_xmit(dev),
+				  dev_is_mac_header_xmit(dev_prev),
 				  mirred_eaction, retval);
 assign_prev:
 		dev_prev = dev;
-- 
2.53.0



