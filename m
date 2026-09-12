Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7F4362120;
	Sat, 12 Sep 2026 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212976; cv=none; b=TMx/zGeMPf+Tdi81bU27OSO6C/+jAFY6jrj75v+SzLq1se33RYoty8qilHfR3csNaXJGkT2BY9iyNaOEQP+kMV6iQ+71QdhPqU9UPo8N4zmkqdnoZX8qouLS1hkMU6eqf/alJs0VjBZzkmddNZNLg1e6YZX0oRRvSVDf1MYhnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212976; c=relaxed/simple;
	bh=VJqq4V8O9Ga8PSWAdc5Ls8peoRCqkZzcTWi6mUWDhbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFTI2TZurLTpv4rhCUE59tUiWlIVUoJdCoty/3Xr4lJLyNUS3owd+N2Uz1AioxIFuT9EXI/aoNmhiv+eIAS1EhihkEJuQesG3KEkBACKQhNxtwD/X3I34Ad4KKurddKpumvoaB5pbBupWmtS0nNQtCBJSyVdVt66cC6vfYOut5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjgrvkeV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjgrvkeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E407F1F00893;
	Sat, 12 Sep 2026 11:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212975;
	bh=BS8T4Ckea7mvKD0mOUjLGgWqt//eqhtmjT/XTytZDIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjgrvkeVxO+DXn0KTLb69PHoUYjmnfuCeJpZ+kI70eG0ShEFis/WPrBsItSWqYJiz
	 0FiAWj66aUtvi3ZZkyG/+pMZiZNm7yIYy7ASlKVvpSGn71t2dM033JcA3YXbJpMUbL
	 jGhGeJAWloBRr/cc5JEP/+m6ge+doi3Zsr5sz+2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0027/1376] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
Date: Sat, 12 Sep 2026 08:40:53 +0200
Message-ID: <20260912065608.155297959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Nogikh <nogikh@google.com>

commit f0efaf1872949e96d213c8e910fd9517f7d7c406 upstream.

A null-pointer dereference occurs in f_midi2_free_ep_reqs() when attempting
to clean up an endpoint that was never initialized.

When configuring the MIDI 2.0 gadget via configfs and setting the block
direction to SNDRV_UMP_DIR_INPUT, the initialization of the midi1_ep_out
endpoint is explicitly skipped during the gadget bind phase
(f_midi2_bind()). As a result, the usb_ep->card field remains NULL.

Later, when the host sets the alternate setting, f_midi2_set_alt()
unconditionally stops both the IN and OUT endpoints by calling
f_midi2_stop_eps(), which in turn calls f_midi2_free_ep_reqs() for both
endpoints. When f_midi2_free_ep_reqs() is called for the uninitialized
midi1_ep_out, it attempts to dereference usb_ep->card to determine the
number of requests to free, leading to a crash.

Fix this by using usb_ep->num_reqs instead of usb_ep->card->info.num_reqs
in f_midi2_free_ep_reqs(). usb_ep->num_reqs is correctly set during
f_midi2_init_ep() and remains 0 if the endpoint was never initialized,
safely avoiding the loop. For consistency, apply the same change to
f_midi2_alloc_ep_reqs().

Oops: general protection fault, probably for non-canonical address
0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
...
RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
[inline]
RIP: 0010:f_midi2_stop_eps+0x28e/0x4d0
drivers/usb/gadget/function/f_midi2.c:1246
...
Call Trace:
 <TASK>
 f_midi2_set_alt+0x11c/0xf00 drivers/usb/gadget/function/f_midi2.c:1296
 composite_setup+0x1ffd/0x3480 drivers/usb/gadget/composite.c:1933
 configfs_composite_setup+0xbd/0x100 drivers/usb/gadget/configfs.c:1877

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable <stable@kernel.org>
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbb6dad313f4aaa8da6b
Link: https://syzkaller.appspot.com/ai_job?id=8ce30b1a-8cf7-4e38-bcf7-1f69e6f6313f
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Closes: https://syzkaller.appspot.com/bug?extid=01a17afb30637396955e
Link: https://patch.msgid.link/cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1145,7 +1145,7 @@ static int f_midi2_alloc_ep_reqs(struct
 	if (!usb_ep->reqs)
 		return -EINVAL;
 
-	for (i = 0; i < midi2->info.num_reqs; i++) {
+	for (i = 0; i < usb_ep->num_reqs; i++) {
 		if (usb_ep->reqs[i].req)
 			continue;
 		usb_ep->reqs[i].req = alloc_ep_req(usb_ep->usb_ep,
@@ -1160,10 +1160,9 @@ static int f_midi2_alloc_ep_reqs(struct
 /* Free allocated requests */
 static void f_midi2_free_ep_reqs(struct f_midi2_usb_ep *usb_ep)
 {
-	struct f_midi2 *midi2 = usb_ep->card;
 	int i;
 
-	for (i = 0; i < midi2->info.num_reqs; i++) {
+	for (i = 0; i < usb_ep->num_reqs; i++) {
 		if (!usb_ep->reqs[i].req)
 			continue;
 		free_ep_req(usb_ep->usb_ep, usb_ep->reqs[i].req);


