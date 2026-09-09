Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B614563299;
	Wed,  9 Sep 2026 13:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962074; cv=none; b=IHf1KRo7HFFSx+YzCQB20CSjJf3xfkfqPGCVTy5wXpKaSlIA/C/DscyEkcDl5ZyIN1ne35OhfSBsOqjsB1pAZL59TaJBfXlkG8duLdcoLYsfD10z/ek737UxWmgyJcAfFt+a1jDmGo0lOi9yTbOoLodpB/u+9HRdEycSGq+Wzqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962074; c=relaxed/simple;
	bh=ZBBb0K9fOk0ByD/iP9xRNDnpzTGg3t84cW6nTqP+7NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrO/npl9eT/60fNy4iO3r1CaJszwP0Bu7Syq+1R6SG79r3uRZaTsFzvDtRU+BNtrEPxgRrN+5ltmJEImMRRlVodowqaK7gdMgTOwCKpm7bb4IRNw+oKU7CNXAgThZG3jt7jZY5vSbqH7AhzsUeMLaLWFJCWJDR+3OBreGVfU7mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jolSEJaw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jolSEJaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57F21F00A3A;
	Wed,  9 Sep 2026 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962073;
	bh=frbVhRGqbeJUcvk65114fBx14IYT/33k5kYBL90ScvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jolSEJawhaqpOkTf9kB2BYNv1W/vc9jzf+U5zYknktsjjvEKQ5hL8KBX+pMONeiJT
	 BGolVIpYvQQqSYTngdrRPlUv3N0VqEOgT66G4JjGKQcEQGYQRc+zJGpnwhOL7GCWK+
	 s/qj7jHkhKQyXOli/64A43ISUjo34E8GnQsYjLHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 162/556] nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU
Date: Wed,  9 Sep 2026 15:37:22 +0200
Message-ID: <20260909134236.120523888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1244,6 +1244,8 @@ recv:
 		}
 
 		queue->left = hdr->hlen - queue->offset + hdgst;
+		if (queue->left > sizeof(queue->pdu) - queue->offset)
+			return -EPROTO;
 		goto recv;
 	}
 


