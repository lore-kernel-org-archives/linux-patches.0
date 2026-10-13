Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA3F4F392E;
	Tue, 13 Oct 2026 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892026; cv=none; b=Dy9VJQs9BxLKYk+RZVDS69Wdymkw7X8oHX4UdEymFfDdwnpfkVdSxmOg3P34swwLCqPFrGBHlcIJWDNz86EZvOlSh1z0nwq+l/9bnb6n57/YBoRAXiPB5BfFnj+kDHyRADmWQQbcqTR1feRvOiSXFf4+UBFyJt6uTGBn6xP3bU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892026; c=relaxed/simple;
	bh=WUESbFpQT+ZV3d9QT8o6VyP7zkArFm/8yO1XcJVZhbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY8YiT+XjpBmmG158SsLjXjKRXO+qsFuLNsNeh5xistgSXu79sjAM2evKRdLnlBcy3O+29w4fsT4/JCsXsw5OOoGh/IsD3NNfM2mKCFUbKg6/dE2e31WyvPPIV5garrlc8T13v4q+1rPP0UoZqDJKnaoDBWhqKpjiw7w9GsBM68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIMrPhG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIMrPhG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEFA1F000FF;
	Tue, 13 Oct 2026 11:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892024;
	bh=RK7q/tqapt7x65tX4cMenItcbNHnFvldgXmBStvwBOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIMrPhG2j/VchTgQl/03rUKze+FLR5SNbbgfZ39mz/fqYGDw5hWwhmdV/kvU1P9lH
	 KlC7dU7Yxeh0kcXKBEBHXV7svy1njdlGT7GuYdo6j5aq1LDhgruX0TX6cDyO1TdbBo
	 nJ0eCubI+CiEKKib0nxFfoiZzkgqLlUdXAUeV4/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+48d935cf48a4a76be346@syzkaller.appspotmail.com,
	Palla Raghunath <raghunathpalla.0209@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 028/281] dm ioctl: dont let data_start run past the buffer
Date: Tue, 13 Oct 2026 13:35:44 +0200
Message-ID: <20261013112855.734344397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -658,10 +658,16 @@ static void *get_result_buffer(struct dm
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


