Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9E33A6EB;
	Fri,  9 Oct 2026 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556524; cv=none; b=NJj4ja2QJMi10ABC8NNIpwbJj/FcwjE2X0b7qJ14xcKxs8IZEKYDYtcb5qs86FjRAuPK717TejIfJ1bYacJaEDk48dzx73fD85O9v35fRiY+ffrRt3qxGke2rKua+JdbUKFBYnLxqj+9G4w+j+I8/xUJmkLx/7ovTw7qjohqll4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556524; c=relaxed/simple;
	bh=52eP73Ns4zHShTzwP2Suw0fGYEM2RSC1eK3dtsnNDZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DEdpg0vi0UP6gbnbnq0+NNe1K8xcpTix5H0Ql+nfYFVXWZV3BYH7p0PR0ED3W/E10tC+d3YDi4gWywxVbGxJU8Zg+svB/C1v3+Ft+zhFNiEu4YP0Mh3EHgDB004Ijk5Ie6p2dGMxqmzCUkUHupv6QAYy6vAHz1gBNigZBsEJJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSCqt44W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSCqt44W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3F61F00899;
	Fri,  9 Oct 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556522;
	bh=hnoNwVrmVoDErOo06U3wCyMY7cKYgU0GBunzWgLF6yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSCqt44W8wXuoqKjC6gxcgD+wJ+JM/7vMxchFLbj8y/K6dkwWK3wMrfD0UMB6Xlzi
	 h/j96sq9XqoZhTblEmUusk/qpWbs/Pkvu21mmSgPlcwN5EbCtZhK60vQ/+rzIrz6K2
	 dY2nG60rqEtpLqLM8Rnt+gq9lncTqyHLtHaRAJ6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com,
	=?UTF-8?q?J=C3=B6rn=20Engel?= <joern@barelysecure.org>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 249/403] mtd: block2mtd: Fix divide error when erase_size is zero
Date: Fri,  9 Oct 2026 16:10:10 +0200
Message-ID: <20261009140957.993010684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit b5965c4221165045e19736794ca5f48ae3d67142 upstream.

The erase size is parsed from the "block2mtd" module parameter and can
be set to zero. add_device() then evaluates

        if (size % erase_size)

with a zero divisor, which triggers a divide error:

divide error: 0000 [#1] PREEMPT SMP PTI
RIP: 0010:add_device drivers/mtd/devices/block2mtd.c:296 [inline]
RIP: 0010:block2mtd_setup2+0x592/0xda0 drivers/mtd/devices/block2mtd.c:459
Call Trace:
block2mtd_setup+0x27/0xe0 drivers/mtd/devices/block2mtd.c:476
param_attr_store+0x214/0x310 kernel/params.c:589
module_attr_store+0x65/0x90 kernel/params.c:904
kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
...

Reject a zero erase size before performing the modulo operation so the
existing "erasesize must be a divisor of device size" error path
reports the invalid argument and frees the device.

Fixes: ea6d833a3fdd ("mtd: block2mtd: check device size")
Reported-by: syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a7b58ba.ac361c09.22ff0a.0045.GAE@google.com/
Suggested-by: Jörn Engel <joern@barelysecure.org>
Cc: stable@vger.kernel.org
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/block2mtd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -293,7 +293,7 @@ static struct block2mtd_dev *add_device(
 	}
 
 	size = bdev_nr_bytes(bdev);
-	if ((long)size % erase_size) {
+	if (!erase_size || (long)size % erase_size) {
 		pr_err("erasesize must be a divisor of device size\n");
 		goto err_free_block2mtd;
 	}


