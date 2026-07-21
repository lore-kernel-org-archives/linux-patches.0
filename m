Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A21F3D56;
	Tue, 21 Jul 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654082; cv=none; b=I4Aj85CdYV7CybZOsHy6/edUTzi0ECLhCfLtMINNxApGrtOXY24aAuurUN0Pqw0IvIAmUaBMAgYdjjiE0HwiOeuxvada4g+M6WqPs0Exmlp2lRuiIl+c+yZPLOq1t4a61vHz5TYOuEZlCLKYf0WeF49p8+7NR+VVAV0fi7HxeZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654082; c=relaxed/simple;
	bh=a7/+LxnepHt5Tyz33kqxnnfMtP/G4V/wkhfbJ6NebsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv4bSoriFNnwgn9ZloYNCPMiEU/CoD7XV5SvlmeNDW8Ej4yE4UQmq3NlKdxtpD771bGj8ZJUHWG3KdBEJ8RwtHp2KTpcjZijgdJbO41FCy/OYto7T8I/xI+/bo94rq9gVDrxKCnf9o4mlHnvQCULFK6wLW3ibRGp/8e9WadZVtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/K6xoor; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/K6xoor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4FF1F000E9;
	Tue, 21 Jul 2026 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654081;
	bh=ifqt0q9jbYkXJG16UqjIVOKXXq3Lr1p/Yf2JsX7ztOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/K6xoor0qtUZBoDZHA2sdIQtDg4bv8USgiUY+W3JdQ3Fg28ukb2mexC0bchpXSYv
	 YOWJDjr6HEaX5SHbYn2mi7jvnOwWNLsw9tuRfwzotkuljrdTRPgieyDvi/ywx7twek
	 rjgAYAEffoahO9zqzb4Aw07qxbBZf9P04WKVlHWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1526/2077] net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()
Date: Tue, 21 Jul 2026 17:19:59 +0200
Message-ID: <20260721152628.773867655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


