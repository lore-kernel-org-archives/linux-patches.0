Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734573ED3B2;
	Tue, 21 Jul 2026 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661705; cv=none; b=MMTRx2iRp3ZEtEaCPfp3pR0l2EiWyTCVQ3LZkxQXeCts8jwfERtdTRcXy7M3bt0Q6TZWQzwUz1yTa7CQJTnfhhsgc/UjwY48jVQ+dIelV+g7A6MWtn7wjTTBIwiNf2iTUdLtw00xbBOgBJsp0QhgaGwUVuDJHtb4fsOguXbxiB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661705; c=relaxed/simple;
	bh=0NNCfEtAh2tEbUodHHr4hQz5eCFtoMdoNU0pUeWuGZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmBmxaKIalwucmuFHmsKMs1cHUT39cpz7sDCxblcM0nXVVYKHl0geKVsOVxM2T8WEYETs6IYUOQrXuSaZFuRMlPI3lxgHV/zzWCu5mVKkD1AMV7i5wOrOhZheukrGdeOsVD0ea/JCgI0hyQECNzlevDnnMJ6KxQrqfU6OQhyWR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8UUYtoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8UUYtoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95BB1F000E9;
	Tue, 21 Jul 2026 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661704;
	bh=vnsU+OwaTg/QFYR4qVB5yVilrb6jeuDItmxFOzBd53U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8UUYtoAmoCu8B1V9WkskDiHJHZxydqzwCgRNIQ9c6VzIx2nFRv7jPL6lLNo054Z6
	 zzTj2y4DRmnUQX2RnoLpUSFYsnCCHmMMmkeaBTAcC5puzt/09deWQis+VDF4yLlzPG
	 49xTUYsQtGacCSn5KrLxbi1CVU62UwPWWrwaAR0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0166/1276] driver core: Guard deferred probe timeout extension with delayed_work_pending()
Date: Tue, 21 Jul 2026 17:10:09 +0200
Message-ID: <20260721152449.813779228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 557495bc879013c3d5e21d667e987e7ce3a514de ]

mod_delayed_work() unconditionally queues the work even when it wasn't
previously pending, which can fire the timeout prematurely or restart it
after it already fired. Add a delayed_work_pending() guard to restore
the originally intended semantics.

Premature firing calls fw_devlink_drivers_done() before all built-in
drivers have registered, causing fw_devlink to prematurely relax device
links for suppliers whose drivers haven't loaded yet.

Fixes: 1137838865bf ("driver core: Use mod_delayed_work to prevent lost deferred probe work")
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260525012340.3860581-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f84cbb900908e0..a694549c59a7e2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -326,7 +326,8 @@ void deferred_probe_extend_timeout(void)
 	 * If the work hasn't been queued yet or if the work expired, don't
 	 * start a new one.
 	 */
-	if (mod_delayed_work(system_wq, &deferred_probe_timeout_work,
+	if (delayed_work_pending(&deferred_probe_timeout_work) &&
+	    mod_delayed_work(system_wq, &deferred_probe_timeout_work,
 			     secs_to_jiffies(driver_deferred_probe_timeout)))
 		pr_debug("Extended deferred probe timeout by %d secs\n",
 					driver_deferred_probe_timeout);
-- 
2.53.0



