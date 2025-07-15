Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0E2E5404;
	Tue, 15 Jul 2025 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586420; cv=none; b=PpICZ/IuwKKukCirULLr2oUQbwQN7xjXfw2ZUVDd/5iDWPl7l24kDPrn0+VtTRkH7YBxgmleOUS9V+KtE9ouOGMZsjUWu6WORmjCGo9cJWJHpkpyUAhTm16nynFJ8pxQNZxwxDJghmcglJHWlLK1nYzRj7TSC0YVdS29JZKPHpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586420; c=relaxed/simple;
	bh=BinJLm6sui0+elbqJDvHDrD6aMzjQ6/9lttHE2NwMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpWM1wtC9OAePZneF5vJI9piVsKowiJg5BTTsbZH/qVBfSedDSdbu7DZmnQ61pKyNcV/KtUaK/6+gOpfZKdqU8C1QgFVCxxpikJ9P1BmX4vzK684lYQWJ/fUknAy344C8s86bEovzwQYhnoToTshYJoGOae1bLyYam9VT4PDYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWBOBSXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWBOBSXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99400C4CEE3;
	Tue, 15 Jul 2025 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586420;
	bh=BinJLm6sui0+elbqJDvHDrD6aMzjQ6/9lttHE2NwMmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWBOBSXhJiaetY4mDLiivx+94uHi4kxuNqf6mP6FOqFGi8geS9e7FNyDG2n0rrfEd
	 L0+UCBr47RkexlZKb0HYmlw+KMcEty8FrPhGnEAnubh4SYWHogqQBRgTnef9Fd3Voa
	 gbNGB82009ZOT80FpwB2FgjyRS9+IF37m8z9mWHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Liu <net147@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 058/148] Revert "mmc: sdhci: Disable SD card clock before changing parameters"
Date: Tue, 15 Jul 2025 15:13:00 +0200
Message-ID: <20250715130802.649684628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ulf Hansson <ulf.hansson@linaro.org>

commit dcc3bcfc5b50c625b475dcc25d167b6b947a6637 upstream.

It has turned out the trying to strictly conform to the SDHCI specification
is causing problems. Let's revert and start over.

This reverts commit fb3bbc46c94f261b6156ee863c1b06c84cf157dc.

Cc: Erick Shepherd <erick.shepherd@ni.com>
Cc: stable@vger.kernel.org
Fixes: fb3bbc46c94f ("mmc: sdhci: Disable SD card clock before changing parameters")
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Reported-by: Jonathan Liu <net147@gmail.com>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Closes: https://bugs.debian.org/1108065
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250624110932.176925-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1708,15 +1708,10 @@ void sdhci_set_clock(struct sdhci_host *
 
 	host->mmc->actual_clock = 0;
 
-	clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
-	if (clk & SDHCI_CLOCK_CARD_EN)
-		sdhci_writew(host, clk & ~SDHCI_CLOCK_CARD_EN,
-			SDHCI_CLOCK_CONTROL);
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
 
-	if (clock == 0) {
-		sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+	if (clock == 0)
 		return;
-	}
 
 	clk = sdhci_calc_clk(host, clock, &host->mmc->actual_clock);
 	sdhci_enable_clk(host, clk);


