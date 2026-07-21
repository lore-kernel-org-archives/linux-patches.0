Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243AE43E08F;
	Tue, 21 Jul 2026 22:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672252; cv=none; b=edoVVAHAM4H4xQmtyK905D6bLKgOtgMxdETeuYMyaP4k8YuPdXqH4UlX46MRnJkYNNPx4netdYg8u/8KPl9MmcJsOC+ePmkzlkLPqxeX5wFTaeIgKUlMbo4KMATwqd6qx1ScznUXJl5sRGBFhonboPiP5aiInoRxurrKEXBQ2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672252; c=relaxed/simple;
	bh=lj9Q6+L9OnZ+M5Xo9t5vxGEdiXXabNZVuXY8qs5JASE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7FJCpD62AP72aK1IbSkPVD4As1R8Bsi/E0Da8uRnK3gWnJPAIEcWc0rnvgTBwiMFwhl/e80b+Pg77mIH7phCMTfKwcUon4npfITTr7Nf1GOwRncCQO2kby9Otd9mIemCDGBt6B6DzviKHQpDyyBn7XQ8Kuxv7l7oqQB0XF+SsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XyPhPn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XyPhPn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA221F000E9;
	Tue, 21 Jul 2026 22:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672251;
	bh=tzJIz7UBTexbfHTrvjFCRSo12lREgaP8dH4gu3fXBho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XyPhPn0Tw7qULSzR7ACpMVmRv6HNrEPQ8Mrccku8LuwG6szlDQCHgOnHJqhtuycn
	 Av/OMf492kI1NlSrE1jM7QoAeWzDvYjS/+qyjOO2e/FiA+xIWk4Fb50qQxhnf9s8v8
	 GsKr8w1PsfXSlvsJ6HNpyk3tIwkbkFWK+40g9OhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 555/843] net: qrtr: fix 32-bit integer overflow in qrtr_endpoint_post()
Date: Tue, 21 Jul 2026 17:23:10 +0200
Message-ID: <20260721152418.532861029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -491,7 +491,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 		goto err;
 	}
 
-	if (!size || len != ALIGN(size, 4) + hdrlen)
+	if (!size || size > len || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if ((cb->type == QRTR_TYPE_NEW_SERVER ||


