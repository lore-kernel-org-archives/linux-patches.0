Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE63DC857;
	Wed, 20 May 2026 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296360; cv=none; b=oD80/BVrgmTVEEt0GEGn+PvupJSqiAOpt+kcI2RJx2oTCzZns/RhUSpyydOZcUjHWXRUVa78XmLE+ZXiK32Ke497sXfpkqaSjv7qmzdoVrPqItzjW8zmAPiUnAttdD/fXQZuKc1iz11irGT677oWvxff0saLUdjeRWxOtIzxT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296360; c=relaxed/simple;
	bh=04xnfeiJfNVUgLrwIGqosqP6P/nw2Ol+eWuw+/AWozo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcY+xpdIdgJEY2MYChm7wWommBw3uFRTDCt+VgrqHXdUpLRvR3KT/3wd83+Mj/8utDwg4s30pftS2HdoYDZu7hMYum6iUwf3ufwT6pkqnAGOSmBKJR9HL28GnMl9URxoxarCUTfydv8RYzmw+StWQWylpdW8+mZc3zxX7b91+gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UbRyFlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UbRyFlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3E41F000E9;
	Wed, 20 May 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296358;
	bh=UEO8azDpClbOJp0pL9jVHpmJDCZ4oAWC8a2eLLlboVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UbRyFltlW4jl4SJZXrZFiV1Kwdkm/hQ/29cAQA2q9W14PXzlzlUcBWYTtKIuXkwL
	 O4mdaLk1Z87JbHL10Jk2IzmDYRkiazkBPAdjPgZ8J1Twga/iPG5uHQ9hfYBdVtwHKs
	 4naCxK7uMaIS9KMUAoURyZWG3fPm3hk+oTlEwrc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0768/1146] net/sched: act_mirred: fix wrong device for mac_header_xmit check in tcf_blockcast_redir
Date: Wed, 20 May 2026 18:16:58 +0200
Message-ID: <20260520162205.595354278@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 05e0b14b57731..2c5a7a321a943 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -354,7 +354,7 @@ static int tcf_blockcast_redir(struct sk_buff *skb, struct tcf_mirred *m,
 			goto assign_prev;
 
 		tcf_mirred_to_dev(skb, m, dev_prev,
-				  dev_is_mac_header_xmit(dev),
+				  dev_is_mac_header_xmit(dev_prev),
 				  mirred_eaction, retval);
 assign_prev:
 		dev_prev = dev;
-- 
2.53.0



