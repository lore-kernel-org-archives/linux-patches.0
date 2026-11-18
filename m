Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040408;
	b=zowM+MGpFDG5QzsAcS1w6I9RKvYq94YslQbmsoxDby7cSX4eezSzltQU8W9f/PpEKVDM
	 NauGi3elye5yEcrM8mVlIFWD5wbmOchhTUqBmjKOxD6nRpcKPW5dFkiuBSrmI69wIDSOs
	 jDLZfvt/HTWaWWq+OsN7XL5/ACr2pdf9b11QOyARhGuJMs10FMdKozjlnE3YCfoBmf3PH
	 riM5Q9bMSShPInizRrw5vDD8DiKsegiy68fLdEDqOFZeajnmJuyO/efCtYRzACj/R9Beq
	 V6Rz414H4ckEToAGxLzPezJgyfkudGiBXWXDrgx93JLcYaCgpDJstBZCitgACu2br2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4G48UU1JTTao1XYNbYRb9ZoZ3umVtZlMJYQhfmoGa04=;
	b=OdfEpdM7WRHYrpocWWqyTeId3SrmI5CEyRN1yKXRh69fyayfVNs2arNuRf5UqaM5YiEk
	 XmdLFUL6vgemxSUAgCR5IT2RArAkkona+gq4uV+OqEpzKgMsGNr4RNWdFmZXBkxzrnycf
	 XiISEVkrE8b7ruAGnjjKQplYkAR0Kix8v2Si7vIcvZ7zBiD/ncCKgP4ZYQtwnZxOcznMl
	 wDk+aqdwbjM5tzfxdmWTiTTOf8Yb/Sfpukx3dJ9l2ojGqfFHdi/5cV6RWF8Ia+lEyHxuI
	 yHnjAxTGTxrKi6sBFLKZAndvN213TZgnLopLP0fkFaQvoD0RL6YjiqC7Wsnido6VOFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yv7YFI3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87599606A332;
	Wed, 18 Nov 2026 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yv7YFI3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5021F000C5;
	Wed, 18 Nov 2026 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040408;
	bh=4G48UU1JTTao1XYNbYRb9ZoZ3umVtZlMJYQhfmoGa04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yv7YFI3PlcLRHl6sE69feb+hOeq1AFtWhGBA40i86wkMIUbZO7alyMuKwUp6N3t9l
	 wzKBXTav5CbFh1QW0RgqLlGtJ73RaHyoCqKDbWuvusvRe4HIa0/ieIBq3PTaBURC9T
	 kbKxtZqiEPLqAopwwi3tmmzRsFbeUSVzK5R+z/uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2444/3318] swim: Fix FDEJECT ioctl for exclusive open
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150434.766522379@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit c76b93df9ae61d8ddebf6aa3bc218252f85e80c6 ]

The eject command from the util-linux package does not work with the swim
driver: the drive doesn't eject anything and the command fails.
Apparently, ioctl(fd, FDEJECT) returns -EBUSY when fd is opened O_EXCL.
Fix this by checking ref_count for either 1 or -1. Either value means that
the caller is the sole user of the disk.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://patch.msgid.link/ae3ee8e86833a2739d7857460cbe2addf4146088.1790641175.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index de6bf7beb4625..aab171e708a0d 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -695,10 +695,11 @@ static int floppy_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	switch (cmd) {
 	case FDEJECT:
-		if (fs->ref_count != 1)
-			return -EBUSY;
 		mutex_lock(&swim_mutex);
-		err = floppy_eject(fs);
+		if (fs->ref_count == -1 || fs->ref_count == 1)
+			err = floppy_eject(fs);
+		else
+			err = -EBUSY;
 		mutex_unlock(&swim_mutex);
 		return err;
 
-- 
2.53.0



