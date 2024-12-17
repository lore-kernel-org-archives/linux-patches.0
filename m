Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548478615A;
	Tue, 17 Dec 2024 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455934; cv=none; b=BVGn4N7sGTjqdNQ3HhsUCWVzbJ9UnQIegKQCzIkdwyRs2OMaL9DM9dw0zNHJae9GtMFXQYlGyV47B+iPdH/FNcgymOmUzudohbYpimaeXn8PSSZInOeBt99GwC8sondUiddxRXlxdx90TTeP3OYlT5P9Rb0bAXLnEs1Nrehz/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455934; c=relaxed/simple;
	bh=QC9DbPRl3icZYCfy83rSD3uMayi3J5tPKyYrmvXdFck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0DcYFHPHiabj/qKGZ9qd4tvGxjFXMtH4dT1Z1SWlTpPluqtm+Ed4icqkMofdXJpCHgct06j9ZJ0VTvDsAaWmanCs0tytoMk/WNqpkaFIpdgJrt0LSHtXSQXIzuXmf/H81CUu3TOQLXkbd4MI8Wl/asUrI+eMMWLhilZuspbKj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENR1JiAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENR1JiAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCA8C4CED3;
	Tue, 17 Dec 2024 17:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455934;
	bh=QC9DbPRl3icZYCfy83rSD3uMayi3J5tPKyYrmvXdFck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENR1JiAaZqXYPX1gWn+VysTJAeBPIYuV2RSlza/OKDPUQr1HV2iIAk6v4hOleDva/
	 flW/QrNMVBw/agcKwM4rlhZ9J++AcZ5vRqGNHCMnsIvJTTqhp6Ks87oV8gsohEjkMi
	 97AdO3MBIUKZSH0Oi0wduwm3BKR5CKW50plfvbSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/76] qca_spi: Make driver probing reliable
Date: Tue, 17 Dec 2024 18:07:35 +0100
Message-ID: <20241217170528.550471334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit becc6399ce3b724cffe9ccb7ef0bff440bb1b62b ]

The module parameter qcaspi_pluggable controls if QCA7000 signature
should be checked at driver probe (current default) or not. Unfortunately
this could fail in case the chip is temporary in reset, which isn't under
total control by the Linux host. So disable this check per default
in order to avoid unexpected probe failures.

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20241206184643.123399-3-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 95e0a5237359..b7af824116ea 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(qcaspi_burst_len, "Number of data bytes per burst. Use 1-5000."
 
 #define QCASPI_PLUGGABLE_MIN 0
 #define QCASPI_PLUGGABLE_MAX 1
-static int qcaspi_pluggable = QCASPI_PLUGGABLE_MIN;
+static int qcaspi_pluggable = QCASPI_PLUGGABLE_MAX;
 module_param(qcaspi_pluggable, int, 0);
 MODULE_PARM_DESC(qcaspi_pluggable, "Pluggable SPI connection (yes/no).");
 
-- 
2.39.5



