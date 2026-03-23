Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5523B38A0;
	Mon, 23 Mar 2026 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278351; cv=none; b=Pp0uxZOFEyYIQSfOmcRZHjoRTtIwrfXlGwlqJmicGWB10LhTBBze0h6qh0nef1NmY5e8bGw76jdrldCN37rYszogBUX5C1e16sse7DBWHW7UkrdSlwWZUMUd2cg+w7yIdLmSURNTyl5y1NxuSM40vW57F4bDCady8r+EPR4HtAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278351; c=relaxed/simple;
	bh=3znkXsNDAQNsCMYbbi20K7b3FYUrRckS4phDZa9L1as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ev/nriKUAPziscAv65xc5ZwNXTmWMMn5yN5ce+RuokRvsk141K5umLcnxl6daZo6RumBkNQAMPSr5DBfOtfe+3tCLUc3BqjrqIoW9HrvxQsZ+MyJSF9dCNJlo+HgktmFFGOAlzqZhgZqqx6OQR4eSYhFV9jpt/e0WjBsDwySOlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5DNDGM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5DNDGM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535EAC2BC9E;
	Mon, 23 Mar 2026 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278351;
	bh=3znkXsNDAQNsCMYbbi20K7b3FYUrRckS4phDZa9L1as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5DNDGM2yPru7V4JK7ftKKEeCc4p+a+nIFg8pirdXAFjepzBe6HeBmv68NvszS/AP
	 GRx4qQiyBUiBlmnNM91NeOpVLQvhBc6Sxvy9dJvDCybWYyyhVsUVdhrCavmqbZeBZW
	 wxeRFVDOtXXenKLklqSo9gGbgpyf2T16lnPXkt2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <dg573847474@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 237/567] mctp: route: hold key->lock in mctp_flow_prepare_output()
Date: Mon, 23 Mar 2026 14:42:37 +0100
Message-ID: <20260323134539.698700682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 009ba5edbd525..59fbc54d8e66c 100644
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



