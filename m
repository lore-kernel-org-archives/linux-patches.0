Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0F2276028;
	Mon,  9 Feb 2026 14:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648105; cv=none; b=d4azgGU9019OaEo62aoJDjPBMsWJb7Z0uwajYSIYBswgnsKvG0QRikE6saZY7tqlJbCQrPERtSwDHVLxgxzy66J/C8YeiqH+Hgo71FfOzGXYm6L1NxdD5fxh3sDINjj1lUf0A2m4Ptel08O16NwSm1MMl1X21UzFQ1F6U2omCn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648105; c=relaxed/simple;
	bh=Fm4Oy5xYvaq8e1hR0/y321MDwOxnZjnMjoUBMMQYT0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKb9kgFUa6vTjkRAZ8mBEOScOPzaowfZqFNOPN8TEnEYuzlYeS1COJCBIwnPIAFP8OenwstHv0lMz5fwjXn4VPaRzTTbwMs4qjx/MQF8pNMgz+Inx1RnzGNv2aQk26UBVBbbXcURNSs87FoUP7me0H9IXF9yI1Qfwn6Ek7yQZ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elVhPh9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elVhPh9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF9EC19423;
	Mon,  9 Feb 2026 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648105;
	bh=Fm4Oy5xYvaq8e1hR0/y321MDwOxnZjnMjoUBMMQYT0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elVhPh9ARYuqEyndyVXwyevQgsC+seaM6tdr5H8q2RWINaR3LhJ3inrEtMGCS0LpO
	 Ky9gOqa70pJb7I/VBVj+1z0xX0neF1/dFVtpCsTSZZ91LA1WOV8HZ73uPL5/lzXdZG
	 /ESpTbD6eV30p1Mwo7fNH8dbKPME1IP4ZlMinJmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Joonkyo Jung <joonkyoj@yonsei.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 01/69] nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec
Date: Mon,  9 Feb 2026 15:23:29 +0100
Message-ID: <20260209142301.969554338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: YunJe Shin <yjshin0438@gmail.com>

commit 52a0a98549344ca20ad81a4176d68d28e3c05a5c upstream.

nvmet_tcp_build_pdu_iovec() could walk past cmd->req.sg when a PDU
length or offset exceeds sg_cnt and then use bogus sg->length/offset
values, leading to _copy_to_iter() GPF/KASAN. Guard sg_idx, remaining
entries, and sg->length/offset before building the bvec.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Joonkyo Jung <joonkyoj@yonsei.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -306,11 +306,14 @@ static void nvmet_tcp_free_cmd_buffers(s
 	cmd->req.sg = NULL;
 }
 
+static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue);
+
 static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
 	u32 length, offset, sg_offset;
+	unsigned int sg_remaining;
 	int nr_pages;
 
 	length = cmd->pdu_len;
@@ -318,9 +321,22 @@ static void nvmet_tcp_build_pdu_iovec(st
 	offset = cmd->rbytes_done;
 	cmd->sg_idx = offset / PAGE_SIZE;
 	sg_offset = offset % PAGE_SIZE;
+	if (!cmd->req.sg_cnt || cmd->sg_idx >= cmd->req.sg_cnt) {
+		nvmet_tcp_fatal_error(cmd->queue);
+		return;
+	}
 	sg = &cmd->req.sg[cmd->sg_idx];
+	sg_remaining = cmd->req.sg_cnt - cmd->sg_idx;
 
 	while (length) {
+		if (!sg_remaining) {
+			nvmet_tcp_fatal_error(cmd->queue);
+			return;
+		}
+		if (!sg->length || sg->length <= sg_offset) {
+			nvmet_tcp_fatal_error(cmd->queue);
+			return;
+		}
 		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
 
 		bvec_set_page(iov, sg_page(sg), iov_len,
@@ -328,6 +344,7 @@ static void nvmet_tcp_build_pdu_iovec(st
 
 		length -= iov_len;
 		sg = sg_next(sg);
+		sg_remaining--;
 		iov++;
 		sg_offset = 0;
 	}


