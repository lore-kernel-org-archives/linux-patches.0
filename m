Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD25F480968;
	Tue, 25 Aug 2026 13:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664690; cv=none; b=Rd1WhhRwmMforxnl1RJQPRV4oGD0+RwQbdDxsUveYvwDiINdXRtxhai5WUmFTxi3KAe+bYtpqJrGSVSK2ruKYfcDF86Z1iGpFCAXY9d1t5HOTi8AkTmQKDpZvO1jCpmM2qFuZfah5TFnx2JavblnKDT+FxVe9MJ8T75QkQhRa7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664690; c=relaxed/simple;
	bh=/F9pb37zMWn3mqv4R7KvA5Vn7r755NT44zNgdyY2IR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+/U7QMWUPYkBOxxQ2GcBWdUHSmNLVtpoo5HB+oZZXm1wnenjXP7833U0L1s0HhdrH8vhdpVvNbyBUJDqvwg7NbISEg6JWYxA/ZvJxhZy+XptJRpni0q3LpCBuIfkMLEz1BzmL4QFLjFX92oiYcpe5jVms00EqEfq6Ofpk3uKbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gz5G3pOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gz5G3pOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DB71F00A3A;
	Tue, 25 Aug 2026 13:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664684;
	bh=/dQLDu+h4ghLhKieZbLUzTq29xXNDC8C2HMguvPz7vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gz5G3pOaB2k0QAQs/VWLIQAALOemT83Qr88aMyOtG+8nRWzrlCLipvlMBkLywbnt6
	 W8vo2+9lqreN3qLXWd131j/+49aKHYo06BWOBZ/+g6yMmQywz2obsif/ZfpwRACkqa
	 23iSHF+kqGyVHZqfSn2CxYW0x0fVatMkjN0QADlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 53/82] nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations
Date: Tue, 25 Aug 2026 15:25:40 +0200
Message-ID: <20260825132543.599586111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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
 drivers/nvme/target/tcp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -446,13 +446,15 @@ static int nvmet_tcp_map_data(struct nvm
 	}
 	cmd->req.transfer_len += len;
 
-	cmd->req.sg = sgl_alloc(len, GFP_KERNEL, &cmd->req.sg_cnt);
+	cmd->req.sg = sgl_alloc(len, GFP_KERNEL | __GFP_NOWARN,
+				&cmd->req.sg_cnt);
 	if (!cmd->req.sg)
 		return NVME_SC_INTERNAL;
 	cmd->cur_sg = cmd->req.sg;
 
 	if (nvmet_tcp_has_data_in(cmd)) {
-		cmd->iov = kmalloc_objs(*cmd->iov, cmd->req.sg_cnt);
+		cmd->iov = kmalloc_objs(*cmd->iov, cmd->req.sg_cnt,
+					GFP_KERNEL | __GFP_NOWARN);
 		if (!cmd->iov)
 			goto err;
 	}


