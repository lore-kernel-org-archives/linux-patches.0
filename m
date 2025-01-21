Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3468B1F0E36;
	Tue, 21 Jan 2025 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482811; cv=none; b=RPClgeIxA6zD+Nkcqrn798YVtdydKMOexhPvVU+VgH470DCgLuDm7qEMVu9Rz0Vp+MYhK/P9yL3Y4PVJa67hh330Al1KqbIcwUC+JXnVnQ4TYrtSIFZlHywdaP3YVJJ5ZL0tCVE7ObZ0IiyoEyRR+MqAij90UXyFRNN7+kG9+3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482811; c=relaxed/simple;
	bh=IEt7W9Dlg00vG5gWqERHnuUgoLK5Upl+Hr7coeyhJSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tdp9iu/Vjt4JShEukP7PVCirJsUy8fs4ASasOnwYmTCh1tHn8GVX7+95zaUdS71oqWFVp7Z292fN4CMh7yxWj70v773e7ntvtyX9gbvI7X71LJRBcQrBh+WjWMXFbLTbOMM+xHN8TzQj0qEr26WM7h163UeRN9oQSPBFBhaPGVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw+f2R2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw+f2R2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9282C4CEDF;
	Tue, 21 Jan 2025 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482809;
	bh=IEt7W9Dlg00vG5gWqERHnuUgoLK5Upl+Hr7coeyhJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw+f2R2GISZxI9Ld0sbtTUOdVWGEfoGXjSOem4jL+3VhWaPk9H62M1ogyRGCirlBJ
	 HN4Oyi4fbHFIfDRUX8YGdjiXzOcA4jTYzJf2+C7+AesOZ72l4ROBxJvMmirS23wdQC
	 eFCaTTSamV5NbbDhpYrZg4k+joqGXDHRsQCvDdJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/127] tls: Fix tls_sw_sendmsg error handling
Date: Tue, 21 Jan 2025 18:51:28 +0100
Message-ID: <20250121174530.296567648@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c17c3a14b9c1..0f93b0ba72df 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -453,7 +453,7 @@ int tls_tx_records(struct sock *sk, int flags)
 
 tx_err:
 	if (rc < 0 && rc != -EAGAIN)
-		tls_err_abort(sk, -EBADMSG);
+		tls_err_abort(sk, rc);
 
 	return rc;
 }
-- 
2.39.5



