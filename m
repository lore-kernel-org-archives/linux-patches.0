Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB1C481255;
	Tue, 25 Aug 2026 13:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665241; cv=none; b=On85xjg5oe9KDjLHKiABbkXmIhpjpdCksGg4wta/M7Fm3x963LbnGK2ou2OZjHfPWIQAT97QgztVGSqfEW52MC5KUXA6bBLAq+bhhWVis9OXpuLo45pYLe/YEsQ5wJgqE6EjRLEXVzt0aFedoGWVmQ+UXHYg9JzdV71CdLepPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665241; c=relaxed/simple;
	bh=IUBWcn1Hp1+UBdNg1yDeuisTJBZ7dvhDL0tkbeBK59M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noHVinqKg/hhzE/fITmI1xpdu2XcyFUH8NONVk//PqdSb31v/uZJEQpQe5MVcuJh1tPAenssgXpdPlHCLIKXdPjkZ1HlyM3/iFZHVBaT4tejSbr437t0tEprAg8jx0AQ4AfTQ5IiAneT/uI21LmfOWMpZwe/v/SdpGbT/29n7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P57rRgKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P57rRgKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253951F000E9;
	Tue, 25 Aug 2026 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665238;
	bh=ySX8fZ7hvRwRUxFx1ex6jwBTWc9tK2KNGk83cl7rKUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P57rRgKYDzNTOf3WxiFyRHIagn9cGug2DRIUKNKn62r6vJtjGNIrRkLkPa60HURf6
	 bDFEujWbPRvs0fo5TZrAJ8MxrF5G/+2N3aLX+L1Ms/6BcfO57f0RY21bX4skqE5xZK
	 v3w5Do7VcyJTTfZZsPaHbGsKH31wtEGlotuIkSEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 53/94] nvmet-tcp: bound SGL data length before allocating command buffers
Date: Tue, 25 Aug 2026 15:25:49 +0200
Message-ID: <20260825132543.981156042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

commit 4a3f00262a044e8e15064b1a6860968bf0500bf4 upstream.

nvmet_tcp_map_data() reads the host-controlled 32-bit sgl->length
and, for the in-capsule offset descriptor (type 0x01), checks it
against port->inline_data_size before use. Any other SGL descriptor
type -- including the non-inline transport SGL data-block descriptor
(type (NVME_TRANSPORT_SGL_DATA_DESC << 4) | NVME_SGL_FMT_TRANSPORT_A,
the type a real host uses for out-of-capsule writes) skips that check
entirely and falls straight through to:

	cmd->req.sg = sgl_alloc(len, GFP_KERNEL, &cmd->req.sg_cnt);

with len taken directly from the wire, unbounded up to 4 GiB.

nvmet_req_init() only parses the command and never inspects
sgl->length, and nvmet_check_transfer_len() -- the only other place
transfer_len is validated -- runs later, from req->execute(), after
the allocation has already happened. For a write command the target
responds with an R2T and parks the command waiting for the host to
send the data; if the host (or an unauthenticated peer that simply
never follows up) never does, the sgl_alloc() buffer stays resident
for the life of the command. NVMe/TCP has no mandatory authentication
in the default configuration, so any peer able to reach the target
portal and complete a Fabrics connect can drive this with a single
crafted command, repeatable across queues and connections for
amplification. This is unbounded kernel memory allocation
triggered by a remote, effectively unauthenticated peer.

Validate len against the same NVMET_TCP_MAXH2CDATA ceiling this file
already uses to bound per-PDU H2C data, for every SGL descriptor type,
before doing any allocation. This closes the gap for the non-inline
descriptor while leaving the existing, tighter inline_data_size check
in place for the in-capsule case.

Runtime-verified on a v6.19 KASAN stand: with this bound in place, a
crafted write command carrying an oversized non-inline SGL length is
rejected before sgl_alloc() runs, where the same request previously
drove an unbounded ~256 MiB kernel allocation (up to 4 GiB) that
stayed resident pending an R2T the host never satisfies.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -433,6 +433,19 @@ static int nvmet_tcp_map_data(struct nvm
 	if (!len)
 		return 0;
 
+	/*
+	 * inline_data_size only bounds the in-capsule (type 0x01) SGL
+	 * descriptor below. A non-inline transport SGL data-block
+	 * descriptor skips that check entirely and would otherwise reach
+	 * sgl_alloc() with an attacker-controlled len of up to 4 GiB,
+	 * pinning that much kernel memory for a command that may never
+	 * complete. Bound every descriptor type here, before allocating
+	 * anything, using the same ceiling this file already applies to
+	 * per-PDU H2C data.
+	 */
+	if (len > NVMET_TCP_MAXH2CDATA)
+		return NVME_SC_SGL_INVALID_DATA | NVME_STATUS_DNR;
+
 	if (sgl->type == ((NVME_SGL_FMT_DATA_DESC << 4) |
 			  NVME_SGL_FMT_OFFSET)) {
 		if (!nvme_is_write(cmd->req.cmd))


