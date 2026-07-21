Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5BF3BD63B;
	Tue, 21 Jul 2026 22:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671510; cv=none; b=DwI+CrvPHnxyosa8D/Yt2y7Qly+aSss5SswLoJzsQwONUtRPh33ptxjt5LFTWO4jkkSRJE4Nj8FjpfQfQgNH7VA04KuCnDGkYc9Mw0mXSqYOjMKJEmeentHskP6D2TdJXEQKRBGDgiaNGh35qR4OG7dX+enFG5+gRYX6GOB9dpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671510; c=relaxed/simple;
	bh=pb0qsCpG4SYh1UoRyGtx8AhcdnFZ6r0vco+reMMZYuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmgoBFPD9jVVEPhIehlbXoBKzxO6b+nXZPP3Am6zDlhxlor5bjvSWLSnmUguyYRH4Jo2d+sUx6XBm6lPuJoaLera6sydJYBr3+2M7BbeAL0xRXfwWx82U/Degaw83hY3hpddcITJooxyenzN1I4UQa3jhNv4sTDYCJ5tXcF+7rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+aUb25A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+aUb25A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88161F000E9;
	Tue, 21 Jul 2026 22:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671509;
	bh=keFpluCcyXJVpaUenN5Fez6cKtOYflPsXQoQQftjqx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+aUb25AtIgb3W2Mu8lp5jQcBPIyEugmREOkppL19+qPWLbpFB78DaWfxX319KLi7
	 i6nOrp7Yt7rvyjVvvrQfq/BGAh6UmViarvMMm/LTF6Zpe/mQfm3MMHCTuwJmPzZa44
	 ZsLGNado7nXMctJlZPx/Wqp1N/PLhuIB9Nh4IZ/I=
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
Subject: [PATCH 5.15 274/843] rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
Date: Tue, 21 Jul 2026 17:18:29 +0200
Message-ID: <20260721152412.189559419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
index 4dd31dd9feeabb..c9a1388549389b 100644
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



