Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D250B433;
	Wed, 30 Sep 2026 16:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784554; cv=none; b=EVtj36srU9m6gPXKRoIopQaGVd9wWg6Wm0Cf0VPXaGWp9sCBijFfZjhffpowulBITAehv+lOLSWf2/U2+m5KiBS5LgflnvGG42qfz6IIWgufJlMMlLfoc0dkuSyHgxQIBjHOeBwBB4CAwqS9lDqOL9g1uiZI47lj1nFtd+Q0LXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784554; c=relaxed/simple;
	bh=qESIJPSLI5tEi7MfCgAmAEh+JmVNY5M7M/tevHpvbAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxtrIE7d0qvaNVVGZwz4y9jb85/1zY0+9LtVZUx4pnRtxvt9jjRjE5dc0zT8daduoRZuqABlsWCeQQKjdtnCokFQ6UXMPy/emXkwdkZSmMH5cmxcgKfVpIhnCG+Gjp94duZB2S0+FcG+Hlfvg50kkvIFvhJK2TE7NqNX2JXcQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S35ezGBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S35ezGBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD7E1F0089D;
	Wed, 30 Sep 2026 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784550;
	bh=xCv2vbSB2SeKoZA784Dr22fAZzC30NGuBFUZs+4YbL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S35ezGBeQCNj2aFGq0+gFnr2dvSi/bnLPYkUsFd4RyrTiO6cnc3Pud0Bjyvp35Waw
	 +LoGkzA+qkDf5EozYqVvMIX1dmx6zt6pPVtKrEJXC2FS5mI6lDBxTL0IbODg6amYxO
	 NK8EmulBhetfyloqnTeG+QU1eLjm0ZbjY5DA1umU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/982] net: ibm: emac: mal: fix potential system hang in mal_remove()
Date: Wed, 30 Sep 2026 17:15:04 +0200
Message-ID: <20260930152420.423789685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 7c5d41f87f079990bf241359e3c1332d8d10fe87 ]

napi_disable() is not idempotent and calling it on an already-disabled
or unenabled NAPI context will cause the kernel to spin indefinitely
waiting for the NAPI_STATE_SCHED bit to clear.

In mal_remove(), napi_disable() is called unconditionally. If no MACs were
registered, NAPI was never enabled. Also, if they were registered but
subsequently unregistered, NAPI was already disabled in
mal_unregister_commac(). In either case, calling napi_disable() causes
the kernel to hang upon module removal.

Fix this by only calling napi_disable() in mal_remove() if the commac list
is not empty (which implies NAPI is enabled).

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260603230821.5619-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/mal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index f30a2b8a7c173..4e8afa8ad5e4a 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -716,13 +716,13 @@ static int mal_remove(struct platform_device *ofdev)
 	MAL_DBG(mal, "remove" NL);
 
 	/* Synchronize with scheduled polling */
-	napi_disable(&mal->napi);
-
-	if (!list_empty(&mal->list))
+	if (!list_empty(&mal->list)) {
+		napi_disable(&mal->napi);
 		/* This is *very* bad */
 		WARN(1, KERN_EMERG
 		       "mal%d: commac list is not empty on remove!\n",
 		       mal->index);
+	}
 
 	free_irq(mal->serr_irq, mal);
 	free_irq(mal->txde_irq, mal);
-- 
2.53.0



