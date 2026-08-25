Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D350246EF87;
	Tue, 25 Aug 2026 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666322; cv=none; b=MXkrBh2RSDofQMUm9z2cHp7WJak13v14zE+DYCnN02q/EXkAAq6u2XZR8Jo20/M1iFmnM4BChkAr7OpNww+mZzNHFTd3Z9GBPRYJ9xkEqCwI2MZe4AyXgtRkjlCUxsqQ8hw9Bg8Z2ejhJ0ErSIAgMCD6SeabWPCCf0AdLLOD4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666322; c=relaxed/simple;
	bh=6rAUzahXjnOVqkpgDxRJXs+OEkupdpKGVPNI/7eHVvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIF20ju31W/OUlslHCZd4/KmxZcmvX6Px4Eh4O03yEk179X4/OyPFNzQcsJAx7139T4wEMQwPi9ZV0OoRouTTMJVCOssf5pcN9uEfoZoMB9U5nMhBxCp0/4+IAwWcj0mQG9vOE/X7DyBDB0iwU7UbTQ8hKZ+8tpES5mHWiA5HB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA5qxoeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA5qxoeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319611F000E9;
	Tue, 25 Aug 2026 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666316;
	bh=NgnMH4YVsm12fQ9WSIfp0wxD+NvG1jo8NzYGFhqE94s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA5qxoeL3W1FsaOe4tNgmUtr/pINDQ78eGch4mulRiEClkzzQXE5K8oRrO7dfvVSq
	 ns63v1d8/8ung4ACvhiQ08Gh72KnTqzQ3ffo7+2bTWanhnkSxAXVbOcUTbXmMzq2hh
	 2j+EOsYlKvAfFOfzJkAFhnJo2qQfZapRSsG8NTr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 45/76] nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations
Date: Tue, 25 Aug 2026 15:26:38 +0200
Message-ID: <20260825132543.334906336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
@@ -405,14 +405,15 @@ static int nvmet_tcp_map_data(struct nvm
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


