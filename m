Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F7A26B0B8;
	Thu, 13 Feb 2025 15:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459889; cv=none; b=Zsm1KB1wumpyAGJTfud58t1rk4Sre+lAXf+yV8Mft75J/jVhmxJ+QZrA4/JnyZsjdCZI+pyfjWzb0hVGRTWS6xAe+lxQCiSVuxrT8fPhHvgeY69gI9+QrWn0+oCquZn1r+ZkayRDCuPVijdfwnfaP9MfRM8q0qh/XgKTrm4NDBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459889; c=relaxed/simple;
	bh=YAlDjeP/vdJr9yhoAQrXmbMxd34F4WdTKq8UIuiUYF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVNdGOmOo+zKPvd+yT78NFfDJqRdtdN5vruPDVi/NmrEzDu68l3ibpEetAPEyUNPSvrL98j9uXHaAgS+e3QYF4j3FvUueC04QgB9+NLRaGKb3rLfQAwEKRCfp8Fd4kZ+8ytR+dIKkVk2YKfruuux2+eFFiZE6GwfHkLSKNjMMrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wp7lk8mK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wp7lk8mK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FF8C4CED1;
	Thu, 13 Feb 2025 15:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459889;
	bh=YAlDjeP/vdJr9yhoAQrXmbMxd34F4WdTKq8UIuiUYF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wp7lk8mKDrfx45x9H6IU1mOCbiw8FTZt9VqTeeLH06MquxlG7UTgFw7HF0qQu3PMK
	 06s9gr8LSor4Sf4A7M3tQS2VWw8mAcC4H0hIM9Whkr6ttnpf/d9E87rVKY/4R8VWDO
	 7GYRyjbTxyY9XPJE5bEQ995Ah9GpT5ZYB63aPu/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 394/443] io_uring: fix multishots with selected buffers
Date: Thu, 13 Feb 2025 15:29:19 +0100
Message-ID: <20250213142455.812755368@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit d63b0e8a628e62ca85a0f7915230186bb92f8bb4 upstream.

We do io_kbuf_recycle() when arming a poll but every iteration of a
multishot can grab more buffers, which is why we need to flush the kbuf
ring state before continuing with waiting.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -315,8 +315,10 @@ void io_poll_task_func(struct io_kiocb *
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
+		io_kbuf_recycle(req, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
+		io_kbuf_recycle(req, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}


