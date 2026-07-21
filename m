Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEBB404BF6;
	Tue, 21 Jul 2026 22:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673576; cv=none; b=dXL2EHhCYZ4n+3f60Q9PUicLH2fImzf5wAATugiaaRWbS61KHhNjgKfmcxZtDAGXvxYoBzwxbvIF/SV7Y2ztYf7YKNg6NkzD/UsJ/i+xGIB/jON3V3/kqHv3Bp/nePhM7cVz2SxNoyglOSqJ61CiJpwJCk4ppQXBf2F6LOqfIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673576; c=relaxed/simple;
	bh=9FiJlU1kARgJgjb15Xzu+5LKdroxIYj/pUUKVw213Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxokCHc6xuSJ57Jm2DmB8U4dhn7W6iHW9NggBJ2XoVNzOJdUSbvme6V+o119wi5HCjP8E1J4vYvOawr4ns2HE+yNO/BP9oQovqZrXSo+03jRzf2w+qXgX6nnaTYvskCAtc+fgeHijeA1NLt9LHsddeO8QV2+cJSABbXSvW30pFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hND+732O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hND+732O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96C01F000E9;
	Tue, 21 Jul 2026 22:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673575;
	bh=iN9dZzgDZ3hZr9iCDiZWGLPKg1nTFa5r5hvg9QATV/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hND+732ORpWxuaVFCTA7pwkV+pBrzW9wmXSx58D3VCTucZ5MJa/xERmdwUMVkebOt
	 Lb7es+G2qG0ukEnycjvP9vTdhKheu2+j9mQO0IpuEvwHSnC7hCfNJ+7siyXCVHFGKm
	 WVaN2WetAE76SD24hPKahp9XlcslLrer5wSnbWOI=
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
Subject: [PATCH 5.10 212/699] rapidio/tsi721: prevent a bad dereference in tsi721_db_dpc()
Date: Tue, 21 Jul 2026 17:19:31 +0200
Message-ID: <20260721152400.481477264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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



