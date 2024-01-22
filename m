Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A367E69;
	Tue, 23 Jan 2024 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975306; cv=none; b=HGdvrI9KhfbhUpMRzeTD6/5n1v39NeSgNxJO0IIFYTtZe1Wob5ucDH2A13WELw65SDZQpTmJMVVOYa2npkQRWse5urnrnYWvtJRs/g8MrIcvf4ZADcTI/zXQfdfQ3lZNuhC4jrYQNqJCJOESN8XixcRRUhElMjtHgufrQ41/qrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975306; c=relaxed/simple;
	bh=rtNRy6K9p9et3fzo3hAlcYC68+KBgiAUHZQ5ki0YBwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKAtWPa0kSgAAFcW1vcBQt0B6JWf/znU0l0Y+vpBwzk0+mDj0tygYh7IiIkktwHzAovqqM27bqLzWgZbVmIDErWQwl72R19/8rnuoJnPgog5oMw7kJRNjwZeI46VHh/IWKPQhEtULG0x0jHK6nC9++hPcebOa9U0yq7U/cSPpLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6Bd5zdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6Bd5zdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBB5C43390;
	Tue, 23 Jan 2024 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975306;
	bh=rtNRy6K9p9et3fzo3hAlcYC68+KBgiAUHZQ5ki0YBwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6Bd5zdQ6iPfZrKaO1qanD8yp1KvdnI0awKEAWxTsVJ2lNAZGIV8At+TW82+s4U7u
	 j970/KfyneGBVVyxYgs/mHWpZRX2OkVj4B4Y8eaFBjOqqgduOUPHyFtI2KaED0Yn74
	 pf2cfQG9uSUTFSrbCyVkqyVu1bc9wge5GgbqnKtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/583] media: bttv: add back vbi hack
Date: Mon, 22 Jan 2024 15:55:20 -0800
Message-ID: <20240122235820.231492705@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 3f1faa154a4316b1b585a25394697504b3c24e98 ]

The old (now removed) videobuf framework had an optional vbi hack where
the sequence number of the frame counter was copied in the last 4 bytes
of the buffer. This hack was active only for the read() interface
(so not for streaming I/O), and it was enabled by bttv. This allowed
applications that used read() for the VBI data to match it with the
corresponding video frame.

When bttv was converted to vb2 this hack was forgotten, but some old
applications rely on this.

So add this back, but this time in the bttv driver rather than in the
vb2 framework.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b7ec3212a73a ("media: bttv: convert to vb2")
Tested-by: Dr. David Alan Gilbert <dave@treblig.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 8e8c9dada67a..49a3dd70ec0f 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2772,6 +2772,27 @@ bttv_irq_wakeup_vbi(struct bttv *btv, struct bttv_buffer *wakeup,
 		return;
 	wakeup->vbuf.vb2_buf.timestamp = ktime_get_ns();
 	wakeup->vbuf.sequence = btv->field_count >> 1;
+
+	/*
+	 * Ugly hack for backwards compatibility.
+	 * Some applications expect that the last 4 bytes of
+	 * the VBI data contains the sequence number.
+	 *
+	 * This makes it possible to associate the VBI data
+	 * with the video frame if you use read() to get the
+	 * VBI data.
+	 */
+	if (vb2_fileio_is_active(wakeup->vbuf.vb2_buf.vb2_queue)) {
+		u32 *vaddr = vb2_plane_vaddr(&wakeup->vbuf.vb2_buf, 0);
+		unsigned long size =
+			vb2_get_plane_payload(&wakeup->vbuf.vb2_buf, 0) / 4;
+
+		if (vaddr && size) {
+			vaddr += size - 1;
+			*vaddr = wakeup->vbuf.sequence;
+		}
+	}
+
 	vb2_buffer_done(&wakeup->vbuf.vb2_buf, state);
 	if (btv->field_count == 0)
 		btor(BT848_INT_VSYNC, BT848_INT_MASK);
-- 
2.43.0



