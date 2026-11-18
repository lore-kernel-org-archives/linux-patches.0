Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048048;
	b=tjB3L2Syl9lNFs0A2tcQNuSqkGs/CajORGPRCVWiLu5ImrjwuaKk3GQd6if5caHJRZoG
	 ff1Haha2lFQz4cpBn0V2vOm3ah/7kBi95KtNse6CXui/e2xQJCJnwQEP2o4qIim4twldE
	 G4aMIJaJo8vcP1jPehmPMyc6l9H2K7qZFukeUQnnkGUR8ZOYZwHALn+DrZiZ3F9LKL2Mg
	 9P0TqebD6LzDRzAp4NiAM76wWtJM6UdCEqaMMyqa2W2Li+07MtPoGtkFD3rX3epKXxI+u
	 bQBML0ZQarCp66H5X04PpXNDR+LRf+PNO/oO/IPbBnnqalkJi/NMVCAb8oKqJWWqftA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LB4bKOGs7OmZQLnDWJEWJvr9Aqs3IE141Yv5RjJJ5fo=;
	b=Isden3l/42GZV6EpdzZYVDIdzOs6hOVUqOFK7dGHXiQoKBrr5ZHPjVmo5ZUHlr+rD3zM
	 zi0H2v3VBDrz7rtHrASPNUeBEBTQjaFJMAOkFkbvn8Vpt/tEPn2L6R79gPGNG4f6y6SdI
	 kw+4G8QPp8vh6uyItFVHBAWdXWwBiN1pYZpGxt5ljPOH2KhQPK9IkfO+d3uJyL64bTzjb
	 FPPbhz1iz7gmdxn7VBRLKj9vGJsFA6v1x/JkCKdUyLuBE3NFx6e2opqxjn+d7B5bQdrur
	 Tk2qk18CbJqPqHohbd82TWhJnZZlrlHPZgobvuE4t2NshAWA9Kwr9rgD/eluBbO9Xug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIs0HsFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD853606A320;
	Thu, 19 Nov 2026 00:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIs0HsFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0D71F000C4;
	Thu, 19 Nov 2026 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048048;
	bh=LB4bKOGs7OmZQLnDWJEWJvr9Aqs3IE141Yv5RjJJ5fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIs0HsFEExF2hLhyZ02aNEiH6hawtnoEnBifKQFjDNpOpGO7O32vIhIyGjYv/f/cs
	 rhETUXbSZf8SV5eXqI0lKO5HRNOGniEznxJFaWm1NQZuM4LUS1xWBdPIsDkYAmh9Od
	 1jL+Jx8FVKK+lDUnNlyWK/Ya0eYYRBctIwQgG5oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1854/2857] scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118150307.996299827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 5dade59551d344d0308256edfef6bc3fb4202eb3 ]

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-9-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8b2ecc7383b13..6efedf26ade18 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2133,7 +2133,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2247,6 +2248,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	unsigned long flags;
 
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		if (drv_cmd) {
+			cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			drv_cmd->retry_count = 0;
+			clear_bit(cmd_idx, mrioc->devrem_bitmap);
+		}
+		return;
+	}
+
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
-- 
2.53.0



