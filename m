Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61926224F6;
	Mon, 23 Jun 2025 21:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714206; cv=none; b=gtCefR8I3z9IQ89bRlPXA+SDW2aSxIvAM98KGBDxiIeet0g0etabAEAJ7akzTq2Ys/8FqUhDWn9xKa5kFa+BY/uiiKDBcjiKsVIj9hYe4buYJpgmwOennh0hDyYBWEwqxY7XL0WRkzNB1nGMecixJWdH4oMbXOYXs80o3TeVPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714206; c=relaxed/simple;
	bh=+2G/3u60qxZqxbCp3EaKWq0gOeg4SR/lbcNpA7UShHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjIFMqRYb20uYfCXmcZ9KwMheUaBgPaebfum1HgdqTUwb9P3JoFpvPi/wjj8zD/DoBC+HCzK7gn7n+96ld8IpDAzCpnUExluFqBTkDGuAgUHo8oSvZdyrh51jFnEid8SOgW+xtCsGmj8klgjzttyov3t4bAMwGlXDA5YuwxzoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaIDTHNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaIDTHNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3BFC4CEEA;
	Mon, 23 Jun 2025 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714206;
	bh=+2G/3u60qxZqxbCp3EaKWq0gOeg4SR/lbcNpA7UShHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaIDTHNJVUJPePWsl4vQCxsa4DtJpv+bLjGFZxFYcv1+Tk/7Y8/w+H+ojCEymgaCO
	 uOxNYb/BhZivWIJJVuPLEVYR1LpFpMJ9RW/zIkHrdS6/T+MLIWWn7CUufkdXF2d0eE
	 n20p90XIY8KpRy8iDPTd1fPBFHa74G3OqbpuBmqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Malat <oss@malat.biz>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 143/290] sctp: Do not wake readers in __sctp_write_space()
Date: Mon, 23 Jun 2025 15:06:44 +0200
Message-ID: <20250623130631.201437575@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b84c5e0a76f52..adc04e88f349f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9094,7 +9094,8 @@ static void __sctp_write_space(struct sctp_association *asoc)
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



