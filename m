Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C476B3CAE9B;
	Sat, 17 Oct 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260044; cv=none; b=qQ7h4BMv7FQlfA7VymOoVkpiX5+6EtdvSnh7oQ1s4OsaZ8bybV8Wg9DYQATHF9ZYingHuXgwNklY0x0wBRyQY/gYnlHbRvZO5G0hufRTIt91BKr5QI7rZlIb8ipJpDrnIMKIboigSz2zHFzflFBY6YNKBQgSGKvhTDm8i/c96kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260044; c=relaxed/simple;
	bh=PLcZZ29kmRMpWzp6kbbLfzmth+JXfrjw0G5og2sQfaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZsh5ZyTap5NWxMgzMQPPXNLUVYuzHSSqMflXOAfpjj4RgP7/48eW8xiHHa+DAMR8hqNGfhCWgh4MlxKqycQ/d3/cb37Vi9ptebi5mD5ow5fRsm1pN2TcXAteFXvI5x2+mqIEvXkBoqtrUyHBueCZkcULw3LHBmcdLNYpgWt4qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N35hLhzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N35hLhzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208B41F000C4;
	Sat, 17 Oct 2026 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260043;
	bh=b/bz0UdIRBYQp9Xjfnv29qHmeC2u8wQfIx7g9y23pRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N35hLhzt5iaI3hEsLGqYilbPmFTV7nku9NS7V4dh/eCQC5kHHXCBTanad+dg3mZWy
	 w83LnmXaFHu6gP5kRrgJ7vE45X1q1DtN9z6CVK64lC1Cm7JxXHim/kxSXcrQgCuYG5
	 X4M7SepfCIw8gcGAwUBzq4AEbepwKvpNXRRllnEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5fa3d224505c8610702@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1363/1674] usb: gadget: f_midi: initialize work in f_midi_alloc()
Date: Sat, 17 Oct 2026 18:00:35 +0200
Message-ID: <20261017160506.140500915@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 7e07d3e4c389217d7d7171d80edf2e23ac70f1ea ]

f_midi_alloc initializes free_ref to 1 and it can only be incremented
when a sound card is registered via f_midi_register_card().
f_midi_register_card() is only called in f_midi_bind() which actually
performs INIT_WORK. If f_midi_bind() is never run, work is not
initialized and the if condition in f_midi_free becomes true,
this results in a warning later in __flush_work as work->func = 0.
Fix this by moving INIT_WORK from f_midi_bind() to f_midi_alloc().

Reported-by: syzbot+d5fa3d224505c8610702@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d5fa3d224505c8610702
Fixes: 8653d71ce376 ("usb/gadget: f_midi: Replace tasklet with work")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260815054006.102325-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 48c87f5b1a4e1..33ee0e3f18eb9 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -877,7 +877,6 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	INIT_WORK(&midi->work, f_midi_in_work);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
@@ -1370,6 +1369,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto midi_free;
 	}
+	INIT_WORK(&midi->work, f_midi_in_work);
 	midi->out_ports = opts->out_ports;
 	midi->index = opts->index;
 	midi->buflen = opts->buflen;
-- 
2.53.0



