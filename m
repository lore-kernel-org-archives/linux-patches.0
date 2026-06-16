Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDC338C437;
	Tue, 16 Jun 2026 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635259; cv=none; b=HHe1JRYnOq4teZeyelStXqAM9LpZ4HetQBRV8CEbH5yH+FkA2ij9Ot7u0WkN8mlIu5Tqzeavglf0Nihf5W8mh0Fe8nPjbfMySckbHo4iPePctERdeoMIkk1rf04wySDcaU6KNNi4dl/lPuneGRmhxyljsKPJjARGDIxz22zfFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635259; c=relaxed/simple;
	bh=YU+fxeCRKBzqeoXOaEDIyPvzyFi+vFPmU3zbBx/imfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+0kAZd7Apd0puYTw7u+A35vS2BP+6/7dpu/1ILF6p1Er11Qik0RrYS0lOr01NYDA8Jqn0xWtfhWzfmqgiEm50gHxP10Xdq6i2rQe797m/cn0nlWTP2WRwwqVokILd3ZhoCCDPkXKKlMWeuzKGgS7yKALg1h3qyI5OV8pxL3YX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Evn8PhMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Evn8PhMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0998B1F000E9;
	Tue, 16 Jun 2026 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635258;
	bh=io2oVdJk4NLnIFooRyf73HNIlRnUloYVwmyGBECLDMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Evn8PhMWK7QZDPfrcsvIOZv1X9salFYWUZjkjEtqbVXueP+ZQ4/ant8ldjMaxo6hJ
	 h5qB7shaIbrMylsrEMiQ8CZbF3r80XQGywMlYRbn8GwbBOZbMGhwWh9mQezV4wxNfT
	 OyyTucVJAzhJGhMu2ueX7QGRRRVRQ6WRmeDmwStg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/342] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Tue, 16 Jun 2026 20:25:03 +0530
Message-ID: <20260616145048.667084073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit f4268b466190dae95a7585f69b4f1f8ad097632c ]

llcp_sock_release() unconditionally unlinks the socket from the local
sockets list.  However, if the socket is still in connecting state, it
is on the connecting list.

Fix this by checking the socket state and unlinking from the correct list.

Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://patch.msgid.link/20260429134115.3558604-1-lee@kernel.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index dc96d751eb278f..57dea580c02912 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -628,6 +628,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	if (sock->type == SOCK_RAW)
 		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	else
 		nfc_llcp_sock_unlink(&local->sockets, sk);
 
-- 
2.53.0



