Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180D443B6E7;
	Mon, 17 Aug 2026 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976973; cv=none; b=dAgkpAkQPiOHeIwlxAL7MMNwNyTVU9rtVSLzqS5yr8n3UaxdkO7zWDPe8TtvI0pOjS3/9+vtY3h0P8FUWWHrVHoJjA18sob5aYOeWOei7RCzuxmH3oHYrZ7ZxcMNRtoYs2jGyG4Vj+tG/jk5QtJsobcwEqX3t6RSSvlsG64SWss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976973; c=relaxed/simple;
	bh=/veHbdzBw/ibSVTKFN0S+cKHVhChy1IyTfcZDbYDxCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z753BrEf3/qmJbNs6J+dcVG3yG1Vj9s1eN2vCvsJskS8PQLobajhDixttrxY+gAMAXD9lEeyH2JXXJicwxp4FYnFW0ESCIN3J0aKt0z5ziQYyZTz3EB440Bt6bPpTRZ7B8C/WqbRdq+DWV793lJhjUh6u9mEBdhHiWX0zfhpSh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+Z0Dwod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+Z0Dwod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1604D1F000E9;
	Mon, 17 Aug 2026 14:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976971;
	bh=h9RhzMfrus6jZS79gck1gYqdagQdggPGT3wlW6fOt4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+Z0DwodCJgrA1tiosAH+eNabjsVZclxYRslEhbumDt3aT6vD/KBIWuUIrlsUEx60
	 zkSf8MwXcjbi5XeiaScCQuoprSfy41v5ozerCQh9Jty86srzXFaysPlaQUpebMWUK3
	 PPIxpscBAYHAHQDjU9WbgY762bDcMYusTafZccTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+019ced393ab913002b75@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 168/456] media: rtl2832: fix use-after-free in rtl2832_remove()
Date: Mon, 17 Aug 2026 15:29:18 +0200
Message-ID: <20260817132546.676781032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 680daf40a82d483949f87f0d8f98639dc47e610c upstream.

cancel_delayed_work_sync() is called before i2c_mux_del_adapters()
in rtl2832_remove(). While the cancel waits for any running instance
of i2c_gate_work to finish, it does not prevent the timer from being
rescheduled by a concurrent thread.

During probe, the r820t_attach() call attempts I2C transfers through
the mux adapter. These transfers go through i2c_mux_master_xfer(),
which calls rtl2832_deselect() after the transfer completes,
rescheduling i2c_gate_work via schedule_delayed_work(). If this
transfer is still in flight when rtl2832_remove() runs,
rtl2832_deselect() can reschedule i2c_gate_work after it has been
cancelled, causing a use-after-free when kfree(dev) is called.

Fix this by calling i2c_mux_del_adapters() before
cancel_delayed_work_sync(). Once the mux adapter is unregistered, no
new I2C transfers can go through it, so rtl2832_deselect() can no
longer reschedule i2c_gate_work. The subsequent
cancel_delayed_work_sync() is then guaranteed to be final.

Fixes: cddcc40b1b15 ("[media] rtl2832: convert to use an explicit i2c mux core")
Cc: stable@vger.kernel.org
Reported-by: syzbot+019ced393ab913002b75@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=019ced393ab913002b75
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/rtl2832.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1116,10 +1116,10 @@ static int rtl2832_remove(struct i2c_cli
 
 	dev_dbg(&client->dev, "\n");
 
-	cancel_delayed_work_sync(&dev->i2c_gate_work);
-
 	i2c_mux_del_adapters(dev->muxc);
 
+	cancel_delayed_work_sync(&dev->i2c_gate_work);
+
 	regmap_exit(dev->regmap);
 
 	kfree(dev);


