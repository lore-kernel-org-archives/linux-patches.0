Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1865E5038F7;
	Wed, 30 Sep 2026 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785611; cv=none; b=Dkk6MH3qkr4XqGhHCZ+Xf7Dkr13IV3fDyLmFetqYlLS0lvPlBR0nWlNtxKb92H7CETyCTYDICfeKbYM78TS73P5ap08Xahnob6kDYBafYSCf8lyetB3jVgLXmywMNOcwIoW3Hf2PkZn1l0IECcYmBn8swytniYLlD+JBs43ob1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785611; c=relaxed/simple;
	bh=xI8lV+Yxa5uiOldp6kHLNGChE2g8a3X8nW+48gUftSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soPkd/5DNJsrpExHv+I4ukG55NgS0sK6Tdiyv+HEax0MM/2Ae/X+7/wUIj3P8xeDmiAJ/n0HzTVVDf3/CGFP3gzZw3HfEud4us2Fsk154cdtOUd5SQP9wuUHMKY5Rq4uTbMXpMk/xnC4VRWbDbGIVYlSBcqJTR7z7W7LP/2BfWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ekwg6q8L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ekwg6q8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273431F0089A;
	Wed, 30 Sep 2026 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785599;
	bh=r7dhsix0RQv4GIUk+EHmglAfYe3y64RP5VRrSbGopl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ekwg6q8LdJBLbd5Zq4SFCc5gEQ21yFmM0caaX/ZPEefknVWPDtm99pAyWiDhSVbcw
	 0ipfMxpJdYBUWIV2jH4P45dHAYYVZoeG1yD0T4HWuEWwR3dgwDkDo7ucZ+d7awmtfa
	 Ymt/7kDoI3XAQJk8qSHcrpe/WXv9mLLharOb3bgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 566/982] ALSA: us122l: Prevent write upgrades for read mappings
Date: Wed, 30 Sep 2026 17:21:42 +0200
Message-ID: <20260930152428.927847466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



