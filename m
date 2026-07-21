Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8066386C1C;
	Tue, 21 Jul 2026 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667002; cv=none; b=I7pdbxGI9v2a2IB9oy4KDON4E7dnHCrow4C6noVw8eRfPtmAF01pnS7g6wfn3xvW6E0J6axhpAvmJcNHINDkrhVTRI9uUa6TbzNp0Qz+riCjMyP55XpOKHpIxpzh7s4ftXhuMnEq41E0FKauz/VTUuD/Eia+/zvkRWylRgj8g0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667002; c=relaxed/simple;
	bh=ydmr5dv9EABABHN9sm15PxizU7UG+QZrsFSaHF/5RWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWKgIZEZ7iKkIYroDNQI/hh1RWBGLxrGrYUgPgZ9fyfr8K4zgQNh8nT9oOKHV0MXTm9y+5Jt7r4Gau7fv/bHp0RK/4PJM5+MswZSPtItxWXvc2x51N/zv+iebpouIZf4svKli3j6c53YytmCVMn9dhomT+mnbGoQSBdFZSdaqIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOXtd4bZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOXtd4bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1835B1F000E9;
	Tue, 21 Jul 2026 20:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667001;
	bh=yhOvNM4Kuz8x1PXfY+QVjBWVXQSonWZkqEPi5sXWuD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOXtd4bZp4V5i6jH09QXMGVNyk49tVHXjctkGXAzcg1YaEbD69fGu/GnXls46qpb0
	 MTiwxX0p20omrb4qqUemIhF9w6pxWtPmWIZWGgBY/yiWo0Fny8/4R8lyb1aPk37Zq4
	 Cncq4Z50VtaaAM0+6fe4VlssWQGi1TDnGREzOMfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0896/1266] net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()
Date: Tue, 21 Jul 2026 17:22:13 +0200
Message-ID: <20260721152501.898305099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


