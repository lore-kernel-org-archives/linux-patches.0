Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDBA134C6
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AA5C433C9;
	Thu, 29 Jun 2023 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064545;
	bh=LBjn/Pz+9UNS62YtSJIUKTSQKpSSxxVma/nFzlqTTaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kE+aI9YOffxC/DOTZ9UwCTILfwV6Vjc1j03iW57I8tkOupr4AZwl6daRmh+/3O2KG
	 ZxhZd5jTHSAxTTNLM4ud5HMFbMBofb1SusjzInFJC0TJ5j0EAGPulE/lKr1wdPT96N
	 u/h0haeUnfPxQsvxp7xbTiHXRzslj2zJv9044BP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludvig Michaelsson <ludvig.michaelsson@yubico.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.4 26/28] HID: hidraw: fix data race on device refcount
Date: Thu, 29 Jun 2023 20:44:14 +0200
Message-ID: <20230629184152.902104594@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.888604958@linuxfoundation.org>
References: <20230629184151.888604958@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ludvig Michaelsson <ludvig.michaelsson@yubico.com>

commit 944ee77dc6ec7b0afd8ec70ffc418b238c92f12b upstream.

The hidraw_open() function increments the hidraw device reference
counter. The counter has no dedicated synchronization mechanism,
resulting in a potential data race when concurrently opening a device.

The race is a regression introduced by commit 8590222e4b02 ("HID:
hidraw: Replace hidraw device table mutex with a rwsem"). While
minors_rwsem is intended to protect the hidraw_table itself, by instead
acquiring the lock for writing, the reference counter is also protected.
This is symmetrical to hidraw_release().

Link: https://github.com/systemd/systemd/issues/27947
Fixes: 8590222e4b02 ("HID: hidraw: Replace hidraw device table mutex with a rwsem")
Cc: stable@vger.kernel.org
Signed-off-by: Ludvig Michaelsson <ludvig.michaelsson@yubico.com>
Link: https://lore.kernel.org/r/20230621-hidraw-race-v1-1-a58e6ac69bab@yubico.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hidraw.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -272,7 +272,12 @@ static int hidraw_open(struct inode *ino
 		goto out;
 	}
 
-	down_read(&minors_rwsem);
+	/*
+	 * Technically not writing to the hidraw_table but a write lock is
+	 * required to protect the device refcount. This is symmetrical to
+	 * hidraw_release().
+	 */
+	down_write(&minors_rwsem);
 	if (!hidraw_table[minor] || !hidraw_table[minor]->exist) {
 		err = -ENODEV;
 		goto out_unlock;
@@ -301,7 +306,7 @@ static int hidraw_open(struct inode *ino
 	spin_unlock_irqrestore(&hidraw_table[minor]->list_lock, flags);
 	file->private_data = list;
 out_unlock:
-	up_read(&minors_rwsem);
+	up_write(&minors_rwsem);
 out:
 	if (err < 0)
 		kfree(list);


