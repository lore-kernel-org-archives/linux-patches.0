Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433D22E06E4;
	Tue, 25 Aug 2026 14:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666447; cv=none; b=Zy/BmVS0dR7b5tRk8bp978jvd+YQq9A7PjiHE7s7BIWWmoiA98I83ep0Y2cGDBfZDBqOjTlEYWoVOuRUETGhDXSjCegwgc29fZfNQx9RyWn8sUJ4ugxKFknbzD9KsAQTPA3bXJgCGM2wnPGximQe3DzcQfGTXw6DSPPQHEWigx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666447; c=relaxed/simple;
	bh=N3jGijwyHSnJszNpm2eIcQ1oE36UqjVeiNKn4ZrJEbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCKWsxEInUhYAox75llbgv6cgloB4FyWayIDJACLmyDwcgqKfLHsySMqxy8RGp6n9nYf4F3W1pi+RFVUoPlFBDaqp26/rFmeRvV7qEox9Z7txOdIb/33JsgUyH1rPXsGuO0dKLo2WjdpMpajuknNzRtg/ayYBEnYdZ3Y3Wn5N+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YW/YIDxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YW/YIDxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660B41F000E9;
	Tue, 25 Aug 2026 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666441;
	bh=u6qw4ucP6KccLU/16FNFz8S5ujek0Yatfs3dhqyTJB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YW/YIDxGQEI5xpaGrT/20Fg1Bjfww6sWNA0E4hdhYm0fhQDNuHnvBYxOlsQNYlVmY
	 whL1fEoPfSWwhhrt9vPAeub4UrRb3YU3elQJLrg3YNZ31fO/g1HimXW6ILDZ6O8Vua
	 c7DZu/DcqO+C2T9NZ+DEjFEJZgVLAbCAb0MGKH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 43/57] nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations
Date: Tue, 25 Aug 2026 15:27:05 +0200
Message-ID: <20260825132543.017881872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,14 +393,15 @@ static int nvmet_tcp_map_data(struct nvm
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


