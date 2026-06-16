Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3813D810C;
	Tue, 16 Jun 2026 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634458; cv=none; b=ZyKsbzBKHklueYtb0uz0aGSZgGuoj+kXlECt9hD6mVkUb7rtUN5geYJPQ9vET52RwlLUUQ+acpEPnDUU8GTOR2ipbMCU0eYIruwCacsMmGU8aIt7jJMXFc1366daUshllSpZh0/RsZDcEBpQ+Wzc4p9pXFQ/pUfzvjhCl8QFKYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634458; c=relaxed/simple;
	bh=tBUx559aQ6c7TX7qnTFhWM8knFES8fSuC4Gft5ZjJIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB3q5NZH3tftyngSndep3UJ63Mgwx8Eembfm4YyU9B8awtne6dKB7ugG8RwzSSPEBhcMOvgj2qln2sExTnuXXmeP++dB43BZUMXBIk30Kl+gYz56+ciI8KytHwS351Tk53Sl6vm1f5/vax2xmzYdyBRH72gGkaqzKNDnMLm1L7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IktLh0Jj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IktLh0Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E88D1F000E9;
	Tue, 16 Jun 2026 18:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634457;
	bh=L8vlCADltDA0gK40WDfds5EJ9VwMyj0Sh+RVzotlUQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IktLh0JjM9KU+zSDBx4a82lk0IDMfa6qmkyjOyIfqQ7Rm4JbaycG7JJuKkIXIBvG4
	 G3UkWEf9POOxJPDk4qsRM0TI5oOeU0uSC+jXXjCbTBzBM2TYwmTHON8c3DRLGUIABH
	 7I/xmIH5WB9Zr/bqgugas9f1/R42Ah0PVz+cSgHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Yan <tom.ty89@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/411] nvme: fix interpretation of DMRSL
Date: Tue, 16 Jun 2026 20:28:27 +0530
Message-ID: <20260616145115.382422751@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Tom Yan <tom.ty89@gmail.com>

[ Upstream commit 1a86924e4f464757546d7f7bdc469be237918395 ]

DMRSLl is in the unit of logical blocks, while max_discard_sectors is
in the unit of "linux sector".

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 40f0496b617b ("nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    6 ++++--
 drivers/nvme/host/nvme.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1736,6 +1736,9 @@ static void nvme_config_discard(struct g
 	if (blk_queue_flag_test_and_set(QUEUE_FLAG_DISCARD, queue))
 		return;
 
+	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns, UINT_MAX))
+		ctrl->max_discard_sectors = nvme_lba_to_sect(ns, ctrl->dmrsl);
+
 	blk_queue_max_discard_sectors(queue, ctrl->max_discard_sectors);
 	blk_queue_max_discard_segments(queue, ctrl->max_discard_segments);
 
@@ -2948,8 +2951,7 @@ static int nvme_init_non_mdts_limits(str
 
 	if (id->dmrl)
 		ctrl->max_discard_segments = id->dmrl;
-	if (id->dmrsl)
-		ctrl->max_discard_sectors = le32_to_cpu(id->dmrsl);
+	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
 	if (id->wzsl)
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -299,6 +299,7 @@ struct nvme_ctrl {
 #endif
 	u16 crdt[3];
 	u16 oncs;
+	u32 dmrsl;
 	u16 oacs;
 	u16 nssa;
 	u16 nr_streams;


