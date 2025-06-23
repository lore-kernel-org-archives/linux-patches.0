Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A15223DE8;
	Mon, 23 Jun 2025 22:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717284; cv=none; b=PzAZ5hpNj0MmcaT2jz0zGpFzX53fGEFJvg1IxgpJ2vvVM8b70ZMJa05T+ow6f3gf8BmNgYoL9PkwAwEja5mhh2Rb5Lzo+VwGn6+2jE2IxadJ8C9Tnjw0AM8gAr+jXzE9vhw15OiMH54lhnarn+2ZU8skTAyLT9tPuEGAXhlWa/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717284; c=relaxed/simple;
	bh=9IQ3ZQ/lUwzOsa1XJezwXL35drh9RoPaho2A12z+2OA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkOpR7H1TEBddDraIqmtCrcNKaArbBYWrZhwrkHUfzJBTRGls03NRbM/HehM1jwDECO2V7tOuhlKCV24dH6y4U2ocG2zN4RaEqzDh4IN8w7oxHCEOjb6+xD97ziKk/sVucwJUVP9lGQU6obGkivnqPulx2rwi8o3hFOvxLI0VCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZlhZdF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZlhZdF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C605C4CEEA;
	Mon, 23 Jun 2025 22:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717284;
	bh=9IQ3ZQ/lUwzOsa1XJezwXL35drh9RoPaho2A12z+2OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZlhZdF9VcNi5URI8+YPId3EfFyzpZLFU2Hue7v+p4w3NbEq4h/r1TNY2Pt+RIBSX
	 iY/V+PlqfdWwhBhFsUhgGdjuT+9vsHL7MEbz8qHdKARLLK/GDJgOk0SroV6vohfwAe
	 izxY9fjgEsfDS+Xy4XcBlsIvLWGAbVVTSzTZNBR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 395/508] sctp: Do not wake readers in __sctp_write_space()
Date: Mon, 23 Jun 2025 15:07:20 +0200
Message-ID: <20250623130654.983405122@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Malat <oss@malat.biz>

[ Upstream commit af295892a7abbf05a3c2ba7abc4d81bb448623d6 ]

Function __sctp_write_space() doesn't set poll key, which leads to
ep_poll_callback() waking up all waiters, not only these waiting
for the socket being writable. Set the key properly using
wake_up_interruptible_poll(), which is preferred over the sync
variant, as writers are not woken up before at least half of the
queue is available. Also, TCP does the same.

Signed-off-by: Petr Malat <oss@malat.biz>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20250516081727.1361451-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 65162d67c3a3c..8a8a5cf8d8e65 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9089,7 +9089,8 @@ static void __sctp_write_space(struct sctp_association *asoc)
 		wq = rcu_dereference(sk->sk_wq);
 		if (wq) {
 			if (waitqueue_active(&wq->wait))
-				wake_up_interruptible(&wq->wait);
+				wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
+						EPOLLWRNORM | EPOLLWRBAND);
 
 			/* Note that we try to include the Async I/O support
 			 * here by modeling from the current TCP/UDP code.
-- 
2.39.5



