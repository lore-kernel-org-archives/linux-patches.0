Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B68F3B95F2;
	Mon, 23 Mar 2026 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282491; cv=none; b=KnWdk0pfVQrU0HF2Xx5y/LO53uG0gKNYlyQKHJbL38KXe8m4pS9nwMGt8hvypA98jU5uDMcmA0TALMn9A+Nee0DCPhUU2rcFoXQJyceYdxuYyPYs1VL4T7U9/H5DB+YAMaiM7o1WDHkVyHRSecseSqYeY2jgqdagMxZIri6wCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282491; c=relaxed/simple;
	bh=GUceQ3KCw7NdEtgFivbUVo5tuiJEItdA5+fOK5YyltE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XarFVIMR4AtdOyMFwse4xHr8YMLkApSCdEs//IOXXHgl0bdAtSMrXObWCl3W1PA4DB61TkQDhFT7MXziQ+3F7/mwzTmzvtlG87RgWppoxalcw3cidkDHsuI03/h7U5FmzAxpxu52xRXmfn36NlqFEIIihQpSh1g8NkCtVtTEcKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hf7zRhWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hf7zRhWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9057DC4CEF7;
	Mon, 23 Mar 2026 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282490;
	bh=GUceQ3KCw7NdEtgFivbUVo5tuiJEItdA5+fOK5YyltE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hf7zRhWGg009d3ttGgkgG0wG3I9Ccr2M3w7sBLFjLLY0Og3fEEIwJwWC5ehK7g2zp
	 FER64HgP9ImJZaTmJZq20pg2st7aU8N3l+fZfwYXRRMiiRD3q7tDwpFJR5nL+CKvQa
	 rA3eS5bGFRDIB+FP7KMENMnoRqJH9yIjSo5C968c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/481] mctp: route: hold key->lock in mctp_flow_prepare_output()
Date: Mon, 23 Mar 2026 14:42:37 +0100
Message-ID: <20260323134529.483007095@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Chengfeng Ye <dg573847474@gmail.com>

[ Upstream commit 7d86aa41c073c4e7eb75fd2e674f1fd8f289728a ]

mctp_flow_prepare_output() checks key->dev and may call
mctp_dev_set_key(), but it does not hold key->lock while doing so.

mctp_dev_set_key() and mctp_dev_release_key() are annotated with
__must_hold(&key->lock), so key->dev access is intended to be
serialized by key->lock. The mctp_sendmsg() transmit path reaches
mctp_flow_prepare_output() via mctp_local_output() -> mctp_dst_output()
without holding key->lock, so the check-and-set sequence is racy.

Example interleaving:

  CPU0                                  CPU1
  ----                                  ----
  mctp_flow_prepare_output(key, devA)
    if (!key->dev)  // sees NULL
                                        mctp_flow_prepare_output(
                                            key, devB)
                                          if (!key->dev)  // still NULL
                                          mctp_dev_set_key(devB, key)
                                            mctp_dev_hold(devB)
                                            key->dev = devB
    mctp_dev_set_key(devA, key)
      mctp_dev_hold(devA)
      key->dev = devA   // overwrites devB

Now both devA and devB references were acquired, but only the final
key->dev value is tracked for release. One reference can be lost,
causing a resource leak as mctp_dev_release_key() would only decrease
the reference on one dev.

Fix by taking key->lock around the key->dev check and
mctp_dev_set_key() call.

Fixes: 67737c457281 ("mctp: Pass flow data & flow release events to drivers")
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Link: https://patch.msgid.link/20260306031402.857224-1-dg573847474@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 62952ad5cb636..fdeaf80691e55 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -267,6 +267,7 @@ static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev)
 {
 	struct mctp_sk_key *key;
 	struct mctp_flow *flow;
+	unsigned long flags;
 
 	flow = skb_ext_find(skb, SKB_EXT_MCTP);
 	if (!flow)
@@ -274,12 +275,14 @@ static void mctp_flow_prepare_output(struct sk_buff *skb, struct mctp_dev *dev)
 
 	key = flow->key;
 
-	if (key->dev) {
+	spin_lock_irqsave(&key->lock, flags);
+
+	if (!key->dev)
+		mctp_dev_set_key(dev, key);
+	else
 		WARN_ON(key->dev != dev);
-		return;
-	}
 
-	mctp_dev_set_key(dev, key);
+	spin_unlock_irqrestore(&key->lock, flags);
 }
 #else
 static void mctp_skb_set_flow(struct sk_buff *skb, struct mctp_sk_key *key) {}
-- 
2.51.0



