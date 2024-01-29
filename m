Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A394163A99;
	Mon, 29 Jan 2024 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548386; cv=none; b=mbxp/vBgd+u9cFd01CPfLDaBqLqkkGb09LnfE5jOti9uL7EYusDeTolAkiUDcgXtnzPx3eZr/POIIq6XIJ28TgvW/CSYokwbBM9DDAlAcR6B39JZjlHzvbup0dgnyZR9EBVq14sfHONslHEEOgBRbs9nBS8F2lJKNhzUiTuNMbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548386; c=relaxed/simple;
	bh=Q9sDwpuvKN6dOiDOlgEN9raylULXuaFs8EcztNQvvlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7OX/H0DlN6SDwCtMCVWlwy6HHo5MCEsKuZHL9TRyh8ehkm3Qd6ttlgXagNZKWbgUOlktpZhwsgumy9koJGGu5GDqtNl3mXJV/uIbjf/Tya0Bw7XN7ZRg1sMgFgfBIxSyiZ+mRufDAsbXzdNLkjeVEKv1mEqC/BzAERQ8v91SVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoSgmEbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoSgmEbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2B2C433C7;
	Mon, 29 Jan 2024 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548386;
	bh=Q9sDwpuvKN6dOiDOlgEN9raylULXuaFs8EcztNQvvlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoSgmEbjFIz+URyH1vrw4v/qDq5X9NKqj5dkjYCRXI4TvjsanPuMSUoXR0mlXFTiR
	 xOAECt/qbcouiGy2g3uvkMknI+8OWKxId09wY5BDOLmLB61L+OTXLARrfDEi2ksLxh
	 4TgT+lhHXO9PsFxipg2XdVEVOHXQkb5lrypde8cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jrife@google.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/185] dlm: use kernel_connect() and kernel_bind()
Date: Mon, 29 Jan 2024 09:05:58 -0800
Message-ID: <20240129170003.673304142@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jordan Rife <jrife@google.com>

[ Upstream commit e9cdebbe23f1aa9a1caea169862f479ab3fa2773 ]

Recent changes to kernel_connect() and kernel_bind() ensure that
callers are insulated from changes to the address parameter made by BPF
SOCK_ADDR hooks. This patch wraps direct calls to ops->connect() and
ops->bind() with kernel_connect() and kernel_bind() to protect callers
in such cases.

Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
Fixes: 4fbac77d2d09 ("bpf: Hooks for sys_bind")
Cc: stable@vger.kernel.org
Signed-off-by: Jordan Rife <jrife@google.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 6ed09edabea0..72f34f96d015 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1845,8 +1845,8 @@ static int dlm_tcp_bind(struct socket *sock)
 	memcpy(&src_addr, dlm_local_addr[0], sizeof(src_addr));
 	make_sockaddr(&src_addr, 0, &addr_len);
 
-	result = sock->ops->bind(sock, (struct sockaddr *)&src_addr,
-				 addr_len);
+	result = kernel_bind(sock, (struct sockaddr *)&src_addr,
+			     addr_len);
 	if (result < 0) {
 		/* This *may* not indicate a critical error */
 		log_print("could not bind for connect: %d", result);
@@ -1860,7 +1860,7 @@ static int dlm_tcp_connect(struct connection *con, struct socket *sock,
 {
 	int ret;
 
-	ret = sock->ops->connect(sock, addr, addr_len, O_NONBLOCK);
+	ret = kernel_connect(sock, addr, addr_len, O_NONBLOCK);
 	switch (ret) {
 	case -EINPROGRESS:
 		fallthrough;
@@ -1900,8 +1900,8 @@ static int dlm_tcp_listen_bind(struct socket *sock)
 
 	/* Bind to our port */
 	make_sockaddr(dlm_local_addr[0], dlm_config.ci_tcp_port, &addr_len);
-	return sock->ops->bind(sock, (struct sockaddr *)dlm_local_addr[0],
-			       addr_len);
+	return kernel_bind(sock, (struct sockaddr *)&dlm_local_addr[0],
+			   addr_len);
 }
 
 static const struct dlm_proto_ops dlm_tcp_ops = {
@@ -1928,12 +1928,12 @@ static int dlm_sctp_connect(struct connection *con, struct socket *sock,
 	int ret;
 
 	/*
-	 * Make sock->ops->connect() function return in specified time,
+	 * Make kernel_connect() function return in specified time,
 	 * since O_NONBLOCK argument in connect() function does not work here,
 	 * then, we should restore the default value of this attribute.
 	 */
 	sock_set_sndtimeo(sock->sk, 5);
-	ret = sock->ops->connect(sock, addr, addr_len, 0);
+	ret = kernel_connect(sock, addr, addr_len, 0);
 	sock_set_sndtimeo(sock->sk, 0);
 	if (ret < 0)
 		return ret;
-- 
2.43.0



