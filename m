Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23782493622;
	Mon, 31 Aug 2026 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185150; cv=none; b=qGzpQJFTe2cUYz+/hoArjPY/mj5/0HIXUNLsl7BfD3B0Ai6ouPmXst5tQq9TeJWMVWAmciq8nIlkz57L/OQfc1ffuhKU2RZHfRU8XZ1TXdmIbNjz2nUofYQvvdhr+GJx5fo+3CGON6/PgEvGxUP/2wjyRvcAvpSojv0GyPywOj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185150; c=relaxed/simple;
	bh=N6PUS3YtjcO4nyuu2UvL2rAm7EDyfHNNcPayIxp9zdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/OVH/wjJ/l7l9RhgQFnEATdlG8zHjk+zyD9nn27y8MeyfLb1maUF9wg0yynLzxGq7Jsk6NKEX+p1Oo+iYbWe/QnBdxbUe2et6nQeRQqPZ+zLtRtY4kJ7dTv2ulCIZyWV1A/h3PN5iQBiNcflBgEQ32boVGGKcMD+RuVnX3bSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8HEKeQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8HEKeQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8AF1F00A3D;
	Mon, 31 Aug 2026 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185144;
	bh=wxb/M/AoOJJ5hfWJAJVVJzCHl6quWHgn0+fbWnIrGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8HEKeQLZE2r9fHEhYTA8OUT6PS2hc/LfAR5qylT9KqtIWCNA6/+vHi7HB45nJ5FK
	 bYSRTkg01cBQdm+E/L/H9BhDwAHolg4SrgH8eVbPRVnDsK73fTHF747FJ2Z2RANmeo
	 DzeJKLdnwZEkLJpjAQTZ4Tj8Nh8oG99u4lueq/o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ibrahim Hashimov <security@auditcode.ai>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/69] nvmet-tcp: bound SGL data length before allocating command buffers
Date: Mon, 31 Aug 2026 15:35:04 +0200
Message-ID: <20260831133400.048049187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Ibrahim Hashimov <security@auditcode.ai>

[ Upstream commit 4a3f00262a044e8e15064b1a6860968bf0500bf4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -394,6 +394,19 @@ static int nvmet_tcp_map_data(struct nvm
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


