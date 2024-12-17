Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C311F76D4;
	Tue, 17 Dec 2024 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455477; cv=none; b=r+hnnGCuiTThzK3A7GrKsgvZ9ztjF9eZHr6mwOCuULERgWs2XLb7dDNTxpzIicX04oC65uu1gTTGONdfx4+xRIe3RWnxcViZPMzDgRu2Xj6Eo+hLd8mNcyUI9898bdIkIkTQo+2MLvaP9EUVyVytI2flVctEnBDQAmP7N5E9+NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455477; c=relaxed/simple;
	bh=rTOMuKCCHoeFgRkkwzDrSaMnex6vr6T1txgAupJQt4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htueOXN0swlRll3NZpl8vanfZ6XgEYrpkcOE4ZyjIpo139rL9C9kM6+AMwfC37Ob0iIlZQ/EfOsXV41OtLWB0mzk7Fs11NwzhnwjAhMv9dRiZuWj/JTv5E6N1BX7cRrWz6W1VAqEKSSCtc3rMnGoftqe7cvCtzWZpPgXgsVhLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WME/ym5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WME/ym5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63627C4CEDD;
	Tue, 17 Dec 2024 17:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455476;
	bh=rTOMuKCCHoeFgRkkwzDrSaMnex6vr6T1txgAupJQt4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WME/ym5HReHxgeUiDgIhdSpi2XQqRXLoBbtOTYfgTOlCTcyGz4+YIl0+Ab9k1X82E
	 IX/lA6maSo5cgi9gfLY+vHSwhvbDIQLbhS/DI/X5CQImtbUfIlCdx4RbNpsMnwRuM3
	 etUswF3txRFXWXciqJC0Ub0w+sRwLiPUCV8aLccA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/43] qca_spi: Make driver probing reliable
Date: Tue, 17 Dec 2024 18:07:14 +0100
Message-ID: <20241217170521.389722550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d88138f4a4f4..b2805e856a7a 100644
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



