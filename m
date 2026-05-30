Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0481726F288;
	Sat, 30 May 2026 16:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159524; cv=none; b=V06vT3iyRJJmPyn8+2zfO+JnrCe8CKDYciVctHKmTbrRzufrD8fBKYbgz1CZrCuT4EfVRX9IwunD1l1Y+dXfYNZY11+COgOeP4cYZ+iqiBqlzZsXvPbmNsS29SshcRGqTXBvywbyjqtlrCX85KMoOa9UlisatzmJUUrGLfNFnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159524; c=relaxed/simple;
	bh=bzkT/7dAklLoEBUs7gws91C9i3pVRca+cDIpdUNSKjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PD23GAKelZ/CuCYuAYjCd2M8AIaNxnqgbFFZt+XTrxMFRlzXFojwsHIhuwCSa9r/5MILOTMu79cVfXdgUFx2+B10KtRkp7dqHk1vqFUlz2L6b0kDFZs0yqNjhWUm159uiRkmUK//RhSR4OroQQPBIJMXydVBlJK0MG447oJdlcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jpw0DINe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jpw0DINe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E07A1F00893;
	Sat, 30 May 2026 16:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159522;
	bh=wCunCpVIVbiLuXPcu80EPg6Tsrc09lbLxmzhcFOh8PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jpw0DINeuERYE38BTglQBzHM0DZQ/2CELH9RVwsTy4PK9zlw7P0WetyrvsVDOOXFI
	 Xi/kr+0at49wLjrxmsPW1LFbYDBh8+D5f7tyBhAyOcDJv+J7614B4xETzZonC7C22h
	 lEIIQImGM35l+9UQO8EE1uHsCd8aFEvU/B/gP8so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639ebc6ec75e96674741@syzkaller.appspotmail.com,
	Ruslan Valiyev <linuxoid@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 101/969] media: vidtv: fix nfeeds state corruption on start_streaming failure
Date: Sat, 30 May 2026 17:53:45 +0200
Message-ID: <20260530160303.116463010@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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


