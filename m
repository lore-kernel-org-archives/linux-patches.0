Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98F33A75BD;
	Wed, 30 Sep 2026 18:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791768; cv=none; b=rA6koL0LhP5ijotAvdqKDU0SSlP3+avoKhIxp+9SjC1K+Z/a4KCNG3RcP+OEgbgAuqk1xz8CNgdC6cCsAHQRhqGsbOG24zfal5bK7+zVUK71YqlYhHhjJ3eRWS0wST58B3AJVCv8SEYzmOGuja8ap1PCz7VyIkEn028B2lVhWkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791768; c=relaxed/simple;
	bh=7pnyZmfz6dQ2Tunqyh8fMRvNVXFzaDMZrYLyW6PZk4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gmr3QyFPFSFSDtprhGLi9ywxmEIg/zTbqWo4Xv47i0QNgFc1gadEOt0X5tQhSTR2SuAJZrbK82JjN8hwykRdTAFu9Vq9wYozcdMDJC0GkZ2NrkMiIxeBcXMkbNSs/xPlqheveHJz+uSZhfIsr+CvoVc7ImmPA6xx0Ddz6rys69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFIANMLS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFIANMLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93761F000FF;
	Wed, 30 Sep 2026 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791766;
	bh=J2MNjQv0LSlt4LfFBCo48sOd750nl8J5S16plmDj0E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFIANMLStL9S+cNFjJCPXipPfnid1gk1gj4cbMaISkaOd0yGr5XTJWwljtH1IzMNf
	 A751M24SAum2RKx119Phj6MsIOhc0R2rUX0Mj/rfr/mSAY4FyQ4jLfRJnTYh2aKgX/
	 5/KwLYetjNGN/8nfwlCHurGTjJ0oBc9TLRpIHuh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 373/752] ALSA: usbusx2y: fix in04_last array size mismatch with in04_buf
Date: Wed, 30 Sep 2026 17:24:03 +0200
Message-ID: <20260930152406.349401222@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 861111a14740e12c36d363e9830f8daa734279c9 upstream.

The in04_last array in struct usx2ydev is declared as char[24], but
in04_buf is allocated as sizeof(struct us428_ctls) which is 21 bytes.
In i_usx2y_in04_int(), when ctl_snapshot_last == -2 (initialization
path):

    memcpy(usx2y->in04_last, usx2y->in04_buf, sizeof(usx2y->in04_last));

This copies 24 bytes from a 21-byte slab allocation, reading 3 bytes
past the end of the source object.

Introduce a USX2Y_IN04_SIZE constant defined as sizeof(struct
us428_ctls) and use it consistently for the in04_last array, the
in04_buf allocation, the URB transfer length, and the comparison loop,
replacing the bare 24 and 21 literals throughout.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260904205826.4071119-1-tristmd@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/usbusx2y.c |    6 +++---
 sound/usb/usx2y/usbusx2y.h |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -197,7 +197,7 @@ static void i_usx2y_in04_int(struct urb
 			memcpy(usx2y->in04_last, usx2y->in04_buf, sizeof(usx2y->in04_last));
 			us428ctls->ctl_snapshot_last = -1;
 		} else {
-			for (i = 0; i < 21; i++) {
+			for (i = 0; i < USX2Y_IN04_SIZE; i++) {
 				if (usx2y->in04_last[i] != ((char *)usx2y->in04_buf)[i]) {
 					if (diff < 0)
 						diff = i;
@@ -306,7 +306,7 @@ int usx2y_in04_init(struct usx2ydev *usx
 		goto error;
 	}
 
-	usx2y->in04_buf = kmalloc(21, GFP_KERNEL);
+	usx2y->in04_buf = kmalloc(USX2Y_IN04_SIZE, GFP_KERNEL);
 	if (!usx2y->in04_buf) {
 		err = -ENOMEM;
 		goto error;
@@ -314,7 +314,7 @@ int usx2y_in04_init(struct usx2ydev *usx
 
 	init_waitqueue_head(&usx2y->in04_wait_queue);
 	usb_fill_int_urb(usx2y->in04_urb, usx2y->dev, usb_rcvintpipe(usx2y->dev, 0x4),
-			 usx2y->in04_buf, 21,
+			 usx2y->in04_buf, USX2Y_IN04_SIZE,
 			 i_usx2y_in04_int, usx2y,
 			 10);
 	if (usb_urb_ep_type_check(usx2y->in04_urb)) {
--- a/sound/usb/usx2y/usbusx2y.h
+++ b/sound/usb/usx2y/usbusx2y.h
@@ -5,6 +5,8 @@
 #include "../midi.h"
 #include "usbus428ctldefs.h"
 
+#define USX2Y_IN04_SIZE	sizeof(struct us428_ctls)
+
 #define NRURBS	        2
 
 /* Default value used for nr of packs per urb.
@@ -55,7 +57,7 @@ struct usx2ydev {
 	int			stride;
 	struct urb		*in04_urb;
 	void			*in04_buf;
-	char			in04_last[24];
+	char			in04_last[USX2Y_IN04_SIZE];
 	unsigned int		in04_int_calls;
 	struct snd_usx2y_urb_seq	*us04;
 	wait_queue_head_t	in04_wait_queue;


