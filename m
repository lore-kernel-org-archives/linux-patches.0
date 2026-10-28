Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208999;
	b=zy5AdbdgVajg9+XgWr0d+eaOn9gRbOybliICkYy9oBMpmzUSMnP2BF0F9EOHFOkWgGde
	 Ol8CW54KZa674w+rMItg9pqF1+WojX550f2TX/0tjFv/lHDe4dRBvRpCjld5K9te/56JH
	 ZbHKNUvBjB2Y8kZiQ5aXANc8R8CPtwMxbcmjq7rIn1wJ63NM68QO9qm+pgLp42Vx13XqX
	 Yd6i9T4e27FaUeJbHe9U5C7SATQUrDxmnIoEhu3uOY5G8k5KjXmoKLtQP4Q/owONOyfAv
	 JByJhKth2YMNWuioF3/guzLM3A20FoA5ofjeyUg7UTYk9317EQ47uin85khrXAaBsgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pfiapnkJvHI7Vhw0Z/XF+eKjiEpaBfLz+zPMW43lV5w=;
	b=WMA2MU7sRHb8B+qsw6ckeoNkgxDfYYVzUd5U5La5q5qMt9qeaQuFsNh/DxzjSLM/TmTC
	 coSBG0aY12FAI5xhX6nX60avQgP1MP/5Xq9vWsh3P0VV2haqkRwyZ0UeDZAl/zWGlb6EL
	 rDue4tO02xoBiqu7ybeTZh3ea1sIVj5+5YlKqeGP4+xKor+Q7c5riJAcOytum0E0dScdt
	 96OLC+1G1K/9h7HOnvRXxQKpf1gM3H6/UMc0rv+62KD/DfMUlU16Auhs4gv3jeeKehPD5
	 HuexjfC2nAxmgPskT+fQ5mN4dNhXVU+V6m0u6b/bJ2G9+vp0UnapeB/yo0UbpW7taWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMqi2gpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF23606A31A;
	Wed, 28 Oct 2026 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OMqi2gpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A441F01825;
	Wed, 28 Oct 2026 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208999;
	bh=pfiapnkJvHI7Vhw0Z/XF+eKjiEpaBfLz+zPMW43lV5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMqi2gpMFfQXbxIUdU5TRKLgezjJ+71qlw59uBOE9v5TWmoQkhXJjXci93X2go51E
	 fRTOtEeG1nyU8OzI2/DXmdZ1m12dilZAOdAaZqT0BWjSwepaDBhEvU9bauBtIsFUiX
	 wqOxNWQXXsfqRoYETgUPN7QfM/XUY7HxDBOIAUc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 316/516] dm ioctl: dont let data_start run past the buffer
Date: Wed, 28 Oct 2026 17:57:48 +0100
Message-ID: <20261028170010.975380313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palla Raghunath <raghunathpalla.0209@gmail.com>

commit 9b3fcf519d370df94a56f3b272d9eddffffa5be8 upstream.

struct dm_ioctl has seven bytes of trailing padding, so the smallest
buffer userspace is allowed to ask for, offsetof(struct dm_ioctl, data),
is seven bytes shorter than sizeof(struct dm_ioctl).

get_result_buffer() sets data_start to sizeof(struct dm_ioctl) without
looking at how big the buffer actually is. Ask for the minimum and
data_start ends up seven bytes past the end. Callers add it to
data_size, and ctl_ioctl() copies that much back to userspace:

  BUG: KASAN: slab-out-of-bounds in _copy_to_user+0xad/0xd0
  Read of size 312 at addr ffff8880169e4c00 by task repro-dm/140
   ctl_ioctl+0x5e3/0xcb0
   dm_ctl_ioctl+0x25/0x40
  allocated 305-byte region [ffff8880169e4c00, ffff8880169e4d31)

A DM_LIST_DEVICES with data_size set to 305 is enough to hit it, and the
seven bytes that leak are whatever sat next to the allocation.

Clamp data_start to the buffer size.

Note that this is not a security bug because the out-of-bounds read can
only be triggered by root.

Reported-by: syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48d935cf48a4a76be346
Fixes: 76c072b48e39 ("dm ioctl: move compat code")
Cc: stable@vger.kernel.org
Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -496,10 +496,16 @@ static void *get_result_buffer(struct dm
 {
 	param->data_start = align_ptr(param + 1) - (void *) param;
 
-	if (param->data_start < param_size)
+	if (param->data_start < param_size) {
 		*len = param_size - param->data_start;
-	else
+	} else {
+		/*
+		 * The buffer can be as small as offsetof(*param, data), which
+		 * is less than sizeof(*param), so don't run off the end of it.
+		 */
 		*len = 0;
+		param->data_start = param_size;
+	}
 
 	return ((void *) param) + param->data_start;
 }


