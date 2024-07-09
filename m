Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427C158A1F;
	Tue,  9 Jul 2024 11:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524122; cv=none; b=nduuNiaZWYjbpksb2PA8k3sSCROwh7Fwhw7RPaoWfjPBpo5MgJ9qTHTH3O3XQS6Uj23Bp2TAiHQGHwlHyRaNvdkEmqSsQXjPKLUJtza+vfc6l76Wh/bJUKLCQwFWh2jjZb0pXNJG4I959zMCc0HZ5ZhuWuQmGgNExkfk/QunxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524122; c=relaxed/simple;
	bh=u4U8zQ4DX8W/i7HR7bVx4ZCmoPvPT1EJJOtUO7JR5lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHsJJ2ZiU3Dwwk6x79cMLCUxQR2TCQgU3gzYI0rrsyc214332JkhgAUEL/tabA4zNHoQpCukZArVRpvCeoIDpLnX4nP+SG2n0PLbgk77mmYPZkuKLJt9WeCyh+K2XNjKBJNOt1SkKgg+ycfcQiPgsJ4P3ZAYxCoJF6TP+onqj0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BveV8H7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BveV8H7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A0CC3277B;
	Tue,  9 Jul 2024 11:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524122;
	bh=u4U8zQ4DX8W/i7HR7bVx4ZCmoPvPT1EJJOtUO7JR5lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BveV8H7tnz3D9d+gjOdl0TtqOWnYpR2PJFQE7KChBi8oExW9g76UN8ynDm9/suYP3
	 KukXdlhgQwy6PD1E/hW41nA4totP7XBjL1v5NEv2iQGsVKLKC9GT/xBaPwX9Gqi/Ak
	 BLQV9833/WycXc1i9wgi+3UyBcZk1WIzpIR69sgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Justin Stitt <justinstitt@google.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 078/197] cdrom: rearrange last_media_change check to avoid unintentional overflow
Date: Tue,  9 Jul 2024 13:08:52 +0200
Message-ID: <20240709110711.987507268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit efb905aeb44b0e99c0e6b07865b1885ae0471ebf ]

When running syzkaller with the newly reintroduced signed integer wrap
sanitizer we encounter this splat:

[  366.015950] UBSAN: signed-integer-overflow in ../drivers/cdrom/cdrom.c:2361:33
[  366.021089] -9223372036854775808 - 346321 cannot be represented in type '__s64' (aka 'long long')
[  366.025894] program syz-executor.4 is using a deprecated SCSI ioctl, please convert it to SG_IO
[  366.027502] CPU: 5 PID: 28472 Comm: syz-executor.7 Not tainted 6.8.0-rc2-00035-gb3ef86b5a957 #1
[  366.027512] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  366.027518] Call Trace:
[  366.027523]  <TASK>
[  366.027533]  dump_stack_lvl+0x93/0xd0
[  366.027899]  handle_overflow+0x171/0x1b0
[  366.038787] ata1.00: invalid multi_count 32 ignored
[  366.043924]  cdrom_ioctl+0x2c3f/0x2d10
[  366.063932]  ? __pm_runtime_resume+0xe6/0x130
[  366.071923]  sr_block_ioctl+0x15d/0x1d0
[  366.074624]  ? __pfx_sr_block_ioctl+0x10/0x10
[  366.077642]  blkdev_ioctl+0x419/0x500
[  366.080231]  ? __pfx_blkdev_ioctl+0x10/0x10
...

Historically, the signed integer overflow sanitizer did not work in the
kernel due to its interaction with `-fwrapv` but this has since been
changed [1] in the newest version of Clang. It was re-enabled in the
kernel with Commit 557f8c582a9ba8ab ("ubsan: Reintroduce signed overflow
sanitizer").

Let's rearrange the check to not perform any arithmetic, thus not
tripping the sanitizer.

Link: https://github.com/llvm/llvm-project/pull/82432 [1]
Closes: https://github.com/KSPP/linux/issues/354
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/lkml/20240507-b4-sio-ata1-v1-1-810ffac6080a@google.com
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/lkml/ZjqU0fbzHrlnad8D@equinox
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20240507222520.1445-2-phil@philpotter.co.uk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index a5e07270e0d41..20c90ebb3a3f6 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2358,7 +2358,7 @@ static int cdrom_ioctl_timed_media_change(struct cdrom_device_info *cdi,
 		return -EFAULT;
 
 	tmp_info.media_flags = 0;
-	if (tmp_info.last_media_change - cdi->last_media_change_ms < 0)
+	if (cdi->last_media_change_ms > tmp_info.last_media_change)
 		tmp_info.media_flags |= MEDIA_CHANGED_FLAG;
 
 	tmp_info.last_media_change = cdi->last_media_change_ms;
-- 
2.43.0



