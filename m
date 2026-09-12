Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C042F8EAE;
	Sat, 12 Sep 2026 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221711; cv=none; b=cGJCHUacpwyA91NeUN+uS4DfQC+0SsWsAOVwliHdllALDiJIA3Lf4oIT/r5zIOpSO/xj8y2BREIJY9i2jKQnJ1IdDRBCXxM5o1woeaA6TI+WlwWIBiZ8PsPM5qz99ABphTiXAIklfLD0CdPSisJXUmjesSiNF7iClf+96vteiPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221711; c=relaxed/simple;
	bh=hxNRSGML5VJNWms4Zn7eHVtXQIskcv/cr8RduktKGhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy+oEYugT1skExgRUr/6k0Oe0iiUeRPz4qZ0aPdF+FyCJE34EAuc7IuTgpXW31S76EugHP5nHW1HMY9kHeD06NzA13Cnak05/9NN32PbH9LrEoE00+YVFXlkDc1Fj6fePlzb7FXvt5EGH9/V7axT8NYAZ2hqDnU9XxIbeBjQfN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5WTE1Pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5WTE1Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478F21F000FF;
	Sat, 12 Sep 2026 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221709;
	bh=947FCFGk6/8drO7fWCjYdFT40/sBvExm0hSblDp+stw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5WTE1PcZGFInBQ39DgdKcbWA3zJZI3rSg3Q5U7GBBXXN0s0RKoZAfHmVDRoSdY/s
	 gc3v324z3H+MixRZY6efl+9b/B+5HDQJBVdOhne3cpCGwu/kEoVW7ujnTqTuH39Lp7
	 7+gg58ntWvYqoXstydcSviJY0lj86IC7FewFMskY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0395/1424] batman-adv: fix stale receive device on merged fragments
Date: Sat, 12 Sep 2026 08:47:07 +0200
Message-ID: <20260912065616.134538959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit ad46c907d7d9975a285c1e89a4adde652eaa93f5 upstream.

Fragment reassembly reuses the skb from the highest-numbered buffered
fragment as the merged packet. When that fragment was received on a hard
interface which is deleted before the chain completes, the merged skb can
re-enter the receive path with a stale skb->dev and skb_iif.

batadv_batman_skb_recv() passes such merged packets through the normal
receive handlers again. DAT and bridge loop avoidance both derive the ARP
header length from skb->dev, so they can dereference the freed net_device
before the packet reaches the local mesh interface.

Refresh the receive device metadata from the current receive device before
running the packet handlers. This keeps internally reinjected merged
fragments consistent with the normal receive path after hard interface
teardown.

Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -457,6 +457,10 @@ int batadv_batman_skb_recv(struct sk_buf
 	if (!skb)
 		goto err_put;
 
+	/* Merged fragments re-enter here with reused skb metadata. */
+	skb->dev = dev;
+	skb->skb_iif = dev->ifindex;
+
 	/* packet should hold at least type and version */
 	if (unlikely(!pskb_may_pull(skb, 2)))
 		goto err_free;


