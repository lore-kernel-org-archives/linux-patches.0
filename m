Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6B51E449;
	Wed, 30 Sep 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790873; cv=none; b=vEJUO8pWyPOxZbLNswoMyX6VbxHasAWXrqwxuCBsFC5gN7Ah6pPKXLvSvguaa+itOy+VjG/B+0+mRahtrADtvynNVAxjy7qOXSp/ArgbYUyYyk4/EYbFfKBB/xc2dKlH6fJd9LM3mQ0nVkLnNj8GNvg5rHKUkniTxF/YomwR/2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790873; c=relaxed/simple;
	bh=5QUiQgJsZfqtcAIk9aqu4MAsvGEkF3uczPyc3rOXBCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPTcGMFV3jrlnuWJ16lg7A03DKFP0fncn8Hos2LUKsEw0hXruolQebpCFJu/HpnogMUnyyffS8q3cf1qofYOp6hUl7TQXe1M9ciuXZdy3GBIiQfdr6P8xQZ9TVMk+5G+EQigmFN/I74MUJjIH+q2miLv1D6hAMXJamVYe3/ytYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LaD+uww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LaD+uww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C401F000FF;
	Wed, 30 Sep 2026 17:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790872;
	bh=fnJQyHzEux/aiFvaZq/u6zH7y94eTw2abXwSPGYDHQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LaD+uwwck4T2HfP1DqJQlDQBv+1k/QE7XU+EU3FD6SWJmJ5zqLTIXKRISc4Fg0Wm
	 s12eN8568BTqlMYLCr32pg/+oAV8YMoaTAmk19Mr1X8KtzDGsXNgj8JCXzGsUB6EVZ
	 4ZCNvCeMW5Y7vabm2qpJwiK4RzicAUT9GApZ0Vnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/752] net: qrtr: fix node refcount leak on ctrl packet alloc failure
Date: Wed, 30 Sep 2026 17:19:34 +0200
Message-ID: <20260930152400.418041590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94bfb0397e5d3..95472ec3a3b74 100644
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



