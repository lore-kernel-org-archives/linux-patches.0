Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E974F4051;
	Wed, 30 Sep 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791753; cv=none; b=YegZrYfGfI5WgOQCKN8i08UbkSl+kf26CJ+yNq+rpfZCI2Z+Stwd95ZioflJA6VsCTMZvDS6cpGg3h2KICjv87jwXnBx+C9dVTwxb7D9glLvpDoJ5OVbZzJXPyNEGV8oUP3dwTcZMgkBi2kbWvFoqHMGVWWUNAevsT/xiPNHQSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791753; c=relaxed/simple;
	bh=otThHe0QIRWQsV4vRsHRzhBs417d6XOk7pWP2fGUP5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQj1h2CZ7OuhSlA02Lnw0Rxt+iTdI5STuKJ+DAlJTWoveyI+luGhqYdGpocbx9wX1OG9SZSoRULaFxesjlauMyaakUUgzMFoLtzTgQQcJnMTmS5R9Cb400YJ4YBeVtYVGhmsb9rUBoaL+wh65Nw0bIguJnfR/Oa4yu7mimcgjm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHDjaZQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHDjaZQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C691F000FF;
	Wed, 30 Sep 2026 18:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791752;
	bh=ktHoesQt5Yndcj70qF8OsGnK5DrURRDc41i6m9ES7gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHDjaZQEq9gY6IHwzZRwob2iRRb/wZjCKZJyPw9hCLuin+4+HYFrWCL09gjfXUWgX
	 Y9TLlndePDUSDPVueFpYATvHUFlNtgqMEjHbqCbdvVC/rashUvMpEU/AmlBqYtCJU0
	 GuQzyA11fLO/el7uL2QRwZUj+P2rwGQRsyeRAW9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/752] ALSA: us122l: Prevent write upgrades for read mappings
Date: Wed, 30 Sep 2026 17:24:41 +0200
Message-ID: <20260930152407.169380377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit 71c610aeb1770302ac9c9e0b9a4ecd37f1311928 ]

The hwdep mmap callback rejects read-buffer mappings that are initially
writable, but leaves VM_MAYWRITE set on mappings created with PROT_READ.
A process that can open the hwdep node O_RDWR can later use mprotect() to
make the mapping writable.

The read allocation begins with struct usb_stream. Its read_size member is
used by the fault handler to decide which pages belong to the read buffer.
The read VMA intentionally remains expandable because pcm_usb_stream uses
mremap() after reading that size. Changing read_size first can therefore
map and access pages beyond the allocation. The same member is also
consumed by usb_stream_free(), where changing it can make
free_pages_exact() release pages outside the allocation.

Clear VM_MAYWRITE for read-buffer mappings after rejecting an initially
writable VMA. This keeps the separate output-buffer mapping writable while
preventing later permission upgrades.

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Link: https://patch.msgid.link/20260908110053.2950767-1-hnkz.64@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 23d7d542a3de6..21c5a7fcea768 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -209,9 +209,12 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	mutex_lock(&us122l->mutex);
 	s = us122l->sk.s;
 	read = offset < s->read_size;
-	if (read && area->vm_flags & VM_WRITE) {
-		err = -EPERM;
-		goto out;
+	if (read) {
+		if (area->vm_flags & VM_WRITE) {
+			err = -EPERM;
+			goto out;
+		}
+		area->vm_flags &= ~VM_MAYWRITE;
 	}
 	snd_printdd(KERN_DEBUG "%lu %u\n", size,
 		    read ? s->read_size : s->write_size);
-- 
2.53.0



