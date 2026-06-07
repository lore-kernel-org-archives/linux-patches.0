Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75441308F0A;
	Sun,  7 Jun 2026 10:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827134; cv=none; b=DYQ4n7rJKGGE1UERll5BpPZdr9IqkKbnGAA3K1wsXVUVKYOp60eq1obmc9IUVgovxNF8pCN08LYq0UA0mTIBBi4SCQTfuSpo2tb9LfbRjRSoVdM+7ATQ1dRLrzF5NQV/U9yq3sITCU7Dukm+A1ewrK9jj6sGdsiAaz18aeYv+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827134; c=relaxed/simple;
	bh=zdYQxZF3+33pgH3tCmKvQB6A2kCn6agJIaQDZrTzlt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m54opYJpwwI7VMhMrrOIylHxMZdxSKspNV08uh86eb1BkET4GLHlkrriKVsHgoK7mPmJ9+E6F5UPL2wfU+QZhjsaFUOU1JuFrZVnWQaVAhRwkrHFwPEPjoBtEqqzL4QEUVBvbHDBd2K8ux2eI1FtBoKVXq19rnn5FH1Ng67JSu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlSxMLYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlSxMLYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE2C1F00893;
	Sun,  7 Jun 2026 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827133;
	bh=9+eUQEZ9v1qtbCTUxqvVSuHzJZz+XTYoAZXwXuW/j7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlSxMLYHCAvIyGO2rliFrXids09xly6O4t2D0dn4rrawkX6NvCqfYWvsMalbk2Y+v
	 dri/ZBevFSdNItC4Pl8JPUiBPx7aMY8pWj1LotYLgifVF4aCX4Mvc+Fsm/N7rMGUhK
	 stQr3wTuwNeWH+UVQ4RsgqwoNEh/fc861zc1MxIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/307] nfc: llcp: Fix use-after-free in llcp_sock_release()
Date: Sun,  7 Jun 2026 11:57:02 +0200
Message-ID: <20260607095728.566631552@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
index 57a2f97004e172..915929cd724f90 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -633,6 +633,8 @@ static int llcp_sock_release(struct socket *sock)
 
 	if (sock->type == SOCK_RAW)
 		nfc_llcp_sock_unlink(&local->raw_sockets, sk);
+	else if (sk->sk_state == LLCP_CONNECTING)
+		nfc_llcp_sock_unlink(&local->connecting_sockets, sk);
 	else
 		nfc_llcp_sock_unlink(&local->sockets, sk);
 
-- 
2.53.0



