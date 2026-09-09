Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843BF5678C9;
	Wed,  9 Sep 2026 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963294; cv=none; b=uSt1MgoUxiC7IhR7z1xWidmSDRMpd4U9S6mBcDBQMUBvsYP+wQe97DDKoM5RTU2EL8/55rWUPSQh3rGljfHCE3mTWP2xvp4JUCZXrJ3z01VDT/Sm1TUJghi6m60t0d8BkRePpYsg4Hj4lTLpfxLdzdVblw1vH48ACUCJHuygHL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963294; c=relaxed/simple;
	bh=Z252s7Cmfn+Pv//Mz10C2LkBAMoYmh/EjATWVIQ7GOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cco6nGFwDA7EYFFMhTyl6goJ1YxdFGh2wxIazXaGE9aTKUBhZp9/keAbll1/3dKlmvxptzfldXhbuW9lzCqsRkmp2cC5u3wwQaEN8zpiQakLXvVaXPjsajR/h1TFCAJx+UARoK2Ck/NHYrocyxdtFiBG3k5Iej5+UMlbuTVrnLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UpQqaSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UpQqaSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC80B1F00A3A;
	Wed,  9 Sep 2026 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963293;
	bh=gY0KDspNThwK78sBE6PdeOAdO40WDfpo3Pm3Pcd6GTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UpQqaSrNvg7C+sBPDAzR7c/4Lw8guVFNwwwCKe8Mfho5oPeKO7Z7QWCrp7RzqN6Q
	 qOOv1BiXwz0iG2D/4eV2lyFQ4g2V813AIulyiWIFYNXzy+PQvfnlhS3KDb4rejLtXR
	 eQcVthYckJhHverEbuRQK+kGv6kw83kedLfnlWZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5fa3d224505c8610702@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 029/583] usb: gadget: f_midi: initialize work in f_midi_alloc()
Date: Wed,  9 Sep 2026 15:35:14 +0200
Message-ID: <20260909134238.839591178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit 7e07d3e4c389217d7d7171d80edf2e23ac70f1ea upstream.

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
---
 drivers/usb/gadget/function/f_midi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -878,7 +878,6 @@ static int f_midi_bind(struct usb_config
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	INIT_WORK(&midi->work, f_midi_in_work);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
@@ -1371,6 +1370,7 @@ static struct usb_function *f_midi_alloc
 		status = -ENOMEM;
 		goto midi_free;
 	}
+	INIT_WORK(&midi->work, f_midi_in_work);
 	midi->out_ports = opts->out_ports;
 	midi->index = opts->index;
 	midi->buflen = opts->buflen;


