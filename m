Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6235E93B;
	Sat, 17 Oct 2026 17:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257165; cv=none; b=m2JW+xw8ZrWbiI5KN53MDLq+BWFM/wjF6KyOQTES7kuLbj0WsTkqgtwG2MV6WDj81bIdq9qULMls+4ZZ/PzZPGKpVUz9+IMmsoGX1aUcObu6I8enKIcLgDT4y6PdQLiC2jU6YQtOe7RjVJBSVevp5s0Zdd3/59YWwn7z2T4siGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257165; c=relaxed/simple;
	bh=HFY5GyYXfh1fuaYJ9XWgeX+44WJ9fm32lVybDretoZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riLo90hNtHF5yxxCdqqkablHiso01y+DLqmnrJT8KMPWHHUzHpIPt/uptUomuxgRbUmEaDy9V06YzMr37IM6mh7AGywPydKg+y2vpepVc8+ZZrL54dkUfwtWWrAtZkpubsVQRQAdYuBGo7Y/0rcRYc+E0yjf3IWL7dRzyN492ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC2pC8Bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC2pC8Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243231F000C4;
	Sat, 17 Oct 2026 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257164;
	bh=hkPJcUiBBKTFM1yQI6dhNX06mKFLDGjK5jhemkU6X+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC2pC8BbXYUpsi8/oxlLBxol63BNAr0v+WpVfik0dwJD+CUemBAjDGB+vLhgyWdda
	 sKOiCPYgnQ/3LUzrAIIZRfqOaDxbS3DmPVC7DEcL6pWpTS2QHM/2Izd1eL8dwpSKdz
	 yE78ihoPrGFsoRh1WkMJl7kusXLoCe94Uy/aqVRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 0471/1674] dm ioctl: dont let data_start run past the buffer
Date: Sat, 17 Oct 2026 17:45:43 +0200
Message-ID: <20261017160443.206228222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -556,10 +556,16 @@ static void *get_result_buffer(struct dm
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


