Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BE932D7C7;
	Sat, 12 Sep 2026 19:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243193; cv=none; b=Dg3T/EK2nrHQ/cRcseSVkxYXLUDz8iFTHKCtXyobejGrpfHnvGllaHhRBtuppPdKOT045PDC+k8XXXSGIiK/k+7CFVfv9sB/JeLwCwCUj+YWqCTVT4ve1q2hki72p4fZsTU1QCONO8DMoSOGYxzi4p5K2vxxXapAnTXhsWLAlXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243193; c=relaxed/simple;
	bh=Kkzvpmx3yVdENdk0O0AODzNTf+zYlBGPydFot51gPtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrPqNVRAUFFOmWaQQXO6JduTe7DkHLI09GcGTDiFFWy8GECTWWqAdGU30+MDjoAj5rJ6y+1K2s09NMWCFP1NXZwk9NssirRP9rQUCI+oz9RIr0NO0tM9hydutLvKpa4siimW8+JlzRy2UWqF3an7hSm3Rv0TmqlNP2qixDOstjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO3JmOzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO3JmOzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9BB1F000FF;
	Sat, 12 Sep 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243191;
	bh=9YVWtn9H+4E556bliCpVaiAC3RO6wdWyjitmKUMl7uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO3JmOzV849uLa6qkVT04DdYgh5ibHs9vuTU+7Bd6OSNPSirrzZ5Zm2efuzCm5zJ8
	 UgSazdbmpmZSEiAkAoUquS0qBQntW+on484GDh7TIiSa7S4Ck/+nxwNsXmDfyVT+S6
	 0m/ocjquLoWehdJS/4FC6+4nGqvD8pJ53q8mH7QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 669/798] nfc: llcp: read llcp_sock->local under the socket lock in getsockopt
Date: Sat, 12 Sep 2026 09:04:57 +0200
Message-ID: <20260912065532.437357583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba5ffe0ce6d1..85767c13543b5 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -320,14 +320,16 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
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



