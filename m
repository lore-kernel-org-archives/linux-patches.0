Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1681E1DA62E;
	Sat, 12 Sep 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231270; cv=none; b=O9rOSnuTMa49JlYOLzV7Q4qSXvXeacJcVduRh1+noP+7+liQHRzihd0g+2e4ZUgaLc7DXNSPc9Qk3tQ4HFiHxMB/MTJmHo+ghdTuWrMBe1O0sOjgk3cjMVdiLjA6tZ4T1KYcFBYfqD9yjuS4PnhVXMpzUPiyU/kEgYpecG1fVnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231270; c=relaxed/simple;
	bh=l0BhoRTd9TP/QAseLjmLY46hO5/yfdYCfkbPzODsXEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBICtGYlvDGd6obchhE6/alWP6Yw0fMi1LZgBhEl/kcOWX0uV7u55O2IwpFZff28pO0UgLpFBi+YJzn36h+RE7FjH9I17XRxt2IJsXcNaT8GI2pxyyLyoPSCp/EjSg5gMv80c2leS4X6WnppExGFCMXeXqGQfaGzNZ3zjJ1yG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1DCeHFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1DCeHFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C295D1F000FF;
	Sat, 12 Sep 2026 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231269;
	bh=hjWgJ3hCxPuw2LtUGlQ5EFfzhpWZlSGWgifCAu7MVuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1DCeHFSnOnSCSgM4ZWrnyO4PM9m62KkP5RY7+UxYt79Ybph7d8Ux2o3CDLjcpKZ+
	 CSwGADQDZLBZebDV2p/7AlLzh/XY1jwKahk1o4fB8veB/i2qUx7HXmQp1lRp/UIiIl
	 9BAejmayXFBm8asDop0gtz4Y4MlQBQH868tG30W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0962/1191] nfc: llcp: read llcp_sock->local under the socket lock in getsockopt
Date: Sat, 12 Sep 2026 09:01:30 +0200
Message-ID: <20260912065609.827348997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 36812527052c5bfb1ec6c1e292d67a5bf76b750f ]

nfc_llcp_getsockopt() read llcp_sock->local before lock_sock(sk) and
then dereferenced the cached pointer inside the locked region.
llcp_sock_bind() assigns and clears llcp_sock->local under the same
socket lock, dropping the last reference on its error path. A
getsockopt() racing an in-flight bind() can observe the pointer, block
on lock_sock(), and then dereference a freed nfc_llcp_local once bind()
has unwound.

Move the llcp_sock->local read and the NULL check inside the
lock_sock(sk) region so bind() cannot mutate or free the pointer between
the load and the use.

Fixes: 26fd76cab2e6 ("NFC: llcp: Implement socket options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260521-fix_llc-v2-2-ab44cc09179c@debian.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index a2c3d876c7d85..0cb1688bcbba7 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -325,14 +325,16 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (len < sizeof(u32))
 		return -EINVAL;
 
-	local = llcp_sock->local;
-	if (!local)
-		return -ENODEV;
-
 	len = min_t(u32, len, sizeof(u32));
 
 	lock_sock(sk);
 
+	local = llcp_sock->local;
+	if (!local) {
+		release_sock(sk);
+		return -ENODEV;
+	}
+
 	switch (optname) {
 	case NFC_LLCP_RW:
 		rw = llcp_sock->rw > LLCP_MAX_RW ? local->rw : llcp_sock->rw;
-- 
2.53.0



