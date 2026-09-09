Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0492D9780;
	Wed,  9 Sep 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962638; cv=none; b=iErtO4Ubnk9kFU/QsLbTz+ck0wvtvXsUCwkQdlvl/emT8T7b6LHH+FBwhg1nu37MaT8emS7TBizFXh4NSNMvwUpV+ncbISRh9p4SlwzJFPI7u1o7/KlH1/YH3nd0/SUydHezPu2Pdh/BQLYpQdGCAMUhpegFd52/G6j1nL5rgFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962638; c=relaxed/simple;
	bh=vn7cGIjHz0y0SUuusSdM7bfE+mbKAIvFwn4XcH0uKjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeC8cKhPw0HN33JVieowDMt+bTEywottnawt0oRRbVZ4/0uRycbSPY/l0x7yT3qKNIO0bT0z+9ggjvoywXqTIaU3dThtNuwJaU7CQ9rB2ea1iHncRTMpX+AL8pzKsYQBhohuEtcxES7/x92XvXxKZo5pbmPjUV5KdQEEDIiAeAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsO02I5m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsO02I5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5AC1F00A3A;
	Wed,  9 Sep 2026 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962636;
	bh=NIglfsogUnhwVbJ43aVLoDAhG1wimKl79Bu3soTzOYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsO02I5mcRhCm6cWR2Oo2Mla3kYXHxfb0/TKir2XMH8GD64iwlm98YI+VDMKM9Rbl
	 GglayuS5n6da9rMjzS7TmakNdmX2qJFyg3CoWySuxy3hEcuuslfa9bq/E155qhoLXk
	 XMyahrB2R9acQFqwEk7iMJDchzCjpFzDdjsTlRYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 360/556] media: em28xx: fix use-after-free of dev_next->devlist on disconnect
Date: Wed,  9 Sep 2026 15:40:40 +0200
Message-ID: <20260909134243.332644165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangong.Han <jiangong.han@windriver.com>

commit 826915b6b65e2d3251e7248ea54289a22d748c84 upstream.

When a device with has_dual_ts=1 is probed and the is_audio_only path
is taken, both dev and dev->dev_next are added to the global
em28xx_devlist via em28xx_init_extension(). However, during disconnect,
em28xx_close_extension(dev) only calls list_del(&dev->devlist), leaving
dev->dev_next->devlist still linked in the global list. When dev_next is
subsequently freed via kref_put(), its devlist entry becomes a dangling
pointer in em28xx_devlist. The next device probe that calls
em28xx_init_extension() triggers a list corruption BUG when list_add_tail
detects the freed node.

This bug was exposed by commit a368ecde8a50 ("USB: core: Fix duplicate
endpoint bug by clearing reserved bits in the descriptor") which clears
reserved bits in bEndpointAddress during endpoint parsing. This causes
fuzzed endpoint addresses like 0xf3 to be normalized to 0x83, which
em28xx interprets as a vendor audio endpoint, enabling the
is_audio_only + has_dual_ts code path that was previously unreachable
with such descriptors.

Fix this by removing dev->dev_next->devlist from the global list in
em28xx_close_extension() before the device is freed.

Fixes: f410b4093fdd ("media: em28xx: split up em28xx_dvb_init to reduce stack size")
Cc: stable@vger.kernel.org
Reported-by: syzbot+99d6c66dbbc484f50e1c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=99d6c66dbbc484f50e1c
Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1265,6 +1265,8 @@ void em28xx_close_extension(struct em28x
 			ops->fini(dev);
 		}
 	}
+	if (dev->dev_next)
+		list_del(&dev->dev_next->devlist);
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
 }


