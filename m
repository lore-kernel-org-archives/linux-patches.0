Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47BC386C3B;
	Tue, 25 Aug 2026 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665247; cv=none; b=Ywqriv0hNPRp/17EseyrXpHlZgZTQcP14zbvMKvCo6ZqLF8Au3R52g9yCjRMssNq/fTzK/GsABIA4WZG3TnhHJFFEPaaT6G0xlVVPHTSRiEdP21TqcxYlg75Ti4uYwJtO053QwhBT9YmjT4QayShkFHGqMiJafw3KZFfHUheSIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665247; c=relaxed/simple;
	bh=ymbhqzZWP194/S+xSZ3rqNvs9q0KqP0lipWko//MJH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCkiB/IudZEdPMbzqcttsb4D+UDHIfmWtuz6Gr2l6LN1Yxql4mjem6UyFpvWmiOawKeqFnMj+b2iznlp2ZL+zxut1nNYlI/+M3Og8cbvTyHMQ2jH9CW9ZOkDV34xHxNEj/i1xV1/o55EaBBFTc1qjzgpjCZ5DTyjL/iGdB7VZUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tO6sORHW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tO6sORHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135601F00A3D;
	Tue, 25 Aug 2026 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665241;
	bh=FZmDQ5cTS6n2FHWKdOcePJt/jDfSyubOR4pDj8OP644=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tO6sORHWgO6VcuKi6pf3r6GRzLzbX7qgfRbZet54uGqkhWf+Hg8E0SxXfT7HbjQx4
	 0nLrkQHCnJlYcDgoM0mwHvPLPOS/RFnHj+TBcnGNF4x0m2ZXQUrVXlE/OB9DOiRh3X
	 FTP5OqNOjcP6CFkmkpeoLEtDyadS7uHNJvD5JgoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 54/94] nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations
Date: Tue, 25 Aug 2026 15:25:50 +0200
Message-ID: <20260825132544.016523535@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 737a3b535247226f6e1a7988fd9d6e63e7d6fc71 upstream.

When fuzzing the nvme target code, I tripped a kernel warning in
nvmet_tcp_map_data() because the length passed into the allocator is
controlled by the remote initiator.

A remote initiator that sends a command with an SGL claiming a huge
number, can create a scatterlist and iovec allocation of over 1 million
entries, which causes the backing kmalloc call to exceed MAX_PAGE_ORDER
and then the page allocator will trip on a WARN_ON_ONCE_GFP() message:

  WARNING: mm/page_alloc.c:5280 __alloc_frozen_pages_noprof
  Workqueue: nvmet_tcp_wq nvmet_tcp_io_work
  ...
  sgl_alloc_order
  nvmet_tcp_map_data
  nvmet_tcp_try_recv_pdu

As it's never good to trip a kernel warning remotely due to many systems
having panic-on-warn enabled, let's silence it by just add GFP_NOWARN to
the allocation flags.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -457,14 +457,15 @@ static int nvmet_tcp_map_data(struct nvm
 	}
 	cmd->req.transfer_len += len;
 
-	cmd->req.sg = sgl_alloc(len, GFP_KERNEL, &cmd->req.sg_cnt);
+	cmd->req.sg = sgl_alloc(len, GFP_KERNEL | __GFP_NOWARN,
+				&cmd->req.sg_cnt);
 	if (!cmd->req.sg)
 		return NVME_SC_INTERNAL;
 	cmd->cur_sg = cmd->req.sg;
 
 	if (nvmet_tcp_has_data_in(cmd)) {
 		cmd->iov = kmalloc_array(cmd->req.sg_cnt,
-				sizeof(*cmd->iov), GFP_KERNEL);
+				sizeof(*cmd->iov), GFP_KERNEL | __GFP_NOWARN);
 		if (!cmd->iov)
 			goto err;
 	}


