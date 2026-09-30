Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795B839CCE0;
	Wed, 30 Sep 2026 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783219; cv=none; b=mH7YvjQpWneGydrX403rCOxRFsWByhDw0p7c74dyCtowWMyzILZFmKkLOvLUNhSqleZ7r6Pknu7Eoe+vuho72EWnlIkNwwbkvlPv+If//N56M+CLO9VQY+ltDw8SEPGwukKHW/r779OUz0yHdZCIZo3XFd3kad+jIXcnhchLOqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783219; c=relaxed/simple;
	bh=/PbTqV1cYf/Ay09CP4ok/uV81lhp7D5wLNhq+3HnQ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkbzT78DlqtiEpZzSeCwiaXTgaAkiN7XhmG7+nt4Nuo+0I4o2F6Bdhr40MyILuqbq7LDKHp7oHRzyU0dVwYvlp39nbPoQkjNpagmtIgx2teAyZtSlL+X07G1QNGGCiWb5nggru20UVY0GbLugxh5dm1WOU6uS3YMqayQfKKDXfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S91gvaCw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S91gvaCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C8D1F00898;
	Wed, 30 Sep 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783214;
	bh=5jTeIUfX//1DmyQXGWy4cCWty2zm3Z97lAniWtWl+bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S91gvaCw6U080OlN6A5oMALdzLy38YsBCyViZuw+lfGcJDG0RymUIYxIJiGbrCrin
	 5jEAg1FGydw3jEhHpdrY3WqfY73TnH1qpa7EDTA/1o1e0hCbgpORmitcxm5z90wNUo
	 mLr9vJ5E+d5Q6qKEOPSdtma3bFsXBDzkI2VrLA+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/595] ALSA: us122l: Prevent write upgrades for read mappings
Date: Wed, 30 Sep 2026 17:23:34 +0200
Message-ID: <20260930152354.589956867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bccb47d38c6dc..af92ebaf6e998 100644
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



