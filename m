Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823E314B7C;
	Wed,  3 Dec 2025 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776921; cv=none; b=NNcl38/E8KK6GtuIFjk3sWMS3MhVKS+T45TOLieCzpxwgaBVkRDK6jj/bYDWRAOYerebasJUGs1E2eSId2OXfkPAihspKSq67MvIEAlp6joO2RkMy9zenVysiWv7HBw3inf/9tI8Bhd//bFA4933eTPicsjCNCalB/g3YYurf/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776921; c=relaxed/simple;
	bh=Jg2t8fWCelmUYRKrXDN49NfJWac2v8L1Be2NjY8xLV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1qft2EZV5BMeaB4p9SwTocJt5e2KJoKfztOY1ALVi/XRZmNQGOShP0i0hDx/0CulUaHUN3mSpno+5PzBEkmpI7cEB3JKY0UcqM6XhsQYchkqs2UDNwrMExpegS1K2THkmngs281koZQcssTYpX0iCBaQ9Xfcv1i3Ju6Lu1IqMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBQ4QlmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBQ4QlmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABD5C4CEF5;
	Wed,  3 Dec 2025 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776920;
	bh=Jg2t8fWCelmUYRKrXDN49NfJWac2v8L1Be2NjY8xLV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBQ4QlmNUccVZci61rw0kn1HIslGxvQK7Qd52JKTdC7qfALuQrTvop0hUk8n1idNB
	 /K5REGNzkDTpfVFnbZ9b4GTs8CFfZhkb770sxtOJ9J77f2KMmLeReInBQWXq3wt95E
	 6Oj9cgV0WtEfV1paQu4Z49Eu6Anfkx3GQ6AkJIk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 027/146] eth: fbnic: Fix counter roll-over issue
Date: Wed,  3 Dec 2025 16:26:45 +0100
Message-ID: <20251203152347.462053636@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <mohsin.bashr@gmail.com>

[ Upstream commit 6d66e093e0740d39a36ef742c60eec247df26f41 ]

Fix a potential counter roll-over issue in fbnic_mbx_alloc_rx_msgs()
when calculating descriptor slots. The issue occurs when head - tail
results in a large positive value (unsigned) and the compiler interprets
head - tail - 1 as a signed value.

Since FBNIC_IPC_MBX_DESC_LEN is a power of two, use a masking operation,
which is a common way of avoiding this problem when dealing with these
sort of ring space calculations.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Mohsin Bashir <mohsin.bashr@gmail.com>
Link: https://patch.msgid.link/20251125211704.3222413-1-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 0c55be7d25476..acc1ad91b0c3a 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -201,7 +201,7 @@ static int fbnic_mbx_alloc_rx_msgs(struct fbnic_dev *fbd)
 		return -ENODEV;
 
 	/* Fill all but 1 unused descriptors in the Rx queue. */
-	count = (head - tail - 1) % FBNIC_IPC_MBX_DESC_LEN;
+	count = (head - tail - 1) & (FBNIC_IPC_MBX_DESC_LEN - 1);
 	while (!err && count--) {
 		struct fbnic_tlv_msg *msg;
 
-- 
2.51.0



