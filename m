Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F023876BA;
	Sat, 17 Oct 2026 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254527; cv=none; b=SWKsTgIDAK+JRImtr5Ci8Q92khfXHJLyufBJW+w15S46ybESK4db1JH3ZKNllO8MKeNIOosCVqUlIHqW9cbc9kFI4V9rlO6g9HxNeBugOBIB/mFxJMUo2DNZ8jmkOs3DCc5F1u0ffakwlZ6qO5YRZx8peW9ue6THDEU7GxF0Etc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254527; c=relaxed/simple;
	bh=oEff2vhJ76/up0l+c4d6rjYgUiYr9stRO7ahL+a+qIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le1z8xfbbfffPT/rnBkiFH7/6d+28wXLhzbKcY8IXkfwau6XcYaRmgvUEocQXH9KHYY1smGX0zTsdwGhtUL3tyBaU5H+Agx/XSp/aLn0Xbv8NSCBasqhUViqeRONdSKHfSK3avg3VLtf4L45Eq3K7o8K4/Kwm0ZiGGbnlCfp0+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWA13QBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWA13QBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183411F000C4;
	Sat, 17 Oct 2026 16:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254525;
	bh=YKNR/kk3M/uS2G0TotmG8jzCt1+hGZqwk9As39rltPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWA13QBCVLKw3DgcjpwdQ5gOBJhMBM+2R3DvhNUzbzrgV64Nd5bK6npg0/m8vwCQc
	 //LlKP43cVnya2e5twtR/7wvmN5qRrMxrYou19rYRS1Um5vJ05GM2wdRyCws5Rd6h0
	 lvjDdH9XU5wAq2c21QEWBjBO1rSXjLwAwRgoEK2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 477/869] nvmet-tcp: check return value of nvmet_tcp_set_queue_sock
Date: Sat, 17 Oct 2026 17:55:18 +0200
Message-ID: <20261017160049.354485401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 7ef789703e2b91775dcb36b2efa46325be31a2a0 ]

The return value of nvmet_tcp_set_queue_sock() is currently ignored in
nvmet_tcp_tls_handshake_done(). If it fails (e.g., due to the socket
not being in TCP_ESTABLISHED state), the socket callbacks will not be
properly set, leading to queue and socket leakage.

Fix this by capturing the return value and calling
nvmet_tcp_schedule_release_queue() on failure to ensure proper cleanup.

Fixes: 675b453e0241 ("nvmet-tcp: enable TLS handshake upcall")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 5509737bb4cb9..fcb1a3dbff011 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1906,10 +1906,12 @@ static void nvmet_tcp_tls_handshake_done(void *data, int status,
 	spin_unlock_bh(&queue->state_lock);
 
 	cancel_delayed_work_sync(&queue->tls_handshake_tmo_work);
+
+	if (!status)
+		status = nvmet_tcp_set_queue_sock(queue);
+
 	if (status)
 		nvmet_tcp_schedule_release_queue(queue);
-	else
-		nvmet_tcp_set_queue_sock(queue);
 	kref_put(&queue->kref, nvmet_tcp_release_queue);
 }
 
-- 
2.53.0



