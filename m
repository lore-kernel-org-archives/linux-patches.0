Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93B312B9D;
	Sat,  3 Feb 2024 04:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933695; cv=none; b=VraqeqxD59b9gNrGcG2Q3X4+M2j9mg7BeXlt4wmgGfrUYTrJewgaOBtlVpeOsHzZEboq1gen8eOi0SmQXurRTw52SE/Rh0CC36d20Q8X9QiU3czRLrJSULns6w4dn5DZPrbx7tuHdI8uYYaVN+haCUadsRJ7QgvDOKOsFpJGFzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933695; c=relaxed/simple;
	bh=A8xerx4mxNn8UmgvbDy2r5L3aIS3yKeKAyG8nNRhScg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjBnB1vFkOuIlW+SOpfPUqSv/RMoZ4L/1pOhoL+a7a6nArWVOUTymAZUMY1txR6l3HKAfCcWChlmXC2XZO6TljDXj2P89+XqlRlutNiOb6nnw0dQ+77rrREKVD1hPjrvv47gDug/KqN9SJlgZm5Plq0Fd4bl5pYauq5WS3wlDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqW6SlGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqW6SlGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21BAC433C7;
	Sat,  3 Feb 2024 04:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933694;
	bh=A8xerx4mxNn8UmgvbDy2r5L3aIS3yKeKAyG8nNRhScg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqW6SlGw3Fxl6w4CnmjWwJIyQEj/4Li+cnV+/HGauS26/C1JDH1BvuUtkM90DOM90
	 EOiII66lRVg206678GC7o22zRhI2oHW2mVkTgmzCrukw/gt55viuCW1du0fc3r1K/v
	 Ebs8eqsul3dAuKrIsWQUbwm1wxVU1HwrE63r5FRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/322] HID: hidraw: fix a problem of memory leak in hidraw_release()
Date: Fri,  2 Feb 2024 20:06:05 -0800
Message-ID: <20240203035407.777465735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit a3bdcdd022c68942a774e8e63424cc11c85aab78 ]

'struct hidraw_list' is a circular queue whose head can be smaller than
tail. Using 'list->tail != list->head' to release all memory that should
be released.

Fixes: a5623a203cff ("HID: hidraw: fix memory leak in hidraw_release()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hidraw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 13c8dd8cd350..2bc762d31ac7 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -357,8 +357,11 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	down_write(&minors_rwsem);
 
 	spin_lock_irqsave(&hidraw_table[minor]->list_lock, flags);
-	for (int i = list->tail; i < list->head; i++)
-		kfree(list->buffer[i].value);
+	while (list->tail != list->head) {
+		kfree(list->buffer[list->tail].value);
+		list->buffer[list->tail].value = NULL;
+		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
+	}
 	list_del(&list->node);
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	kfree(list);
-- 
2.43.0



