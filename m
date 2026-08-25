Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD7D3C276D;
	Tue, 25 Aug 2026 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665768; cv=none; b=d8oMvUPDXC7ktrCFGYpzy9gSJ12GWUVcgiZWgCuRUQLXgrpsaXgyYnjc+dw9pmt2XulOl19Uz1Hj/FUfrDdZVpsUdsa4U6z8+skGOtgNZy+Gzfux/G96gLbMbH6O69E+NAQ5wF8Kg2a4Ikqlq/pi4ypGiph/rIo/ruhphZaWReg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665768; c=relaxed/simple;
	bh=l64AKjcP5lhZX75r6Nt/XOgT+NKHzrNRt5rCeRQxOtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMXSDzqkji+r9UBBed13lx/MDFn2/PWOsQQ/hxwcX3vf2jv4YQkmk01fsBAJ0YqSSZlaDcnN1rpURHylilnnNOefYomAblZNSoUBYv3oNh9K2A/b232lpg9HshbldxFP+PcsfMwluhGW7Hzy2b/tE16MOzqou8/z0YEn3NRi+jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUWPP7S4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUWPP7S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1231F000E9;
	Tue, 25 Aug 2026 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665763;
	bh=DOsuAeEX4pdjl7w18EcX8al0NQDHGkjcONQdvvmW0gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUWPP7S4IDXp+DCcrI3PM6UMDzCOJ0JNKEHcDiO2cfS5rs5ui54r8XwjalqQy6Sza
	 14l/50qwvr6ZDVe8fQhsSfExXM508ftxn/+naa5wm5bFFQ6Hr2g1uUutd76yyythOZ
	 emDvmfpBA3s1G/AYsDACt2uxPLOV5J3uUt1/5HVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 56/87] nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations
Date: Tue, 25 Aug 2026 15:26:19 +0200
Message-ID: <20260825132544.033358385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,14 +428,15 @@ static int nvmet_tcp_map_data(struct nvm
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


