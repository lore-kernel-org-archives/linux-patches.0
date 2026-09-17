Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F14C5326A7;
	Thu, 17 Sep 2026 17:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664492; cv=none; b=XOgKYg7LLw+n+mEpA4PnW134JjfzSwOE4OwDroHfTqUAUY5tiWiwy3oxTW0Hee9sLQnDCPBLiYjqCEEpIU8ZtlxBHSavCulr37PBoB6l0kvj+4oUYOq1kcdYTy2eGxauwtlBo5mlPcnOxhshCcyFxz2+i+raJrg266yWPdeIjyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664492; c=relaxed/simple;
	bh=U3DaV18rbL+nvl3J7Mz1a/6jU3BipsasZYhKUHjkx2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVFV0wTSvG744Ksru7tTFC+ZyWPFUmYebS3RI8I9PMkEVS2deB2pFAj0E7bmJFbCOha9uAc6MK13vIz1KZPJSqk9T5UHP7zX/3lnk9JoP0SVnhpYxsZucLO3kZFATuylfLbnhbE4b0/amtdLS0WnC+xHKuGPqbRyCk/pjMSdWMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSiqtEGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSiqtEGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4E61F000FF;
	Thu, 17 Sep 2026 17:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664490;
	bh=BcLetqsgg2W1E2rlj9nOtsz9TWrluYBWf3WS3ewPCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSiqtEGI/tZsShFJxi7Z1hEeIcq/wjfDzPPSo15c9P5UApnVbnm37HlGwVDgKX/39
	 7XB3qkNIX7XLqEPWADXP8nye/iUX/+S+BxPaXiB73vYvZTqlhEehh69E5Sc2YTQAe/
	 uogazM271qgLqmtA0X3AEIoXfelLw6YRbmGYp83s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0358/1250] net: ibm: emac: mal: fix potential system hang in mal_remove()
Date: Thu, 17 Sep 2026 16:02:33 +0100
Message-ID: <20260917151601.769070678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index a423496421e9a..a089e7b64bb2b 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -710,13 +710,13 @@ static void mal_remove(struct platform_device *ofdev)
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
 
 	mal_reset(mal);
 
-- 
2.53.0



