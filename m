Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5A1E766E;
	Tue,  3 Dec 2024 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242131; cv=none; b=aVUAuinzt5pQAdKfzAxzWYA6RstronFR+NTNXAG3zMC/rU4K+GVll7pQT7EiNvhcc0kdfT6Bc+ImETKH8g8pWvuwbYLo0OMn3tln9XsNtkaZ6/WXOOeIRmAdTM52yHhUXkjVxNDIG1jy/8Kb9uD432740I17BUJDl8goQ3mPpgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242131; c=relaxed/simple;
	bh=20nuF8jU/7bCd9J53M10qazRYE9Px72QEkp0o2b8590=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZnS2aYx0XvV29kl4IBPHdNUmOpxZ/OKye4Ltc8ZDlxLrMzP4BD6bY0DMWFfQqdHPVOhrFoD6DfciMeIm2JQNhOzwyJ/1YYBaQgjcUD33oG/aujBLqZDi3WPJlQfJhoxBI+w7nwGJ+gWT7FAqfHBGTxFsiaeS+qyKtnReVLReEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtF6v6ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtF6v6ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBC4C4CECF;
	Tue,  3 Dec 2024 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242131;
	bh=20nuF8jU/7bCd9J53M10qazRYE9Px72QEkp0o2b8590=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtF6v6ye8Cttxx9Z9DVoRf99tcCCVLp+xbqpJblQQ+CalJt/LdqxAibTjvgJqZ0fC
	 cX9edkqO2GcPYMshnP3mfSTaf4CkDlY7sK2MHbHSmXmDM3MdTSmkvZ8QM5Ljs/OoNP
	 I3aeslvhxFH5qPUWC5/z3GlgE3LWygXawMbNa13A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 586/826] rxrpc: Improve setsockopt() handling of malformed user input
Date: Tue,  3 Dec 2024 15:45:13 +0100
Message-ID: <20241203144806.608188733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 02020056647017e70509bb58c3096448117099e1 ]

copy_from_sockptr() does not return negative value on error; instead, it
reports the number of bytes that failed to copy. Since it's deprecated,
switch to copy_safe_from_sockptr().

Note: Keeping the `optlen != sizeof(unsigned int)` check as
copy_safe_from_sockptr() by itself would also accept
optlen > sizeof(unsigned int). Which would allow a more lenient handling
of inputs.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/af_rxrpc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index f4844683e1203..9d8bd0b37e41d 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -707,9 +707,10 @@ static int rxrpc_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EISCONN;
 			if (rx->sk.sk_state != RXRPC_UNBOUND)
 				goto error;
-			ret = copy_from_sockptr(&min_sec_level, optval,
-				       sizeof(unsigned int));
-			if (ret < 0)
+			ret = copy_safe_from_sockptr(&min_sec_level,
+						     sizeof(min_sec_level),
+						     optval, optlen);
+			if (ret)
 				goto error;
 			ret = -EINVAL;
 			if (min_sec_level > RXRPC_SECURITY_MAX)
-- 
2.43.0



