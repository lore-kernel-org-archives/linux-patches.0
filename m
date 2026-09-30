Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70044F30C4;
	Wed, 30 Sep 2026 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784386; cv=none; b=s6i0rjBGBYGB0thD+iO/I6m/Y3XXQaWCLps2uzWkuMIZBM9GQV8J/hhJP/85/FOhm0B9xDy8Z53dl9HHgBDS/cmS+jB1BAcLNQShTAjSvDX3h4gqd47wn01Gx2hcvnBf97DhYtHbWolOKxyUPXYF3fIpcpg2QF+xAi0tAtZaqsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784386; c=relaxed/simple;
	bh=ncenqRnDZcH//JGBf10A7NNeOd4rTD1SL9ALHoSyV5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adyjLabLHHpvCttGc7e3PlNtSsownGtB3Djph2vEWXJsxZYXUTn8bBRh0nNE27YTdlw0pBaHSw+nmoAZGCq3j8zv033glkwBreAIPlXGMJ3ooWoroOjF4TWVMrwezSedncDTkqSTdGWaFRSswIgfB+OmdBqffV+2biXHrGl572s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIqolFX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIqolFX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB91F000FF;
	Wed, 30 Sep 2026 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784383;
	bh=PiMIRa5o3zEwLJcj/6fOlur+1g97zUIkFQNnZ5GibaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIqolFX8fZpBYwuI8XVCFIL9KgsU6zWmAOzH2B5QXIDs7eD2VfkmJPAT2PNJN9ky2
	 teDkqkiWwuMxie9srs4mH0hF7NDqsFUP42wjaQJwMEqN3pGAbuwVpJ4b/ztW69yXDY
	 Fafw1hrpoHi9flsluPHvfMZiTxy0xT4B1ILoYmb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/982] net: qrtr: fix node refcount leak on ctrl packet alloc failure
Date: Wed, 30 Sep 2026 17:14:32 +0200
Message-ID: <20260930152419.737734428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index d13ca058fef6d..7e5527ca6ab92 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1004,8 +1004,10 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
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



