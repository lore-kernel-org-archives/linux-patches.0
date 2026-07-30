Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EFA175A6D;
	Thu, 30 Jul 2026 14:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421878; cv=none; b=bYtgenPvX//rzGZJiZiG+7zGzOIhbV4yx26XHAh5Y6VvkRIZ08puKDp6yqTV216UCZ/U6h47xpw15Qe7A1IYTKsNT/dQHAY1sac7mRinNqswI5/y8wh7FoAl9AuvT9onk4EGGX3wRY8mUSf/2kg9guNMupHOW6FGMsMxT/Tw+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421878; c=relaxed/simple;
	bh=pi4PIspqJol21yBdCKKzSxkJBWyGg1Y39HmnOf1cgAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfG5J/jBioKfsrwfarrpwfhlujkrE/ywn1O8RvKg3pRVWMr1l8R2x2gmAgHxbwp7SGryrxZ2GiB+LovUb70mLIaDUuKMd3Ly3vKvl2nR5VpMwVm4KNV5RD8T8PpyGJVA5vZl3Junpz2KON7pKVnUPOocHPLODgIFxBHwbHbER7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGkYAu3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGkYAu3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363581F00A3A;
	Thu, 30 Jul 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421876;
	bh=1NywQcVOGmMbL7k5t8xhFxFyAHN2iK/7RHfX3oZKnsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGkYAu3npSzovfgLPdfIVBeFLjSZA5uh25d+TJIScr9wne0Fcn//xvIVUE85xwcUt
	 ZPRwZG2JgEVRRgWEjfj9ZlhsSlSaXfL458e62OhcO/RscR2tWqDhYAoTOIkViflQM+
	 Em2ikiMb7E+558lK9+GS+jZbdPlSnDV6fgrDQJeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 223/744] selftests/net: ovpn: fix getaddrinfo memory leak in ovpn_parse_remote()
Date: Thu, 30 Jul 2026 16:08:16 +0200
Message-ID: <20260730141449.026079246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: longlong yan <yanlonglong@kylinos.cn>

[ Upstream commit 0bd9cfebc1c91e1066e56d6261b99691b9df6008 ]

The ovpn_parse_remote() function has two memory management issues:

1. When both 'host' and 'vpnip' are non-NULL, the first getaddrinfo()
   allocation is leaked because 'result' is overwritten by the second
   getaddrinfo() call without freeing the first allocation.

2. When both 'host' and 'vpnip' are NULL, 'result' is an uninitialized
   stack variable passed to freeaddrinfo(), which is undefined behavior.

Fix by initializing 'result' to NULL and calling freeaddrinfo() after
the first getaddrinfo() result is consumed.

Fixes: 959bc330a439 ("testing/selftests: add test tool and scripts for ovpn module")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/ovpn/ovpn-cli.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/ovpn/ovpn-cli.c b/tools/testing/selftests/net/ovpn/ovpn-cli.c
index d40953375c86fa..f4effa7580c0f9 100644
--- a/tools/testing/selftests/net/ovpn/ovpn-cli.c
+++ b/tools/testing/selftests/net/ovpn/ovpn-cli.c
@@ -1785,7 +1785,7 @@ static int ovpn_parse_remote(struct ovpn_ctx *ovpn, const char *host,
 			     const char *service, const char *vpnip)
 {
 	int ret;
-	struct addrinfo *result;
+	struct addrinfo *result = NULL;
 	struct addrinfo hints = {
 		.ai_family = ovpn->sa_family,
 		.ai_socktype = SOCK_DGRAM,
@@ -1809,6 +1809,8 @@ static int ovpn_parse_remote(struct ovpn_ctx *ovpn, const char *host,
 		}
 
 		memcpy(&ovpn->remote, result->ai_addr, result->ai_addrlen);
+		freeaddrinfo(result);
+		result = NULL;
 	}
 
 	if (vpnip) {
-- 
2.53.0



