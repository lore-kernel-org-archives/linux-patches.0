Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF10A1EE001;
	Tue,  3 Dec 2024 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239376; cv=none; b=D87ntnKOi4QcAxS9Q+zndoDZXPg+7kMSFTZaCkojtXxBzDgq4HzNYVGHDvU8W2+XqGt8W7onMgKrhewMhEpPrs3wPxZNhP58Eh2dbLRLn6ckW27SfNBTIqY6Mt3hx6rmOIkpppHVVdNh0QCXwe049ycV9mZg3+m04ZaQD4GnuDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239376; c=relaxed/simple;
	bh=zBY+yNphbu6B+a9druOS8fRq37gsgZiurPe8H1Yw2Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcOJAf32zjWl60R97deP+WmoiSmKRRhww6xx1hdQNTpq+3Kv3cm68nKkkvPc537BLs3/i2SA5BZQZ88/l716mBak0erosXb4++75MjwWnG5q25RM94/mZ3V49ls7cmv6eVia74FbtCA/DHWRzATVoGGW8rdKfQRjBzU1XnizasU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxFpnW0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxFpnW0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A58C4CED6;
	Tue,  3 Dec 2024 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239375;
	bh=zBY+yNphbu6B+a9druOS8fRq37gsgZiurPe8H1Yw2Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxFpnW0L/witwmvIB2YdcLXWFrMQXlPIZrYehOxUg1Ys4TPuXM97hFVshOUJ7btxd
	 JZoBKhLyQ46PtVKhaIpOJG0F/ViyCIJfaFdXrY/IcDQkFFp41P4yejL3dUKOgEQlwj
	 6D0dGDkP9i/nJWdSdV55uHVxN3NQ02K12vCcOuDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 593/817] rxrpc: Improve setsockopt() handling of malformed user input
Date: Tue,  3 Dec 2024 15:42:45 +0100
Message-ID: <20241203144019.071483415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



