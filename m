Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C804E3769F5;
	Thu, 30 Jul 2026 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424855; cv=none; b=rva25knu0VI2+i3VqbRKTAsNlbiAe7b/xuRCEGQjA1nRC6hvarebDt79mFw5wzVvnSZPuQudOFXoQsBqHZNsajFcVxbLq9ko94GDitDeRyupEru5b/OTYJUlupXp6il1DZSKjSENJFHVsV1vdaRt0Xw3B+XzNw6yqhh09LVGiic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424855; c=relaxed/simple;
	bh=yosHHMr2Av/Ehdkbqkg2Z8uGIrpxRub7i7Xr4TUJZBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOxPUifaYbY0gEpVjNXQH2Bs/Jvpu2umiIxH9hPGZOlbG0TOrGeDoJGhXyzqYbcG+CuESafjnfi923SHG7xipHYQL39WQhQeLjmV8xStxMcUpL12f6N6tFcr9kWc7KbsTCLPJg2ZvcZk4vWq36PKyyFboJXCDHxrA5Dok5Os1FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjgnujHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjgnujHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D691F000E9;
	Thu, 30 Jul 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424854;
	bh=SR98Bwn3rhzs9WMcRpJoKOS8RqkuKLfpyOY3gLn41bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjgnujHbP4XIj5KUtsgqWJ2u+CiiM36B/ZGR4s9oW6HdisYhtDFQu14KqPm4FXvZa
	 KsnHWSb4MNMefb0ZwhXBC+nwv9fB6okpiv/5MIZ2ZcpyxCO+X0POppyT1xwviHXMhR
	 E88uTwBUAptZZ27mtcGn1oLBjqHNLFbUndDjJpdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manjunath Patil <manjunath.b.patil@oracle.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 539/675] net/mlx5e: Use sender devcom for MPV master-up
Date: Thu, 30 Jul 2026 16:14:29 +0200
Message-ID: <20260730141456.600319734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -211,11 +211,11 @@ static void mlx5e_disable_async_events(s
 
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


