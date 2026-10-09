Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F13382DA;
	Fri,  9 Oct 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557140; cv=none; b=t9MzgRhG2BdhE07hMTA0pvlgMCeDrIIo50PtHGmIKBiUVw9R2hKPa0Aw2xl2bZ69JKmjJwu5Ez3MasrITZyKAoFo3ZH2dkwy9Xi11W96iUH+Yom3XAyCHMIfcaSdaainCYxUwaQnFRD6n6ThNJcrfT34zfEoRO12lAU3DxJS/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557140; c=relaxed/simple;
	bh=93XzHaYnozGB2dzB8AKCLAKM9Xjxs2CUwuTPNOb7zOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKFKzAcZ3l7d/bEWMZLgFdHuJSWC9rE3fZGY5GzOY7qcdc4dV+t8ZwoM8UrUVzxecWlHQFHhxoHda/RZDwMvXfEMCT4dyLRft27YC/wzVAl94ZP1VIOLEpHPD14y4bfVkDxCpsYxhMf/W7OjyM9wHIGUJvl+Vbg7hZamB2OTAN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myEwmhQv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myEwmhQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C41F000FF;
	Fri,  9 Oct 2026 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557138;
	bh=CllqN9hd7JhWcBfQuhGSurJQA+tp2mblAL1PqOAEIOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myEwmhQvpIgkTJkhxNrhBhDgxcsat/ftVXpAOiG1j34fgurTTO7ahC+F4xGfPRAaw
	 9mrptQywfj2TW+4EQ22MiUkcNrZ7KVjcEvtdsBxY7q7Czu/5zUw+LW+P/Duk2j6wZJ
	 e+RnvTIfeWb9s5PX3v4UFbBjRIQFySGuy0/dqhI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b320a4d5f65a61dbbf89@syzkaller.appspotmail.com,
	=?UTF-8?q?J=C3=B6rn=20Engel?= <joern@barelysecure.org>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 302/428] mtd: block2mtd: Fix divide error when erase_size is zero
Date: Fri,  9 Oct 2026 16:10:39 +0200
Message-ID: <20261009140952.750252694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


