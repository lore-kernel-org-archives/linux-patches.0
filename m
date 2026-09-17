Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B464CDDCD;
	Thu, 17 Sep 2026 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666252; cv=none; b=Us6BJ1YHPkKouBNC0ooDx1G6LS3AAKGdhDs8AIGxPxVlcZV263ob+7Ll6Qqw/fyVPk7/GJqyMlnyM7crYzSt0f3136L2sSjC4jCG3rQ82RwuMs/P8JhvkO2xJQ44LLA+svAQ+/NmsrsVmxF98lBCB6OTrUnMX+0DOLsRqyeR/iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666252; c=relaxed/simple;
	bh=ot5F08VcO8q3fgpnakzPl9ugk9wNk8p1eQEv2wY0SIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjSMdwdhcN20YNckm7dgbzJO7Y769S81qxNdX3oCJVb5YVRTjMrY7VrkjSP0T/KMBXv0kv4+o6QqqrAXn00+v1Od4ONB4aLeqwKYH8yymYo2c7KEVmsZzci4mxkF3oF6TYV5hIPjV8guOzbFua6JIRNOreUnXPgSun3LWL6fAfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh1J7U50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh1J7U50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F8F1F00893;
	Thu, 17 Sep 2026 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666251;
	bh=0ZjXYfG9opsEbVNgDkrSN8qOdNEdYIokv2GUV1JNn4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh1J7U505d1y31O0+t7WCd9R+zZfmLXhqiZPJOyqWmWvCgO2VYJotG7nxfpd0//sl
	 51UpxetuotxSIo/41UWOOm4Wg1Gnl68TY3ku46bm9thoESfCujPQv9SCTWbiQ82w77
	 bJSoob1fD5HHa2wE8wjxemJs7O8x3PiU4oamjkv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 0974/1250] ALSA: us122l: Prevent write upgrades for read mappings
Date: Thu, 17 Sep 2026 16:12:49 +0100
Message-ID: <20260917151618.412589742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

commit 71c610aeb1770302ac9c9e0b9a4ecd37f1311928 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/us122l.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -180,8 +180,11 @@ static int usb_stream_hwdep_mmap(struct
 	guard(mutex)(&us122l->mutex);
 	s = us122l->sk.s;
 	read = offset < s->read_size;
-	if (read && area->vm_flags & VM_WRITE)
-		return -EPERM;
+	if (read) {
+		if (area->vm_flags & VM_WRITE)
+			return -EPERM;
+		vm_flags_clear(area, VM_MAYWRITE);
+	}
 	/* if userspace tries to mmap beyond end of our buffer, fail */
 	if (size > PAGE_ALIGN(read ? s->read_size : s->write_size)) {
 		dev_warn(hw->card->dev, "%s: size %lu > %u\n", __func__,


