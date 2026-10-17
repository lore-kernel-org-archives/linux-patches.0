Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB293B531D;
	Sat, 17 Oct 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257290; cv=none; b=g+1x7AeS05A+W66vPxvsRopBjPrwpLaMU9psWK11BkHeJoqIC7PGQlKIX54mM0qybTmjGJeMmERJnm4Zprega75vIDlSyLu8IgUKkp4KwMGsDHcDm3k7gIYy+xApFwfwB6Be1TMt8LO68MG0WtRSPO90yaM5pFkHj8f+jseVGuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257290; c=relaxed/simple;
	bh=VzdlZ5f9Dh4ETDx5EdFRZkEQ2zXMfRn6KK+ezWhOEdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEm4icNG7DT3GwGDWPyaU5Lw9fwCUhbtuurQCMRDUXpUocKKBkW83XsvS+kEaZC04EdgVWvQ+HRqgvwAP6FmyOOVZmcI2oVOdFy6tNNpSSsfLG48PvSb5O1+X04Rf+mYmAcfQCtzCh1qdRlCMf3OfMPwFQmB6v5fEjqarZdE5OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3w6KrOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3w6KrOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FC31F000C4;
	Sat, 17 Oct 2026 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257289;
	bh=EUFtq3p3S/L0KRxNez4MG1y0CqNUULqR4YefljAi6y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3w6KrOWoGGfKH8H/RkqcxN2Dh82/IOyjfDNL85bfHxfUw8TTmI0vl3Mmj/E2pdwt
	 sAbMY9AG5GyUPE9FzLvAiJJ9CSjH3u6EsgUEARWq1BnI/slFtkWXwvd96ds1d48mLD
	 bT4FUJ3hT3g8VQrquWqGemOwARTAaybcr48JgXpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0511/1674] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Sat, 17 Oct 2026 17:46:23 +0200
Message-ID: <20261017160444.222653382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 4c66c423593e26273ea0d644906ed007630c6f6d upstream.

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -592,7 +592,19 @@ static int rockchip_pd_attach_dev(struct
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {


