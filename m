Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E52511E9F;
	Wed, 30 Sep 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786507; cv=none; b=jK/QlKHULsf9eCbq962G68QSNL2WqKv3YJokC4wxvLkOA4xQLe8aoaAvppKBoHVGwMAAYseNSVuJZTC/n1sAyaFBFHidUqJaVx0n3A1HEBJHLmspymKFBwBRB/ED8NMOr/5Z4esvscX3weDhN3XsYfFohWcHbQO6HKp0nRdiY2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786507; c=relaxed/simple;
	bh=JZ8USBSAfrW1Pj7uJGKvkm6DvjRj1zy2MLExrx/dxkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEdejitXwWD5S4Hi0ql/qRZJsipsCAZkwmezWpgNy5CRNkuGCsdSIUhK5zfDcIkl7OGiM+cG5T4Lvh5VFicqnxwzvCG5MSmopgxyBP29aatDrEoZu1UITNrO7wSSkfNjxt2wvVuopbE7jap6ff1zuouAtNN96qXrZtUKl4u0l/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjDD2YUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjDD2YUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0681F000FF;
	Wed, 30 Sep 2026 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786506;
	bh=d+FVvuTjJIXwfjzC063FW6VFcs71VEmVNS3a5zSrbRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HjDD2YUJpj0cu4sL6CDRjpL9d5GJ0kNUxoqH3tjmkLz52hMh6ICNolvSaIVWuhP9V
	 o5whQN9D6EjqoDQ3059O6dBjcSY2dgJSVPBCjZncoqRBA+k5rcqmpdMdcE39WPr9UD
	 h1TmdYKSsh5+RB+z+zFXNZw2KByvMy/fzMhsSr+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 887/982] nfc: pn533: fix OOB read in pn533_acr122_is_rx_frame_valid()
Date: Wed, 30 Sep 2026 17:27:03 +0200
Message-ID: <20260930152435.800131587@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit b61732f47316d45f27706db7812950145d3327b5 ]

frame->ccid.datalen is read directly from the USB response frame
and used, unchecked, as an index into frame->data[]. A malicious or
malfunctioning device can set this field to an arbitrary value,
causing the driver to read far outside the received buffer.

Bound ccid.datalen against the maximum possible ACR122 frame size
before using it. This replaces the existing datalen == 0 check,
since datalen < 2 already covers that case and additionally
rejects datalen == 1, which would still underflow the
"datalen - 2" offset used below.

Fixes: 9815c7cf22da ("NFC: pn533: Separate physical layer from the core implementation")
Reported-by: syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1853daab1a47603d4678
Tested-by: syzbot+1853daab1a47603d4678@syzkaller.appspotmail.com
Assisted-by: LLM
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260923035627.6210-1-kartikey406@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 0b7e3b118dfd4..986d5bae2177f 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -320,7 +320,9 @@ static bool pn533_acr122_is_rx_frame_valid(void *_frame, struct pn533 *dev)
 	if (frame->ccid.type != 0x83)
 		return false;
 
-	if (!frame->ccid.datalen)
+	if (frame->ccid.datalen < 2 ||
+	    frame->ccid.datalen > PN533_ACR122_FRAME_MAX_PAYLOAD_LEN +
+	    PN533_ACR122_RX_FRAME_TAIL_LEN)
 		return false;
 
 	if (frame->data[frame->ccid.datalen - 2] == 0x63)
-- 
2.53.0



