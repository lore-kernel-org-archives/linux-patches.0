Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9B581225;
	Wed,  9 Sep 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963536; cv=none; b=HloWmFlEDzqOIKGJdyw987qkaVYuIPbG1hN3Q7R5i8nG/A6aHyuXqcVVW++1Pz2loMdq643qW/Mi/vRU9XIpjV3bU7v79lmGubH7Zpy+wC21KNeDCE6COsTRKK3zewdOdG3jg3lDu4fPqlzUFcBVD7cykshckfJ7DfzqTcKVDpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963536; c=relaxed/simple;
	bh=WWKnY0Q7TKM0SqziQCqxCkT17lHHZUGYXViUhfM1ahk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rakn6B4ir1Z6xEMT6xpH8Ksuz6ukeTaVTOqwO0wG+hAaSsmG04JsHqaB+PDSqRoujwZjNeQcqU8mreXOk9xMRSwZlEbrQtYebQWl/h7APksvgtrKugMvuRb+b9ncEIegvoxnuZaJAqI9V5AQR0OVwlrWg/eJZg+UccQE+Q92KUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW4D+1as; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW4D+1as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E81F00A3A;
	Wed,  9 Sep 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963534;
	bh=jxtUAdwrf7Vthmnb3fVz3Kn++M5KXmcKNR0/nQ6Ox1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bW4D+1asyShJEYkQRmfNCWiWLIHOwVlGbXJNrATH4MdBrG/5b3BgRJTFDTaeqYkOy
	 Tv3mxDtFJIH9lQMYkJEhzSK+0WLD1S8DQPcMCggiRlXPmzHa2jwZBhSeejlSPuYMUx
	 eKyanb6ztSZsKMq7vRPPGewJMjMzj64WEa7Sdk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 111/583] nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU
Date: Wed,  9 Sep 2026 15:36:36 +0200
Message-ID: <20260909134241.979888233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Shivam Kumar <kumar.shivam43666@gmail.com>

commit 14cc5a7e77731497d5bea70f3bb05df7eda982e4 upstream.

nvmet_tcp_try_recv_pdu() reads a PDU header into the fixed 128-byte
queue->pdu union, then computes the remaining payload length as

	queue->left = hdr->hlen - queue->offset + hdgst;

and reads that many more bytes into &queue->pdu + queue->offset, without
ever bounding the result against sizeof(queue->pdu).

A struct nvme_tcp_icreq_pdu is itself 128 bytes, exactly the size of the
union. Once a header digest has been negotiated (hdgst = 4), a second
ICReq passes the hlen == nvmet_tcp_pdu_size() check but yields
queue->left = 128 - 8 + 4 = 124, so bytes 8..132 are written into the
128-byte buffer -- 4 bytes past its end, over queue->hdr_digest and
queue->data_digest. Those bytes are attacker-controlled (an ICReq
carries no digest), and the duplicate ICReq is only rejected later,
after the overflow. A remote unauthenticated host can thus corrupt
kernel memory adjacent to the receive buffer.

Reject any PDU whose declared length would read past the end of
queue->pdu before the second recv.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1262,6 +1262,8 @@ recv:
 		}
 
 		queue->left = hdr->hlen - queue->offset + hdgst;
+		if (queue->left > sizeof(queue->pdu) - queue->offset)
+			return -EPROTO;
 		goto recv;
 	}
 


