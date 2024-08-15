Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B3B17CA1D;
	Thu, 15 Aug 2024 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728535; cv=none; b=g8nM4lJtKKkn2eZnQv1L0x4WUsqKc1dua72gizbIKgQrVh2EU0prX7TeaKNKVG8CCI4SIUnI71lO4FATLJ1HCjwvYlSON3lPnLj3gIRmaMgslt2QNXIVwoeylZlkzyerQJHdagNM7dcsfxJmv662C5Tr3F+q0b8dRrFIMhEAK1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728535; c=relaxed/simple;
	bh=wslGucgzhkjIuJbEQOmva8PAuEImQmbZ6EfyvKGFJK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djVRWzhgWLN4Dad4UgGW2ysPImEYD439eLAoKr7GblHdZ7ZNAA3Az3v4224RgXWhkZIVSsMvQKyxIPApEi3DDrnfMWeZ80LQ1wST859bU8UMTerBs+2ALvyn1waqubU+fzwqPCuTSI219xw7fehivG6lpBluZKuSWBc+UhsctrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBjqwEjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBjqwEjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90586C32786;
	Thu, 15 Aug 2024 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728535;
	bh=wslGucgzhkjIuJbEQOmva8PAuEImQmbZ6EfyvKGFJK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBjqwEjVHCID2UEpxkcOi1nr+rao0+0IoVsP08IA5Uydwz5S1uW1DhzlcIVvRuOmu
	 DImoycQCL7L6NOd3frPjV+/Hb8seHKBNv1gA0o8fCNyXWloEAOuRGT3BS6lgvmKija
	 eSoRX3E7iYgC+KyxGTXq6J8KTG8YMNdsa8weCGNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/196] media: imon: Fix race getting ictx->lock
Date: Thu, 15 Aug 2024 15:22:27 +0200
Message-ID: <20240815131853.239600449@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 24147897507cd3a7d63745d1518a638bf4132238 ]

Lets fix a race between mutex_is_lock() and mutex_lock().

<-mutex is not locked
if (!mutex_is_locked(&ictx->lock)) {
	unlock = true; <- mutex is locked externaly
	mutex_lock(&ictx->lock);
}

Let's use mutex_trylock() that does mutex_is_lock() and mutex_lock()
atomically.

Fix the following cocci warning:
drivers/media/rc/imon.c:1167:1-7: preceding lock on line 1153

Fixes: 23ef710e1a6c ("[media] imon: add conditional locking in change_protocol")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 99bb7380ee0e5..c78e1a4a10ec5 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1126,10 +1126,7 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 
 	memcpy(ictx->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
 
-	if (!mutex_is_locked(&ictx->lock)) {
-		unlock = true;
-		mutex_lock(&ictx->lock);
-	}
+	unlock = mutex_trylock(&ictx->lock);
 
 	retval = send_packet(ictx);
 	if (retval)
-- 
2.43.0



