Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3631987D;
	Wed, 30 Sep 2026 18:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794388; cv=none; b=LleGnknw5LLA8dzmy8eBtYxrxHvih0ygA0xqacDDkU31XX7vpP3LnzUADvSGYvgdVq6t8g356ne9KtUdVtpEv9kVFk9lBur1SMNHj4cBQBWLFQA9oIOdOcwMyznuEqx3wKdt58vFujUvWIA5gX4sWQwQbiaprwDt8oY7JkGHNl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794388; c=relaxed/simple;
	bh=veQKcz+9rEMbSrGdAyPJTZbWHH4W+yFeRgncJJ86fms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgz0VtgJ39cjh9VqRi3za0gg00qzajYHajHIbPNAn4luJTgv7w8H5ivNkcxkmGIi8tmcPPtdhNcuO/tvEueUPV/hmpgzGrxCqUEr96lZdB+zYleQSlTQWU+yMmaFRLuoCLsjRQ4YDkn1Oz8AGKad2LdzuWZETZ9B2wXEiQwzR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4APP/RP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4APP/RP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D11F000FF;
	Wed, 30 Sep 2026 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794387;
	bh=PCFYKTlp42BXhoBI2HDQsjXmTuYxcqCnQZxMuF16g5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4APP/RPS1VyzGsMjecm6TwZ7iGdDXbcA6mBNqTjHSKQIR9l4KlXAGjeaVsq70W6G
	 bvdKpqVW76zB+qdRZ5abC+lGMFq/Q+PznnbTDAkeW5cxixS9qgPb4jyXdqtL4yF5j8
	 hJYAT0RygJTgtxD+kVdc0hKWHlY+kFq7SvDFKe64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0155/1193] net: qrtr: fix node refcount leak on ctrl packet alloc failure
Date: Wed, 30 Sep 2026 17:13:59 +0200
Message-ID: <20260930152437.647942000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index fcd24a7df3f00..1f40496d84a33 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1009,8 +1009,10 @@ static int qrtr_send_resume_tx(struct qrtr_cb *cb)
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



