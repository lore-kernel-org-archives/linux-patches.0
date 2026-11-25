Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624784;
	b=mcDDSReZlnYtdQkUCLYUcXXbQZSj+OH8WX2PIRQ64Pkbm5VkGuQUd1oE51NEcjght0u2
	 0bBEf2u0AzeU1Cn9YF0vW1hVNprwrip1k/6FZqkr/XmWFCVvzxp32AfFrQfsf8zHHLkOD
	 cV5/L+hP+mi8WFQAxRkKxfvtUfavYty8+dgXb3KngMOBfgi9FrnTXYKNiT21xaOKwQjmZ
	 G/oF5gtOF0313K3+q0sRMwaYLPaZjAshRAnQYVBpGIX9SbfBWssQgKjSgn5tg2NnRSCjM
	 y/7jdoEScWLyY9HT24s67WKxNMNwAmurznoTZb46xIm1Dr5U6ABv1P+Nc1oP43UEwOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/r7adlo8pvxVX7Jjg9uQ5UnWT7JhXoYWblNfsB92jk=;
	b=PIKUBdnuJrPQnaAG3oZRNdScLeVJ3NAW6lNHZFrAdCoYRMo77AF5h6zTZe1coxeb7D2L
	 mkQLSuvJkYtKyLoOryYW0ZsY1ILqaSVvubJr8WHwnvIMIZr6vXtsAQySOXenHgmVX6mub
	 ZUuuJvpaGZUXsJFEm2CFoJ2mBIGzWYZgDav9QEx6DGhfVpR2VLG2hg7JeN9CMfC5/vlRy
	 U3p4zJDTOn52kBw0MbnHa79+DQFO+W2x6P5s7MrdaMhB/4REvNiIaJzgymRyImmG7F64C
	 cpGt6PZNeEb+++NA6SRs4KIZEneLZ6hexZ452SrXjekiLiBwMR7ojRLn0+Eo1+nc9Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfM8rkSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C88C606A33C;
	Wed, 25 Nov 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfM8rkSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321411F000CA;
	Wed, 25 Nov 2026 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624783;
	bh=6/r7adlo8pvxVX7Jjg9uQ5UnWT7JhXoYWblNfsB92jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfM8rkSe+zh4DeAhhJSeTvpswdH4arlAWJ2RZx/5RvkROMFK6/HWA0V9EN7hMXTed
	 D3SWlYT/ik0TSw6mN9TCVJ0Jv2CwTylHyLBH0HKq+8fwpkLXHKibMwwDuLGAkfBz6u
	 Q4Mujxt3kceez5MltD+/LFS65V3aTYJycUI1YrEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Korenberg <socketpair@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/816] ublk: publish a new device by its id only once it is set up
Date: Wed, 25 Nov 2026 15:30:53 +0100
Message-ID: <20261125143856.262286726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Korenberg <socketpair@gmail.com>

[ Upstream commit e5c463e5074a940c644d54d8fc29aba06709aab0 ]

ADD_DEV stores the device in ublk_index_idr when it allocates the id,
and control commands find it there as soon as ublk_add_chdev() has
initialized its struct device, before the char device is added. If
dev_set_name() or cdev_device_add() then fails, ublk_add_chdev() drops
the initial reference to free the device. A DEL_DEV that found the
device meanwhile waits for ublk_ctl_mutex, then calls ublk_remove():
cdev_device_del() of a device that was never added, and a second put of
the initial reference, which frees the device under the callers still
holding references.

Reserve the id with a NULL entry, which idr_find() and the idr iterators
skip, and store the device once ublk_add_chdev() succeeded.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261105-ublk-del-gendisk-hang-v1-1-913a91a4314d@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f89b36017d979..ae954ee1e3529 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2221,14 +2221,18 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	int i = idx;
 	int err;
 
+	/*
+	 * Only reserve the id: the device is published by
+	 * ublk_publish_dev_number() once it is fully set up.
+	 */
 	spin_lock(&ublk_idr_lock);
 	/* allocate id, if @id >= 0, we're requesting that specific id */
 	if (i >= 0) {
-		err = idr_alloc(&ublk_index_idr, ub, i, i + 1, GFP_NOWAIT);
+		err = idr_alloc(&ublk_index_idr, NULL, i, i + 1, GFP_NOWAIT);
 		if (err == -ENOSPC)
 			err = -EEXIST;
 	} else {
-		err = idr_alloc(&ublk_index_idr, ub, 0, UBLK_MAX_UBLKS,
+		err = idr_alloc(&ublk_index_idr, NULL, 0, UBLK_MAX_UBLKS,
 				GFP_NOWAIT);
 	}
 	spin_unlock(&ublk_idr_lock);
@@ -2239,6 +2243,19 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	return err;
 }
 
+/*
+ * Make the device visible to control commands by its id. Before its char
+ * device is added, DEL_DEV could find it and remove a char device that was
+ * never added, and drop the reference that ublk_add_chdev() drops on
+ * failure.
+ */
+static void ublk_publish_dev_number(struct ublk_device *ub)
+{
+	spin_lock(&ublk_idr_lock);
+	WARN_ON_ONCE(idr_replace(&ublk_index_idr, ub, ub->ub_number) != NULL);
+	spin_unlock(&ublk_idr_lock);
+}
+
 static void ublk_free_dev_number(struct ublk_device *ub)
 {
 	spin_lock(&ublk_idr_lock);
@@ -2658,6 +2675,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	 * ublk_add_chdev() will cleanup everything if it fails.
 	 */
 	ret = ublk_add_chdev(ub);
+	if (!ret)
+		ublk_publish_dev_number(ub);
 	goto out_unlock;
 
 out_free_tag_set:
-- 
2.53.0



