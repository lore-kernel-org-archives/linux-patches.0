Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C051E7C25;
	Thu, 30 Jan 2025 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246902; cv=none; b=PA2WnCXfZnUgXq2kFiBpuiqnKMOGGdO804x/EaXChpnIJPwp4eSEWOJ/ObcHoYG7oExePH7VnIrJYmvrp93uu2f6OG22HpO58OrX09lpq9ktZPhLYayDbfuSx5d6jpZrRi3p+3qBvdlR2SDdT9fQvL+PW1ruTCcBsVw7/gUMaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246902; c=relaxed/simple;
	bh=gmQyEizabiQAkBngsUJcsIBM87uCGny/HOhEUWEcOj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBX7nTDr2BaMFBp8+XmJDWNrIH0CjkW6pePNG0k2SuEzIJeG9E9IEMYdHEof+6Gkuo61J7satMSTZ7eY1T9fqbd3utB0AafCuc9MCSyWXHq5SERaCC8yLiE1anjoLvXx/J+6I5ScnP2hJEO5IJZ+lbja6s/WCFSXwS6p0HC9yuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWVt2jkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWVt2jkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5F8C4CED2;
	Thu, 30 Jan 2025 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246902;
	bh=gmQyEizabiQAkBngsUJcsIBM87uCGny/HOhEUWEcOj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWVt2jkBxMInyQXW/zRt2Ym4Q9vs4RQZw+w+X9zGEYQr+0G7N8JBM6OUnuJzCnXOM
	 13SXIG3UIjmZRLHJ3iyDTfJVwK+Um4EGUz8oBkTlmfN3kaGqgVYzOEr1Z+qh5oxm5r
	 c1rGLiqicxxBfcPJGpEpPuz2v3pkDl5M9HY8KrQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/133] tls: Fix tls_sw_sendmsg error handling
Date: Thu, 30 Jan 2025 15:00:04 +0100
Message-ID: <20250130140143.121217547@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit b341ca51d2679829d26a3f6a4aa9aee9abd94f92 ]

We've noticed that NFS can hang when using RPC over TLS on an unstable
connection, and investigation shows that the RPC layer is stuck in a tight
loop attempting to transmit, but forever getting -EBADMSG back from the
underlying network.  The loop begins when tcp_sendmsg_locked() returns
-EPIPE to tls_tx_records(), but that error is converted to -EBADMSG when
calling the socket's error reporting handler.

Instead of converting errors from tcp_sendmsg_locked(), let's pass them
along in this path.  The RPC layer handles -EPIPE by reconnecting the
transport, which prevents the endless attempts to transmit on a broken
connection.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Link: https://patch.msgid.link/9594185559881679d81f071b181a10eb07cd079f.1736004079.git.bcodding@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 46f1c19f7c60..ec57ca01b3c4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -428,7 +428,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, -EBADMSG);
+		tls_err_abort(sk, rc);
 
 	return rc;
 }
-- 
2.39.5



