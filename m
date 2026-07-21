Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38758415F2B;
	Tue, 21 Jul 2026 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658337; cv=none; b=Tnmb0l2DV/b6s3Kq1vvdEP6URXFGGIVlC0J03+BuNWwbv8CAKBOoUAgaOP9z934a/YMjIFAmvhMQRXADkzq1p2FGkPt3OzrmQwcdjA1CHiIg5krvyVcvf6P4liPktdU0wdqgNL4q70QMTlqEhk5Or3riNbYdpwip27TaQ9HFXIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658337; c=relaxed/simple;
	bh=j7TiJhE6vaC7tvo5pHlx23XIwulpfK5ZkLYyeqGHP3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8VUlAdr9ACYPKgZxiGYTBX5HiuoEIuBf3qvmdfpsvX9hmq+K3fCQxNk+gezcPRsnCrJvPOod8Wdrcld2xIC3EPEaDaFCAmTPOIDJqNavpIQrK40IPsllGnflGSAeoolkqECIcV+D8vfOyMHRRvGi0/aBydNO07TAwakoB+cJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKq7ka94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKq7ka94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD3E1F000E9;
	Tue, 21 Jul 2026 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658335;
	bh=4RT1xAWmJDWW9CHlk77neodQ7lC+6TGTsImu6nVnJf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKq7ka94cqevoGHLyvSo8QBpuqX3f71xEesptTmPADLHiXIEEJTgGZ4/LvUHZG7S4
	 l65wqfsd6FnswB3/QFQ5YFOfCGWSQ05PIJ4T7L90DnVRHYEVJcVuKjeQ9XDWE9pc1s
	 1A0qrOgedoB61swqxZq0xhIzmiRYCrhUU69dcxak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1104/1611] net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()
Date: Tue, 21 Jul 2026 17:20:20 +0200
Message-ID: <20260721152540.246976547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 20054869770c7df060c5ecee3e8bbf9029c47191 upstream.

qrtr_endpoint_post() validates an incoming packet with

	if (!size || len != ALIGN(size, 4) + hdrlen)
		goto err;

where size comes from the wire. On 32-bit, size_t is 32 bits and
ALIGN(size, 4) wraps to 0 for size >= 0xfffffffd, so the check
passes and skb_put_data(skb, data + hdrlen, size) writes past the
hdrlen-sized skb and oopses the kernel. 64-bit is unaffected.

This is the 32-bit residual of ad9d24c9429e2 ("net: qrtr: fix OOB
Read in qrtr_endpoint_post"), which fixed only the 64-bit case.

Reject any size that cannot fit the buffer before the ALIGN.

Fixes: ad9d24c9429e2 ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260611125455.2352279-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/af_qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -496,7 +496,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 	if (cb->dst_port == QRTR_PORT_CTRL_LEGACY)
 		cb->dst_port = QRTR_PORT_CTRL;
 
-	if (!size || len != ALIGN(size, 4) + hdrlen)
+	if (!size || size > len || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if ((cb->type == QRTR_TYPE_NEW_SERVER ||


