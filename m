Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD653033F4;
	Wed, 28 Jan 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615828; cv=none; b=P+oEUgGGPOZAMNGuOZnejSfdUaEW8JFywWHvappw5jTHpDaKQPMQz66zyZ7R2kLOifqxvBBW3ozyLVJi90gYvW6Cn/yIPHRAxz1PS07eBnXkaij900laLTXJKyjSz0nC0QF4v0ES40JktNzLEkeisg85TDP5otwxkJAkGGO+CDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615828; c=relaxed/simple;
	bh=LiEn9A6x/zoY2nIP+7zjDVXCYMW8Qr++mNRUBGunfOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lF/yCuWpaIqsoC6BGccd+hLNjQbQamsTwx4lGMVHvvvqA5Mkok+cJdk7lOVnrZTqw44J+ulrJvmLil4YL4sdNHSpXp88pRagzmNtO8GBe2f5XxaPInSOQNZcdRPIkviuY8Dx62r9Vp3P7aANIzcwPG74tnSKW/7uu/d6dV7DGV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5KbMAUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5KbMAUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE89C4CEF1;
	Wed, 28 Jan 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615827;
	bh=LiEn9A6x/zoY2nIP+7zjDVXCYMW8Qr++mNRUBGunfOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5KbMAUBPFfgiwfjflesdo3UilfSXqvkGnYI5MsZvS4M0nRCLTqgtyATVjE4+RKyr
	 mjjAG1KGXJeT1cpZ27IXklP3MxhTwPejdhmYOQN7/vdpxTspTrqsiYI1kueqYCtYCn
	 it5y70D1iQgt1Lf+2DGYgVtcmmXgAcIUzB1gSTos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/227] selftests/ublk: fix error handling for starting device
Date: Wed, 28 Jan 2026 16:22:50 +0100
Message-ID: <20260128145348.961706113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 23e62cf75518825aac12e9a22bdc40f062428898 ]

Fix error handling in ublk_start_daemon() when start_dev fails:

1. Call ublk_ctrl_stop_dev() to cancel inflight uring_cmd before
   cleanup. Without this, the device deletion may hang waiting for
   I/O completion that will never happen.

2. Add fail_start label so that pthread_join() is called on the
   error path. This ensures proper thread cleanup when startup fails.

Fixes: 6aecda00b7d1 ("selftests: ublk: add kernel selftests for ublk")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/kublk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ublk/kublk.c b/tools/testing/selftests/ublk/kublk.c
index 0e863d13eaee4..9c05f046ad5ee 100644
--- a/tools/testing/selftests/ublk/kublk.c
+++ b/tools/testing/selftests/ublk/kublk.c
@@ -1002,7 +1002,9 @@ static int ublk_start_daemon(const struct dev_ctx *ctx, struct ublk_dev *dev)
 	}
 	if (ret < 0) {
 		ublk_err("%s: ublk_ctrl_start_dev failed: %d\n", __func__, ret);
-		goto fail;
+		/* stop device so that inflight uring_cmd can be cancelled */
+		ublk_ctrl_stop_dev(dev);
+		goto fail_start;
 	}
 
 	ublk_ctrl_get_info(dev);
@@ -1010,7 +1012,7 @@ static int ublk_start_daemon(const struct dev_ctx *ctx, struct ublk_dev *dev)
 		ublk_ctrl_dump(dev);
 	else
 		ublk_send_dev_event(ctx, dev, dev->dev_info.dev_id);
-
+fail_start:
 	/* wait until we are terminated */
 	for (i = 0; i < dev->nthreads; i++)
 		pthread_join(dev->threads[i].thread, &thread_ret);
-- 
2.51.0



