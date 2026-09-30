Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAEF51614A;
	Wed, 30 Sep 2026 15:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782578; cv=none; b=Ntal6riCKcTCOPPh4jLxbcMJ+GBLs8RHRWCKMliTan95yfqmx4UyBgLmKHJtcZvOiGNl0rZ5bAaRTqWtwtYjn1Q4GwZ1ftW4A70v/3sLJ1uDBFmxsnqxz7f4GHb61r3R3Je3H+lkLW34kFLJyIQDub4FqLJCUzj19dT5BEbSuVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782578; c=relaxed/simple;
	bh=37LxoP4ehJeJNiQNt2PnIIwk9t7ZPbG4iyp8e2KXKdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+HD057z0jPeUVsc2kaI/3Ubj+Q6Axk04zMOzpRuUwePnyVELVm3cZ5Oiot1j6eTehi75Nq7etepR3V5mIDlnNTY/MjZTCI0Uhz0RjlfcFqAtV3lbVotpyAombGW7ur9g2Md/jgrtiQzXSzQAxTAcGXTxWO2qiFgiWkpzDEVX0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilBLAaSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilBLAaSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824081F00898;
	Wed, 30 Sep 2026 15:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782567;
	bh=aKozkDPkPfyINo+2P5KHUc+JmJY41x7Y65ITbCULkdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilBLAaSDJC7W1ZcXQ1smIVaeDaP2dC06KPWxxbZ5BqKt2LXOVxLZOyH6Rtanb4LLq
	 1HCAL0bRN+5vFpR8nMpPr0TKR8EaVNENMg9HBl1Bk1pWq5sATSukuHpsaXqXbKB4hK
	 EC4jpq2OIgZ6Rrf1PhtLgblyZVVABHCji/GKESI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/595] net: qrtr: fix node refcount leak on ctrl packet alloc failure
Date: Wed, 30 Sep 2026 17:19:45 +0200
Message-ID: <20260930152349.719288740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 3b09ff54114566864eea59020f6b69c5bb325b9d ]

qrtr_send_resume_tx() calls qrtr_node_lookup() which takes a
reference on the returned node. If the subsequent call to
qrtr_alloc_ctrl_packet() fails due to memory allocation failure, the
function returns -ENOMEM without calling qrtr_node_release() to
release the node reference.

Add qrtr_node_release(node) before returning on the allocation failure
path to properly release the reference.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260528080019.1176700-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 31371f3c1a57b..465c1ddd11f53 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1003,8 +1003,10 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
 		return -EINVAL;
 
 	skb = qrtr_alloc_ctrl_packet(&pkt, GFP_KERNEL);
-	if (!skb)
+	if (!skb) {
+		qrtr_node_release(node);
 		return -ENOMEM;
+	}
 
 	pkt->cmd = cpu_to_le32(QRTR_TYPE_RESUME_TX);
 	pkt->client.node = cpu_to_le32(cb->dst_node);
-- 
2.53.0



