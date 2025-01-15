Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570831E98EF;
	Wed, 15 Jan 2025 10:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937580; cv=none; b=WjbPb+71QFh9HTTobg7gkyG4NdK+0JWsaT4C6lApesHqvl5HNvsoz42H3DhE4e/NbuGMTvtfHFuLsYI038AJrKSHG6pjRwzumkAp17530Quu81zstFDhFhCmqGx0N2R9uIwsLyYfNwEHEBiHkyXYNUEx+HoMOD+ee9dHHbgZAFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937580; c=relaxed/simple;
	bh=8R7kI8vBoeddzhuvbNKg2kJ1+VwMp6U/46e6xNSfG2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYg2ixCCBVVUqnoT6ZfXqgj0glWH3FzQQVupg6CFJTUb1qwGmHNBJnwq0FYMZMflKVQaPbXME1ayW+TOl8QncAt3ERVEPxCFL3wYctxQPkc5KICzVZbclQJXGxttoEH8QpAVYAz0pJrpDAtupjzrMaDHOAIoz0Xzk8lri99Ntwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrSttz2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrSttz2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B53DC4CEDF;
	Wed, 15 Jan 2025 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937579;
	bh=8R7kI8vBoeddzhuvbNKg2kJ1+VwMp6U/46e6xNSfG2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrSttz2hVvFsmKD2mpJb+ggltiygwQnni4IZKwfmCB/BZgq46MqADvZ0GmXpdZwdE
	 O9ggYUKwN5u+4VGwrLZ5wXKrUEv/pdEvsGytqRy/tM+1Xf4nGbfSJz6WQAgJGVjWZP
	 awM3EThqst8jb5EFV5nV8APlc5Ljb2fcvhKP1yWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/92] tls: Fix tls_sw_sendmsg error handling
Date: Wed, 15 Jan 2025 11:36:39 +0100
Message-ID: <20250115103548.381459900@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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
index 348abadbc2d8..5310441240e7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -452,7 +452,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, -EBADMSG);
+		tls_err_abort(sk, rc);
 
 	return rc;
 }
-- 
2.39.5



