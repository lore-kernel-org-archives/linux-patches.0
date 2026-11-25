Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619878;
	b=Pi60p6pqGojiQ22S2v0/pm3gBgVKm5lUaqJHsBhNGFigvZKdpjjBwQObzUxonwvfjCu4
	 kBMKpy62dDkd2E8ivXqXpYcjyEh0YaJYqKQqxU5/3Yf1x5Lq6K/ca+aYcizedNYqAX5TV
	 n+cNWq6Uyr17g+waf3tYXiFNong3xtAxmyec1LMapdibR6mtmlv1ekY0x6orwQfTrtgHw
	 4O8m5Cu5/By3Mqhcyr8DbRO83lOBMNk7qXDDNVVgn+vMmEs/XrdAriWqwZcp1rebnUv1v
	 sKxn02ELMSimnuN72YtxkldxzglOM9YR8GMZ33ya3mmlmoXajjpU1eQXrjDpZOWlq6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z2pxOFtBoSxx74KpkcRi42HdY4Ah7g5Fq9ppX9DkT94=;
	b=p95cIHCn1c+YpS5fIe9XBIiZ5Znrg7WNuwL/LsZelaDO9usoiZk8qd1YPgH0x1jGvMxO
	 Qo4xGbuJk+vbdQomoieVQan1CZt8tTYhWGs9fcW0SnxN/miwAe+SQCLwLZqaebRAx3nN8
	 TDe+Rs5gIQz6tBPRR1ACGFjwW48lx6JQ59jo7/2ps2RP9Gx+kbzLzKGoTuOxXqGTATH56
	 51v3L/SRX9GrzhcSyC/3rdsBPrPYsE5jEwSmQTpvU0NNBv40FTneagTU1jL0gwi/V/8dE
	 LdIFN85fxARk4PWcH5xNd+W742b4jtGchrmGuH6H+CobZn5KIsrQ6ATeY6v/EO1WctA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZVzyuKS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DAB606A31E;
	Wed, 25 Nov 2026 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZVzyuKS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE841F000C6;
	Wed, 25 Nov 2026 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619878;
	bh=Z2pxOFtBoSxx74KpkcRi42HdY4Ah7g5Fq9ppX9DkT94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZVzyuKSxamxbsEWVZB6J6pJQ9/xdW6GWE/pOJ5NQ2+xgmw+8tPXeV0MlGEtKcLof
	 sEHyZtTsBmeWYYVU9DhSDbfI1xi/KbsIQzehkBFpu246cTpcfv5sd8K8Sc3KZM2+st
	 Q5HtrNS5kipshA2JSyWy1WnybKPkK1aES6apEvHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0734/1005] watchdog: npcm: fix clock prepare leak when setting timeout on a running watchdog
Date: Wed, 25 Nov 2026 15:34:32 +0100
Message-ID: <20261125143838.955429582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Feng <zhaofeng2@cmss.chinamobile.com>

commit 57c7cbe21acc77291ec0fbdd4bd72aa259cf4986 upstream.

npcm_wdt_start() unconditionally prepares and enables the watchdog
clock, and npcm_wdt_stop() is the only place that disables it.
npcm_wdt_set_timeout() calls npcm_wdt_start() again whenever the
watchdog is already active, so every WDIOC_SETTIMEOUT ioctl issued
while the watchdog is running takes one extra clock prepare/enable
reference that is never dropped.

Split the register programming out of npcm_wdt_start() into a
__npcm_wdt_start() helper that assumes the clock is already running,
and call the helper from npcm_wdt_set_timeout() instead; only the
watchdog .start callback (and the restart path, which intentionally
keeps the clock) now acquires the clock.

Fixes: af084fdccfaf ("watchdog: npcm: Enable clock if provided")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Feng <zhaofeng2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261109071004.1506-1-zhaofeng2@cmss.chinamobile.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/npcm_wdt.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/watchdog/npcm_wdt.c
+++ b/drivers/watchdog/npcm_wdt.c
@@ -145,13 +145,11 @@ static int npcm_wdt_ping(struct watchdog
 	return 0;
 }
 
-static int npcm_wdt_start(struct watchdog_device *wdd)
+static void __npcm_wdt_start(struct watchdog_device *wdd)
 {
 	struct npcm_wdt *wdt = to_npcm_wdt(wdd);
 	u32 val;
 
-	clk_prepare_enable(wdt->clk);
-
 	if (wdd->timeout < 2)
 		val = 0x800;
 	else if (wdd->timeout < 3)
@@ -176,6 +174,15 @@ static int npcm_wdt_start(struct watchdo
 	val |= NPCM_WTRE | NPCM_WTE | NPCM_WTR | NPCM_WTIE;
 
 	writel(val, wdt->reg);
+}
+
+static int npcm_wdt_start(struct watchdog_device *wdd)
+{
+	struct npcm_wdt *wdt = to_npcm_wdt(wdd);
+
+	clk_prepare_enable(wdt->clk);
+
+	__npcm_wdt_start(wdd);
 
 	return 0;
 }
@@ -216,7 +223,7 @@ static int npcm_wdt_set_timeout(struct w
 		wdd->timeout = 2750;
 
 	if (watchdog_active(wdd))
-		npcm_wdt_start(wdd);
+		__npcm_wdt_start(wdd);
 
 	return 0;
 }


