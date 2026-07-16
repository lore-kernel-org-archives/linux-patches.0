Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113F13161AD;
	Thu, 16 Jul 2026 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211205; cv=none; b=qqJ9Q8K612pQab9QIznBDiHn+SqAanEJki8zL6+YHeemAFsMVWodQOP1uy+jT8cSYG3GRAnaUoPU/wLlgEj1BkzESBR3cqTcLysCclc40qzfW5yzLPWUaVIzmLMbaBQ6YzXHN05cqx+P4wLb56dUfxLljIuAIbAWh9eHRD0TLgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211205; c=relaxed/simple;
	bh=opiGihyuADyth+4MRlrqskKCUF1Tqlg8h/+QBjIRZbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGgh+gzm9t8rLy+ctOmzMZ7tOILfrqdgowX5SW9fUgRv5XtqNQL/fgVNvOsK31hy+1DIXaCXLMXb0HiP/YHRLJAZ7ddLhoxhZMBCqPASPj0/Fk7M5jB1/SIhbnUovKz1Vv9w4P3weUA4YncX4/FvdP8vj0QxKZfSshtrvLdEBb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKGoG/xM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKGoG/xM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777F61F000E9;
	Thu, 16 Jul 2026 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211204;
	bh=bR+ZOln68a+sCSiHpmF2Y1iZDPVZ1nwuEwVWqTg2Gkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKGoG/xMvp2hZHNPu/IndguL/sQUUjzccY51LAJiDh/APryJHi4tY4+dZkYwaK72O
	 4ZzwyGxs0DeOkpBEipUICKJ1NZVwVqzqcFqiwU21r84D+8WZ8aJsUJO8JPW5N0S7Bb
	 RJA6tsccV8LlkLuSYH3MlgGouf0ziMMF+Lh1o3Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 340/480] nvmet: fix pre-auth out-of-bounds heap read in Discovery Get Log Page
Date: Thu, 16 Jul 2026 15:31:27 +0200
Message-ID: <20260716133052.164498553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 53cd102a7a56079b11b897835bd9b94c14e6322c upstream.

nvmet_execute_disc_get_log_page() validates only the dword alignment
of the host-supplied Log Page Offset (lpo).  The 64-bit offset is then
added to a small kzalloc'd buffer that holds the discovery log page
and the result is passed straight to nvmet_copy_to_sgl(), which
memcpy()s data_len bytes out to the host with no source-side bound
check:

    u64 offset      = nvmet_get_log_page_offset(req->cmd);  /* 64-bit host */
    size_t data_len = nvmet_get_log_page_len(req->cmd);     /* 32-bit host */
    ...
    if (offset & 0x3) { ... }                               /* only check */
    ...
    alloc_len = sizeof(*hdr) + entry_size * discovery_log_entries(req);
    buffer = kzalloc(alloc_len, GFP_KERNEL);
    ...
    status = nvmet_copy_to_sgl(req, 0, buffer + offset, data_len);

The Discovery controller is unauthenticated -- nvmet_host_allowed()
returns true unconditionally for the discovery subsystem -- so the call
is reachable pre-authentication by any TCP/RDMA/FC peer that can reach
the nvmet target.  With a discovery log page of ~1 KiB, an attacker
requesting up to 4 KiB starting at offset == alloc_len reads the next
slab page out and gets its content returned over the fabric (an
empirical run on a default nvmet-tcp loopback target leaked 81
canonical kernel pointers in one Get Log Page response).  Pointing the
offset at unmapped kernel memory faults the in-kernel memcpy and
crashes (or panics, on panic_on_oops=1) the target host instead.

The attacker-controlled source-side offset pattern
"nvmet_copy_to_sgl(req, 0, buffer + ATTACKER_OFFSET, ...)" is unique
to nvmet_execute_disc_get_log_page in the entire nvmet codebase: every
other Get Log Page handler in admin-cmd.c either ignores lpo (and
silently starts every response at offset 0) or tracks a local
destination offset with a fixed source pointer.

Validate the host-supplied offset against the log page size, cap the
copy length to what is actually available, and zero-fill any remainder
of the host transfer buffer.  The zero-fill matches the existing
short-response pattern in nvmet_execute_get_log_changed_ns()
(admin-cmd.c) and prevents leaking transport SGL contents when the
host asks for more bytes than the log page contains.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Cc: stable@vger.kernel.org
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/discovery.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/discovery.c
+++ b/drivers/nvme/target/discovery.c
@@ -166,6 +166,7 @@ static void nvmet_execute_disc_get_log_p
 	u64 offset = nvmet_get_log_page_offset(req->cmd);
 	size_t data_len = nvmet_get_log_page_len(req->cmd);
 	size_t alloc_len;
+	size_t copy_len;
 	struct nvmet_subsys_link *p;
 	struct nvmet_port *r;
 	u32 numrec = 0;
@@ -242,7 +243,27 @@ static void nvmet_execute_disc_get_log_p
 
 	up_read(&nvmet_config_sem);
 
-	status = nvmet_copy_to_sgl(req, 0, buffer + offset, data_len);
+	/*
+	 * Validate the host-supplied log page offset before copying out.
+	 * Without this check, the host controls a 64-bit byte offset into
+	 * a small kzalloc'd buffer: a value past the log page lets the
+	 * subsequent memcpy read adjacent kernel heap, and a value aimed
+	 * at unmapped kernel memory faults the in-kernel copy and crashes
+	 * the target host. The Discovery controller is unauthenticated,
+	 * so the bug is reachable from any reachable fabric peer.
+	 */
+	if (offset > alloc_len) {
+		req->error_loc =
+			offsetof(struct nvme_get_log_page_command, lpo);
+		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
+		goto out_free_buffer;
+	}
+
+	copy_len = min_t(size_t, data_len, alloc_len - offset);
+	status = nvmet_copy_to_sgl(req, 0, buffer + offset, copy_len);
+	if (!status && copy_len < data_len)
+		status = nvmet_zero_sgl(req, copy_len, data_len - copy_len);
+out_free_buffer:
 	kfree(buffer);
 out:
 	nvmet_req_complete(req, status);


