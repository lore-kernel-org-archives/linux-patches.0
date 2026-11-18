Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033186;
	b=KXFiIetngjrqK26XrEnOlp8DdLEgp4UeOAzssLzwFCEqs5IZnXIzQ+FwHGwhy+eQSNEP
	 ZkIX/8hi9URMseyrs1+DLo2GHndkcCoksJ8RWw9b2wHJ8GzEGSCScZ5Gpc09JFuHUuP+8
	 RDp/DA8FhBLeX6QyAOef6+ymDbIUjGtdGRrFDrg7gMQh8srU+I+aLhSrqumUCFi6pqwzm
	 O12fGfN45AVXYRQK7LPkwDYXCrcDARb1KwGKNHDKQDFBMgxtjAMTk8ZcMCSmWQ/gy51Mn
	 vZGgpV8PQeywocG3b+5CNnXEydlPnK2cOJNW7B/gqRPyPR/usQht4kL0MRIZVTvxnnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dGZVDg42uVtB7vORk0p7ULD2J9FbqOcmEpfx8pEFHFs=;
	b=CGtrXNBhIYAeDqag+CH/CbvxGbdJowUEQpXxcKNXLdfmGizaG1FVsBqIe0vjZ2ixf+a6
	 hUHOs58UTWYCcPyVFvwzCrJAtDr0AGrH+xZTyZKcAxVwZ7Gh0Efx7nu96Rm08OrbdMyDD
	 Shtt1AieSoqAyJ9aE7FJxet9i8cT3J1KzpxRazfoCUAxYWwRjepwKni2tTo9YbEDGbFF6
	 nGsxqm/8xkk1BgnRRGxmicPHSz6oBn8vDBZQRCHf8BLq11WzgEE2HsdscbATn6PdLkY/Y
	 zJbfbj4+4rfh0rsfnCpdPF2xBavMJ4zl1HSHMSnLBJhR/gdtD+vgm4jXaXwZhPRH1aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouTnkVAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44325606A332;
	Wed, 18 Nov 2026 20:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ouTnkVAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7801F000C4;
	Wed, 18 Nov 2026 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033185;
	bh=dGZVDg42uVtB7vORk0p7ULD2J9FbqOcmEpfx8pEFHFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouTnkVAfy0XS7FdRKpJKwLP+pF/RSBFVojdmyqGuAfiK4Q4tRC4K4S3gjzUvI369A
	 MAcu0EDZ1ysWr1ND6vZzROKXZq+Ln3jzPv/t5LUlD1UYMQ57Qz7rI+9p9nPLDJbjkH
	 FR/wIg7tyb/khwkUiHTgXmERyXz8wQxC8aWpmhyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1677/1756] drbd: stop the start_resync timer of a dying device
Date: Wed, 18 Nov 2026 16:03:24 +0100
Message-ID: <20261118150116.470674545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a439d3fe3ec2bfe0b4ccb77973ae97949bcf46ec ]

start_resync_timer gets armed for up to a second and nothing ever
deletes it, so drbd_destroy_device() can free the device with the timer
pending. Shut it down where request_timer is shut down.

Fixes: 370a43e7982d ("drbd: Work on the Ahead -> SyncSource transition")
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261028164415.1262013-13-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8c5a7bcfa82b2..23b771c0260c6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2183,6 +2183,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
 	timer_shutdown_sync(&device->request_timer);
+	timer_shutdown_sync(&device->start_resync_timer);
 
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt == 0);
-- 
2.53.0



