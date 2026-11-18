Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036439;
	b=N01Yoj0AWfzCDMIHW0sBUNBf5/6E+Qbh94URZnoLZNo9wUCK2acTKL7f/P8AZl1dvA3t
	 +Dat8ScOGHQogGSotCbcGRJuAmemNsDIGEC4mk9wv8zlNI7j3Z8cdc593uvAjgJQ+L6Hf
	 PK7IBXxo0zKFznIfe5qTBQHPkaiuFKi5SyWoyHf3Z/K5sqs/fqC4SBAy9nUsxSo9JwhUE
	 G6u28WYzTgtnhEnZhBfhXSggvPU0HehM67D7/QRVJW36FJ9aJ9YpKSb5mIB1iSo0Qf0He
	 kjmPq4DwNQyGGGNCFZ719hW30X7VHIV9hbQoB25SO9jZQGu/E8o3FcwCjYJH64DH7dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kLgCQyWMYJIV+E9red2PBNn9ysph6T95AlmNoOvgn/g=;
	b=mtYuXWOFtiH3j8+4svis0bO0Ql+O/ViZPUhRUQAMtA1UhW70OmEVwztM1DOzF2Iwaqd6
	 hyiD/i6cXs/SLHSU0A/dphDJWplIJex4tMTRjDjOJhFH2x6vkVeYd6EFbjquvKdxBXQmn
	 vi6vSyEBjlTAjYD/qCqo1sUvbQ3R0auQhze7AhoOxxzc1oM1PgUqOPb2lvz0qEs/t4XaX
	 2oe5Q+ou0cSNB8rMVLGGY3Ew+PipqODphlSX5J9+CVIxhj6hu+XgiEzMsLegOYsCylZnS
	 kNRZm7VThR2c3XVAnvR2quHrOWgQ9OmKFCuq5SmE35qQyhnXFnqaxxKWc+ZBUtgqtBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iL28h2N8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74781606A31C;
	Wed, 18 Nov 2026 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iL28h2N8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C741F000C4;
	Wed, 18 Nov 2026 21:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036439;
	bh=kLgCQyWMYJIV+E9red2PBNn9ysph6T95AlmNoOvgn/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iL28h2N8aD0ohmsmj3T3xZamoYlECD+padim6MEBMBRv0J53Djy83egnFSssqnbNZ
	 zd/rZNUiRDem//Lf1lSUnZZkuwrcXHFb1Q6MOudzXocwElBxMsmf4nvfgOrgbuYIcw
	 NaJKCqkP5PBbf3Amue/uT9oj/M4Hrm3O7bFCCYbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1058/3318] xen-blkfront: Fix IO race during unplug
Date: Wed, 18 Nov 2026 15:28:00 +0100
Message-ID: <20261118150351.687994256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 61b6d1df1d6234c38a6ea7e4f58e7da035ef6ab4 ]

During unplug, blkfront stops the hw queues and marks the disk as dead,
then later during removal calls del_gendisk(). However, IO issued after
the hw queues are stopped but before the call to del_gendisk() will be
queued but never handled. This causes del_gendisk() to hang forever
waiting for the queue refcount to drop to zero.

This can be reproduced by issuing IO during an artificial delay after
stopping the hw queues.

Fix this by simply not stopping the hw queues directly. Marking the disk
as dead already freezes the queue which prevents new requests being
added and it synchronously runs the hw queues to clear anything pending.
If the hw queues are stopped when calling blk_mark_disk_dead(), running
the hw queues is a no-op and can leave queued requests unprocessed.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006163411.2583538-1-ross.lagerwall@citrix.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 59b5798390795..4a909f0f07828 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2131,10 +2131,8 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd)
 		blk_mark_disk_dead(info->gd);
-	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
-- 
2.53.0



