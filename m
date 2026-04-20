Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128E1331A78;
	Mon, 20 Apr 2026 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700530; cv=none; b=Q76jjw+hukW2m+jq1vGn66tsU/fGvAZmHRsDtk2IIDVKKAxany5w2c9TAHThYam1cTPou6zoxxbCzL1T77mc2RxYIu1YryKqjstLofJyHkQy6xx+YvN7n+rWifk7wWGbw7Y/TXVq5ERI1MusDPSBRMSh+dLzWQT0uonD31xArRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700530; c=relaxed/simple;
	bh=eWQ4UXLi4u01tyZs9q5sbraW0xzA/UaAMLhj3hpWhjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/0fB8KwnCkmmSK64eoJNKvuA4Qon3xwEn/iD480b76LTtKWhzdPHR2rhTp5enKbHbtbQxNWsQ2ZsYStE+NTQB5ZDN+oeI6p9MQaPwHKq21womVvuzAllRSmltuOHEEuYajXYSKJz3SGVlzZZSIuuX1fLlKG8sAACdZtqxVKdOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDnlQZ+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDnlQZ+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7BBC19425;
	Mon, 20 Apr 2026 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700530;
	bh=eWQ4UXLi4u01tyZs9q5sbraW0xzA/UaAMLhj3hpWhjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDnlQZ+rsL0hXjSIYvqxR8PXqwpCfKCYGepFoWoysVmqW5fUDSfIE79JWDHbRb3he
	 4S2MgjJQ7AEWfFFfNzy1cNHvrcff0lH4tmk+92rNSBPARz8Kp1iuhX7U01Jo2Uvxoq
	 V3/+yDrPyZAUemqz7GIhEVXcmnoegFhBpMqkOseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639ebc6ec75e96674741@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.19 207/220] media: vidtv: fix nfeeds state corruption on start_streaming failure
Date: Mon, 20 Apr 2026 17:42:28 +0200
Message-ID: <20260420153941.481858944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Valiyev <linuxoid@gmail.com>

commit a0e5a598fe9a4612b852406b51153b881592aede upstream.

syzbot reported a memory leak in vidtv_psi_service_desc_init [1].

When vidtv_start_streaming() fails inside vidtv_start_feed(), the
nfeeds counter is left incremented even though no feed was actually
started. This corrupts the driver state: subsequent start_feed calls
see nfeeds > 1 and skip starting the mux, while stop_feed calls
eventually try to stop a non-existent stream.

This state corruption can also lead to memory leaks, since the mux
and channel resources may be partially allocated during a failed
start_streaming but never cleaned up, as the stop path finds
dvb->streaming == false and returns early.

Fix by decrementing nfeeds back when start_streaming fails, keeping
the counter in sync with the actual number of active feeds.

[1]
BUG: memory leak
unreferenced object 0xffff888145b50820 (size 32):
 comm "syz.0.17", pid 6068, jiffies 4294944486
 backtrace (crc 90a0c7d4):
  vidtv_psi_service_desc_init+0x74/0x1b0 drivers/media/test-drivers/vidtv/vidtv_psi.c:288
  vidtv_channel_s302m_init+0xb1/0x2a0 drivers/media/test-drivers/vidtv/vidtv_channel.c:83
  vidtv_channels_init+0x1b/0x40 drivers/media/test-drivers/vidtv/vidtv_channel.c:524
  vidtv_mux_init+0x516/0xbe0 drivers/media/test-drivers/vidtv/vidtv_mux.c:518
  vidtv_start_streaming drivers/media/test-drivers/vidtv/vidtv_bridge.c:194 [inline]
  vidtv_start_feed+0x33e/0x4d0 drivers/media/test-drivers/vidtv/vidtv_bridge.c:239

Fixes: f90cf6079bf67 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+639ebc6ec75e96674741@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=639ebc6ec75e96674741
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -237,8 +237,10 @@ static int vidtv_start_feed(struct dvb_d
 
 	if (dvb->nfeeds == 1) {
 		ret = vidtv_start_streaming(dvb);
-		if (ret < 0)
+		if (ret < 0) {
+			dvb->nfeeds--;
 			rc = ret;
+		}
 	}
 
 	mutex_unlock(&dvb->feed_lock);


