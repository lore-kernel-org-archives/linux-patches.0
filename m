Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A76125B2;
	Mon,  9 Feb 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647720; cv=none; b=Z/xcwzSEl+hXmdqOrdaKCgSSLx1Z6BwQIBWwIAt1Na+QdmUqvIIW+csjb+SivKuuh3MxmmvFh+OhBX04/D1jfFZMxZGiHFWQwxj5ZYKyAeBgjfi6fcIj+GCQK/uSbmF1xsI9ns2NLq3wvN9NP4tQZ5iJaa/1kOdUAAg9j8AvKp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647720; c=relaxed/simple;
	bh=P9qjqQepGQSrDQ1xeF33gzppMVYazTlERF0VR1ijPtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROhO86fDPY/74N7DPVaJf5Gwts9Z36qgCMBejPz3LCTzWD1wJer6CxDPEjgoAcGtejYv3JUQPF2HX4RGpuTG6mauhN2Ul/tJlh8JDW8pqmKuJFqzvDvsX2f2WpLk5tt+WARn6xJivXFHgX0/tTDZjSLjzz5M2xM8VcpZr8M6d0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMYStsH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMYStsH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B9AC116C6;
	Mon,  9 Feb 2026 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647719;
	bh=P9qjqQepGQSrDQ1xeF33gzppMVYazTlERF0VR1ijPtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMYStsH1EnfI0Ro0GvW0B6pg2erYwp8X0rpqjDZE3hfFKpa2bNezs4PIuzm7hHV6Z
	 tXlbR65mrKytabS3ha9WnKzj87wdV7D1Vh9W3sf7s9LSX4yUKCDqWXkiN2GXoyBjaY
	 IyRCCHqtx2zFVBO3Dg+YE7xpcdvNQZyDLR0NZQOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Joonkyo Jung <joonkyoj@yonsei.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 001/113] nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec
Date: Mon,  9 Feb 2026 15:22:30 +0100
Message-ID: <20260209142310.260541459@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -357,11 +357,14 @@ static void nvmet_tcp_free_cmd_buffers(s
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
@@ -369,9 +372,22 @@ static void nvmet_tcp_build_pdu_iovec(st
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
@@ -379,6 +395,7 @@ static void nvmet_tcp_build_pdu_iovec(st
 
 		length -= iov_len;
 		sg = sg_next(sg);
+		sg_remaining--;
 		iov++;
 		sg_offset = 0;
 	}


