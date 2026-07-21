Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F293B3C15;
	Tue, 21 Jul 2026 20:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665845; cv=none; b=IUIBBFzvRanyZPdezEFOhrwF39vvAny3sSnoaffoq8kI9jDr6f/B1qhvzT4T3DxoQN0muLDUe1PTC8dkr8cpQ/GnYGIbTWqqxIxuL0eVzUgCqI9ynlRbvyGGUAlpfiMg48r7SYgLESUeC91OcSKfkK9YmW6vi+25jIB2BCX1y48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665845; c=relaxed/simple;
	bh=8YF9qCnuKWqf3bQ4GIHlOWbqzKl2zWSVhiUE23P+62Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3l8Yj7NoDrpdLTrUyc+wzGYx8HWePGBXLNXk0h1w7H/QscL6GruFL0Cdsg6QgsARUjGrzoAw7VXYEwKwr2x78OpC/DfvnllcOTbGKvFiLqxNGKfgEnv0aJuDrANdBk8Y7Z5iuzP2NEUW2Lh8UqvmvPZL8pDMHdkGFTymndp3d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GryDkoQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GryDkoQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94341F000E9;
	Tue, 21 Jul 2026 20:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665843;
	bh=caoyYY1ObOWDbmSgJmH4fR+7yGU1sWMcpBccJWmb/XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GryDkoQXTb+o9kYMmDskH5uWHctTWtMBGWmwNee4OLL+0oE2x+I+hxW1o9rNR/3a2
	 mJR6GDPyyTftaIBbZ2VTqYBuF0qopu4Qw++xracag7sR4h2LHQm/+pnCOAp2nSs+nI
	 edkQ5KBuiM6XFKg+tEUOB0h5z8SgfEM/c3FYH+l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Chul Kim <chul.kim@idt.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0455/1266] rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
Date: Tue, 21 Jul 2026 17:14:52 +0200
Message-ID: <20260721152452.017329307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit fc15e3a30ddd950f009c76765331783b9af94a87 ]

With a list_for_each() loop, if we don't find the item we are looking for
in the list, then the loop exits with the iterator, which is "dbell" in
this loop, pointing to invalid memory.

This code uses the "found" variable to determine if we have found the
doorbell we are looking for or not.  However, the problem that the "found"
variable needs to be set to false at the start of each iteration,
otherwise after the first correct doorbell, then everything is marked as
found.

Reset the "found" to false at the start of the iteration and move the
variable inside the loop.

Link: https://lore.kernel.org/af2WHMZiqMwdYveO@stanley.mountain
Fixes: 48618fb4e522 ("RapidIO: add mport driver for Tsi721 bridge")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Chul Kim <chul.kim@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/tsi721.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 83323c3d10aff7..61ac7c8a1c7f65 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -384,7 +384,6 @@ static void tsi721_db_dpc(struct work_struct *work)
 						    idb_work);
 	struct rio_mport *mport;
 	struct rio_dbell *dbell;
-	int found = 0;
 	u32 wr_ptr, rd_ptr;
 	u64 *idb_entry;
 	u32 regval;
@@ -402,6 +401,8 @@ static void tsi721_db_dpc(struct work_struct *work)
 	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE)) % IDB_QSIZE;
 
 	while (wr_ptr != rd_ptr) {
+		int found = 0;
+
 		idb_entry = (u64 *)(priv->idb_base +
 					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
 		rd_ptr++;
-- 
2.53.0



