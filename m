Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620338;
	b=t/p5v8ImgoZpQCWX1NTcalIbdRH5JS7Gq/KKo6z8HFUvXd3hZe/lpxurm1WUB9mkXsc3
	 aKPS1bO5o+x6RIndS8TI6C0UIlV/zpZFkSTlJtD1n9u78rGa0JC24toOTiWma7G6f61hi
	 FUc4tPQdNeVfM00aVXJfxq4c07Udvv14fK8qHYdaTkV711r+dDlwnbM5EzhaZQSn5x4jY
	 dNlCOKqFmlCwG8S3Zv6YZNTCXFdiViMN4+CKt+3Q4XmWhUFykA98/a3fDA0afQaTqw8k6
	 r8RDMTo64YT/SVDUU+8/Wabzi9xprGaCG2B5EzOHCQXkDtnkJCsG39143bhp2b6iyLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NAI/5zsYze+u4BVsroxa76xYRVHGT4Cr+dEi9n6g4nI=;
	b=y2LIcbSR9x2/QFFQ/PEdwgFgEs3pcUWzKotbqRh0b830N8cBXPtpRqnK2RNPy6i/G+ID
	 20Q9xh33b+GI5n1Hyg3oDUFBq5mNA3MJwwm1FuMoaS220zd3fHSt3KWgqajvxazkpwfF3
	 7i8qz0YdBUlkiYBQL/TQKU/agYljX9Rpj4unhQY49xQjHVYRdBA6KlRgwVt4TJNUXMyXz
	 v5XzPI+TF7kHSJewaqvLlQM/YwpzD5G/aBxMvt1P5vEucBMliYldxVO9PAppotUTjsDXL
	 c+OU7PxBDOMp9p3Y/oqREhBBdd3kZ/WM80FVNNEJy0CoC+LOjNEgIbxguj54zYOEY0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyIyFEOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147DE606A321;
	Wed, 25 Nov 2026 15:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyIyFEOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391E71F000D1;
	Wed, 25 Nov 2026 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620337;
	bh=NAI/5zsYze+u4BVsroxa76xYRVHGT4Cr+dEi9n6g4nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyIyFEOwtMfW70TVDhJhp3W9dAzKqKSJKpuxQUY/7dd9O8ffmkbwZ327BMj9EoqBX
	 NROCDm44/pBIfvL+RDG1/Mt9TFsW5TdbMJ7kPfR9EzCkFJmkSse2HT35MtzgrGdAeO
	 nRvX1yrzBAponvko14EZw1a0i6w8Urz47WuHbUyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0882/1005] dm-raid: fix use-after-free in raid_dtr()
Date: Wed, 25 Nov 2026 15:37:00 +0100
Message-ID: <20261125143842.363850897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Youhong <liyouhong@kylinos.cn>

commit 46af2c975958119290ddcd984a98491966123a7b upstream.

raid_dtr() currently flushes event_work only if work_pending() is true.
This is insufficient because once a worker has dequeued the work, the
PENDING bit is cleared while do_table_event() is still running. In that
window raid_set_free() can free the raid_set, leading to a
use-after-free when do_table_event() accesses rs->ti->table.

Flush event_work whenever it has been initialized, so raid_set is not
freed while the event handler is still running. The .func guard skips the
flush for mddev instances where INIT_WORK has not run yet.

Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig_mutex is released")
Cc: stable@vger.kernel.org
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3334,7 +3334,7 @@ static void raid_dtr(struct dm_target *t
 	rs->md.dm_gendisk = NULL;
 	mddev_unlock(&rs->md);
 
-	if (work_pending(&rs->md.event_work))
+	if (rs->md.event_work.func)
 		flush_work(&rs->md.event_work);
 	raid_set_free(rs);
 }


