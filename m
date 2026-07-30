Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123482E9EC7;
	Thu, 30 Jul 2026 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427677; cv=none; b=rCPboTaokVwudRq6ff7xyvb1r6NOaWmbigs2qtlJmBuAPiebWCa3jFukOWrD1V/ci66hOrdA0s7NB+0snV/TE6IZuAsXflBWuIJD1rk06SIsSdKIpQ84hgnlFCIWlqK/9eHjB0KdXCOYmaxM7Sec14MaORDxeoytGUk8MeRiGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427677; c=relaxed/simple;
	bh=uElTMxK9L7I1usTQ9vQYMIHzaSaq00blCSfFhO356Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJU+neW04fHpn0t7Cp6sRb8D+CPoebWm5lJWQb3WYQaV5h7SnuXrwK5My3/y+Si7R1jyC3zQCF//YLM9Zu67qwapxox2j85NEy25Idus4UAc6V0yQgXoIgzSVimgudTqlj16gFnp+B1MgHak9zKX8QXYK0wtYypIK0l2xBiWml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DU+C7USf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DU+C7USf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFAC1F000E9;
	Thu, 30 Jul 2026 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427675;
	bh=Ex35zQ9K+haFbUKCCEzBGSvpS1v0/4pbr0thzLvX72c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DU+C7USf5Y6fmuyWAHtkYY22h2+A4XLMBLPJioUk3gGLVyDnL4dYmzYHCt+OXI0Fa
	 yY4YHBAwhqNDEQFqDk+92s0l9v2gFyr5/WTTpdN44Jxs0sBl9CKom7b8IER+eIP/V2
	 Yn1oFLjyA0ZB8XfWZ5UW+sx+6xRXy5QOPm0EoXjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+019ced393ab913002b75@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 254/484] media: rtl2832: fix use-after-free in rtl2832_remove()
Date: Thu, 30 Jul 2026 16:12:31 +0200
Message-ID: <20260730141429.008251876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -1115,10 +1115,10 @@ static void rtl2832_remove(struct i2c_cl
 
 	dev_dbg(&client->dev, "\n");
 
-	cancel_delayed_work_sync(&dev->i2c_gate_work);
-
 	i2c_mux_del_adapters(dev->muxc);
 
+	cancel_delayed_work_sync(&dev->i2c_gate_work);
+
 	regmap_exit(dev->regmap);
 
 	kfree(dev);


