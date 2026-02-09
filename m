Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BA337AA71;
	Mon,  9 Feb 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647900; cv=none; b=AqpCOj0CUg6zbwJ6dSIn+H7S1GzS2brLtrEzKBBdWqd2UXSgWzUR1Kya+avBWOp7tVlxoZQ1ChlswodPqAFXG6aOAl1KnAOOAsv5z1tIyBsqUUkfxpY3/cTuL4lR8cSffl5/KRn/8jSKJ5wjFxiWGy1pWr8IEd3vAqG1lv5s3eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647900; c=relaxed/simple;
	bh=uulszALGmGCN+bC0fUJJLY9l4sZ39UymApA+RpknNq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arGWOZNCUOafEn7hOoJ+aBh+YCkmsNfR0i2G4MXZrvzA4Of9uiSVN25nCQA0lrAHXtvMHIoY9UrGzCCaHWAqu4bxOdEggykQWz/cV/QXbsOFaBe8Ej9ktUlhhLucyTdgumgZTQXY8xPB+PiQYBHm5V+pTQQObHe6EdPxKwZA26w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hY0EP0fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hY0EP0fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5E2C116C6;
	Mon,  9 Feb 2026 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647900;
	bh=uulszALGmGCN+bC0fUJJLY9l4sZ39UymApA+RpknNq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hY0EP0fsKdYVT1aEsBK/HRdqSmETMUQwwIMGaqD/MEyKc/7B0TvcGW1UaJMwJOYfe
	 GYFj7v1aqBm4lAacphWSW3v03mU78m+INAd9Yetw+OjqIyTp4tH9khS6HF7gJYBlfn
	 7ljgQYWzz1gT6c16T0NMbULyHFktpDqRMjUYzhUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/113] nvmet-tcp: fixup hang in nvmet_tcp_listen_data_ready()
Date: Mon,  9 Feb 2026 15:23:29 +0100
Message-ID: <20260209142312.353315248@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 2fa8961d3a6a1c2395d8d560ffed2c782681bade ]

When the socket is closed while in TCP_LISTEN a callback is run to
flush all outstanding packets, which in turns calls
nvmet_tcp_listen_data_ready() with the sk_callback_lock held.
So we need to check if we are in TCP_LISTEN before attempting
to get the sk_callback_lock() to avoid a deadlock.

Link: https://lore.kernel.org/linux-nvme/CAHj4cs-zu7eVB78yUpFjVe2UqMWFkLk8p+DaS3qj+uiGCXBAoA@mail.gmail.com/
Tested-by:  Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index c1cc8ed090bfd..0ca261cb1823c 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -2033,14 +2033,13 @@ static void nvmet_tcp_listen_data_ready(struct sock *sk)
 
 	trace_sk_data_ready(sk);
 
+	if (sk->sk_state != TCP_LISTEN)
+		return;
+
 	read_lock_bh(&sk->sk_callback_lock);
 	port = sk->sk_user_data;
-	if (!port)
-		goto out;
-
-	if (sk->sk_state == TCP_LISTEN)
+	if (port)
 		queue_work(nvmet_wq, &port->accept_work);
-out:
 	read_unlock_bh(&sk->sk_callback_lock);
 }
 
-- 
2.51.0



