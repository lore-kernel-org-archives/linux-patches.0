Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339BD35DA67;
	Thu, 30 Jul 2026 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426426; cv=none; b=lx2hNJ3ZzgGAVupPLF6KD5pgy8XExdKcHbHWDaF1Uyw/+ys4T5dpfEc5eoDYF67b+4LyZCOC02mozu1wSwGzngSgtWdWFT+t7rqkvbScFEtlpmK3Oko+Nlw3E3UZs4+NjsZTh6+OBn3YA2ij2b7yMUqiISOSABtWXM2U6SZePhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426426; c=relaxed/simple;
	bh=GT+/xZrMpmcbQuikzkXH9opTbZ8Y57y4jYXaZV0aRSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT4PuBM9H7ln7zwD1auHxIRM0Q0uUNC/nt+0NVvEniEeQC+EyWoj5Lgmoq7Bz5cL6M4tpIi/6NmKKtf0q1bxpwdjwC/jniMAWUCr9/TWGeTz0rLU3o2CnP1vgKoJZ4uculxN9M0N6A/7R25v8YOPmhAf1VFH2e6EWvfRZMigfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sczMUHar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sczMUHar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2921F000E9;
	Thu, 30 Jul 2026 15:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426425;
	bh=LC0EOq6Gs6P5mom6n0G7QQI11rePAWdr/hgLuPAlI8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sczMUHaraV1Awc7/GkRDgB9ZzX3aTw9G7nnE7rc79JaitNQOmY26eD6A90diEldOX
	 pAH5nIVr1crcPzgBXj/+52gSF95E/vZGCZ/6ZY7HCa/pu7NsNYFHQIiifYbXIEsSwL
	 VEA8Nydx4SzK2qXxYR1TRgHYkbCIG2IsPepd1WS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunath Patil <manjunath.b.patil@oracle.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 413/602] net/mlx5e: Use sender devcom for MPV master-up
Date: Thu, 30 Jul 2026 16:13:25 +0200
Message-ID: <20260730141444.643336073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Manjunath Patil <manjunath.b.patil@oracle.com>

commit e32649b4bad90a6216d8e93cd7dd050af8ac9740 upstream.

After PCIe DPC recovery, mlx5 reloads the affected functions and
replays multiport affiliation events. In the reported failure, the
first relevant device error was:

  pcieport 0000:10:01.1: DPC: containment event
  pcieport 0000:10:01.1: PCIe Bus Error: severity=Uncorrected (Fatal)
  pcieport 0000:10:01.1:    [ 5] SDES                   (First)

mlx5 recovered the PCI functions and resumed 0000:11:00.1. During
that resume, RDMA multiport binding replayed
MLX5_DRIVER_EVENT_AFFILIATION_DONE and mlx5e sent
MPV_DEVCOM_MASTER_UP. The host then panicked with:

  BUG: kernel NULL pointer dereference, address: 0000000000000010
  RIP: mlx5_devcom_comp_set_ready+0x5/0x40 [mlx5_core]
  RDI: 0000000000000000

Call trace included:

  mlx5_devcom_comp_set_ready
  mlx5e_devcom_event_mpv
  mlx5_devcom_send_event
  mlx5_ib_bind_slave_port
  mlx5r_mp_probe
  mlx5_pci_resume

MPV devcom registration publishes mlx5e private data to the component
peer list before mlx5e_devcom_init_mpv() stores the returned component
device in priv->devcom. A concurrent master-up event can therefore
reach a peer whose private data is visible but whose priv->devcom
backpointer is still NULL.

MPV_DEVCOM_MASTER_UP already carries the sender/master mlx5e private
data as event_data. The ready bit is stored on the shared devcom
component, not on an individual peer. Use the sender devcom when
marking the MPV component ready.

This preserves the readiness transition while avoiding a NULL
dereference of the peer devcom pointer during affiliation replay after
PCI error recovery.

Fixes: bf11485f8419 ("net/mlx5: Register mlx5e priv to devcom in MPV mode")
Assisted-by: Codex:gpt-5
Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: stable@vger.kernel.org # 6.7+
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260707233911.3651139-1-manjunath.b.patil@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -206,11 +206,11 @@ static void mlx5e_disable_async_events(s
 
 static int mlx5e_devcom_event_mpv(int event, void *my_data, void *event_data)
 {
-	struct mlx5e_priv *slave_priv = my_data;
+	struct mlx5e_priv *master_priv = event_data;
 
 	switch (event) {
 	case MPV_DEVCOM_MASTER_UP:
-		mlx5_devcom_comp_set_ready(slave_priv->devcom, true);
+		mlx5_devcom_comp_set_ready(master_priv->devcom, true);
 		break;
 	case MPV_DEVCOM_MASTER_DOWN:
 		/* no need for comp set ready false since we unregister after


