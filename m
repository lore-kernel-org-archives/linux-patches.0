Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC91D545;
	Thu, 23 May 2024 13:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470826; cv=none; b=mvqkoK2Q1IosFBcnYAXfXja2/yy0Xu7R3YDzv+JRiX4UVTK+rBT7mVev9nTA118boE3BjYkP6O91L5cQU4XWg8nFin2ts8Vm17Gx3kVvjhooCimQR8OBa2wm9ofi2PFAbnln4QPWavqKk8MUpG3vkWFRbjCkgypiR6IZ46C22/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470826; c=relaxed/simple;
	bh=kPpELrsGhxluGZL4uadPiTpkPqMcmsM8Hm3FHQ7wfhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=letkpbzhmWE0iiwwscaPoTx9+MmWMrGCgvbyl8vG1WUlQ7jQgkuU5NO0hr/alS1IqN1H6M+mZVlhRLJOdWAGvJ5wtQEDTXqicbsF40lNHCj/zCw706TzRDTu+tS0GuG1Kge1y7QsKJZz/wLlrppJjGbgk493+dhLLqmpbisQQ+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFTlpxPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFTlpxPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45494C3277B;
	Thu, 23 May 2024 13:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470826;
	bh=kPpELrsGhxluGZL4uadPiTpkPqMcmsM8Hm3FHQ7wfhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFTlpxPNEQpJ7pEA+JLnCqlHg++ikwzGhARVTFGeQkJk7wjzwCxQKUllyQxTnIlEo
	 WRKxuXp90Vwns4SslTPT7vPx/QsBNJ75fHHMm9Ic+pnitORPmADh929pBpmMFIqUcm
	 edPXvwa0x+P8k7uP4yP0YtEPkXIHsiWDbeeGq96g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengqi Zhang <mengqi.zhang@mediatek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	=?UTF-8?q?Lin=20Gui=20 ?= <Lin.Gui@mediatek.com>
Subject: [PATCH 6.6 084/102] mmc: core: Add HS400 tuning in HS400es initialization
Date: Thu, 23 May 2024 15:13:49 +0200
Message-ID: <20240523130345.638587856@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mengqi Zhang <mengqi.zhang@mediatek.com>

commit 77e01b49e35f24ebd1659096d5fc5c3b75975545 upstream.

During the initialization to HS400es stage, add a HS400 tuning flow as an
optional process. For Mediatek IP, the HS400es mode requires a specific
tuning to ensure the correct HS400 timing setting.

Signed-off-by: Mengqi Zhang <mengqi.zhang@mediatek.com>
Link: https://lore.kernel.org/r/20231225093839.22931-2-mengqi.zhang@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Lin Gui (桂林)" <Lin.Gui@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1819,8 +1819,13 @@ static int mmc_init_card(struct mmc_host
 
 		if (err)
 			goto free_card;
-
-	} else if (!mmc_card_hs400es(card)) {
+	} else if (mmc_card_hs400es(card)) {
+		if (host->ops->execute_hs400_tuning) {
+			err = host->ops->execute_hs400_tuning(host, card);
+			if (err)
+				goto free_card;
+		}
+	} else {
 		/* Select the desired bus width optionally */
 		err = mmc_select_bus_width(card);
 		if (err > 0 && mmc_card_hs(card)) {


