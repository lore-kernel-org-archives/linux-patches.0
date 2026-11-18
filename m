Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050717;
	b=NMn11ED8dfYiQPtBLGACoAalEhGHdMH/n6+NF/mYinmajH/RFnSsbtF4UHklW3UiyFWh
	 ygEF6Obdo6VvdOkRY8FbBazw2Xjwjs9EvdtROrqYGqQWjUtD1S7HsNYO9X3GtQLBsBl4G
	 4GtH24kCbWzToHmGFy1QTpSAnhpSAR/tai0dzZbQW4aromq0PW4IdDKtRmPrioCnYN9zK
	 muFU/BTt9ePh+LVygiYbb4b4wSjb+VDSX2KuZPxQu9ksRxDa2Pri0/gnRMLXv9CT5YovL
	 cOlQLK7epl6FVM3I5aaDAPrwQ4uIk1YXgqGYu/obkvZVf8M0gxpI3+5t/e7zZtttH7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ryIBuhJKd375HnPYQxfrRcVb6MHARpwoU17MSfYVvkE=;
	b=ggqclEfRD6kshOHUrVPhIkZeUWOLzOCjI0AFF0UGKAI2mK9jFtlm3dYDX+rt7oPs2ncO
	 Uk/Saa56Z3ttYuEd3457d7kUVGC2w7W2fwzUyhkWGbGBWGW1NtLI9Y0vHfsBF2615IpBz
	 DfijZhCtIhCeFBxVKZTV4XCPK926T0JX/5WG4upqr2P56sQxWyFSHGf8l3i3L74SmQTrp
	 FMjgFb2hztmH2wg0/nsB/RuEDTWNW7mUxL3uGVC+c4S1cKhJim5u50y0rU123s2PsdEVz
	 PYWYsb4mqcjW/XSZcFR/3XaUTq/65KTDDQl0ujsHgKp9j8gT39KT8uH2pfziq8bmfgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4iz1TS0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645FA606A32C;
	Thu, 19 Nov 2026 01:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4iz1TS0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21371F000C4;
	Thu, 19 Nov 2026 01:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050717;
	bh=ryIBuhJKd375HnPYQxfrRcVb6MHARpwoU17MSfYVvkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4iz1TS0gepOWdEZfXqySFitTs7aGZWZNCOtw0Hdqim3RrOJjOWpMGcAwblZeHQdq
	 iksTclrHssvLWSCeXtO1ssaXHageeofLGWDlzJp3Kk9K1pi6gUufg21qob8nTtT1mk
	 gIfkuWbRiq5dXHFU6PmRb2m3uFPduDIONQQFAsNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2808/2857] rnbd-srv: fix use-after-free on two CLOSE messages
Date: Wed, 18 Nov 2026 16:04:02 +0100
Message-ID: <20261118150342.705835899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 4912dab88baa5f7034dc9e38807804d470ae5438 ]

process_msg_close() looks the sess_dev up with a kref, drops it right
away, and only then takes the session mutex for the teardown. A session
has several connections handled by different workers, so two CLOSE
messages for the same ID both finish the lookup before either one tears
the sess_dev down, and the second one works on freed memory. Any host
that can open a device on the server can do that.

Take the mutex first and look the ID up with xa_load() under it. The
second CLOSE then finds nothing.

Fixes: 2de6c8de192b ("block/rnbd: server: main functionality")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-40-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 67108aeda467d..94e37655e7a53 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -344,14 +344,15 @@ static void process_msg_close(struct rnbd_srv_session *srv_sess,
 
 	trace_process_msg_close(srv_sess, close_msg);
 
-	sess_dev = rnbd_get_sess_dev(le32_to_cpu(close_msg->device_id),
-				      srv_sess);
-	if (IS_ERR(sess_dev))
-		return;
-
-	rnbd_put_sess_dev(sess_dev);
+	/*
+	 * Each teardown of a sess_dev runs under srv_sess->lock and erases the
+	 * ID, so an entry that is found under the lock is alive.
+	 */
 	mutex_lock(&srv_sess->lock);
-	rnbd_srv_destroy_dev_session_sysfs(sess_dev);
+	sess_dev = xa_load(&srv_sess->index_idr,
+			   le32_to_cpu(close_msg->device_id));
+	if (sess_dev)
+		rnbd_srv_destroy_dev_session_sysfs(sess_dev);
 	mutex_unlock(&srv_sess->lock);
 }
 
-- 
2.53.0



