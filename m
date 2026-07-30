Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B66434E2C;
	Thu, 30 Jul 2026 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423905; cv=none; b=V/kPyJudZb5paBPtrGGxQi8mie7YCwaEp9Kih1hPj8pj2H6k1hBGQU/ZNsoVLhBMd8l5kuuB1jibBZ8oobFUuy66AIbZeVpTFfmDLmd7018mYxbUhm/3c4ELUfvIQnEV4QYnFQz/d2BJyWA6IIVP+cdNT565aHRYF7g09lumEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423905; c=relaxed/simple;
	bh=+DcFMFktPpSEyehIAzpEApVUyxsFOsFCpMXf9T4fFXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keYCRXkh4RcuxFUliW6U+86mFgmtiwV45xG5z/Rp5xOtwsRelj7dmhHhw8NTD9WtWXrYECzGr9iS0oGyTKYFUUJtU+DGPuC/1sWwFLjpU/5ath8nf91ECzCPJaszcs5QOJ1Gy25N8FswIGffacQGyoSpbx866bD8NjaqklS6whA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V0umTmS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V0umTmS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3D61F000E9;
	Thu, 30 Jul 2026 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423904;
	bh=Uy7fBXOR/fB0x5F/K57OLENknnQsd+O/s02xIs5ovOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0umTmS+p8ZazA7fb1Vu5yqaIkaZmN/9orA9/kmKEBkU+whfnbENX+vOHuixeS5ww
	 jokuV79S3Crsek6JOvXdwzEmLooQ1q9rWZnMmFO2YXJy1nS+0V8qWwtXzkNmhg3lyu
	 NDPwlewVyeizcluw1jj9Z/PnEfDVeQkGi10B77CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	longlong yan <yanlonglong@kylinos.cn>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/675] selftests/net: ovpn: fix getaddrinfo memory leak in ovpn_parse_remote()
Date: Thu, 30 Jul 2026 16:08:56 +0200
Message-ID: <20260730141449.522773094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0a5226196a2e73..44418118f6ea7a 100644
--- a/tools/testing/selftests/net/ovpn/ovpn-cli.c
+++ b/tools/testing/selftests/net/ovpn/ovpn-cli.c
@@ -1746,7 +1746,7 @@ static int ovpn_parse_remote(struct ovpn_ctx *ovpn, const char *host,
 			     const char *service, const char *vpnip)
 {
 	int ret;
-	struct addrinfo *result;
+	struct addrinfo *result = NULL;
 	struct addrinfo hints = {
 		.ai_family = ovpn->sa_family,
 		.ai_socktype = SOCK_DGRAM,
@@ -1770,6 +1770,8 @@ static int ovpn_parse_remote(struct ovpn_ctx *ovpn, const char *host,
 		}
 
 		memcpy(&ovpn->remote, result->ai_addr, result->ai_addrlen);
+		freeaddrinfo(result);
+		result = NULL;
 	}
 
 	if (vpnip) {
-- 
2.53.0



