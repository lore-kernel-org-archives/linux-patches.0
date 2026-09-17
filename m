Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BD34DEC07;
	Thu, 17 Sep 2026 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668523; cv=none; b=LKG79jcfBV/78W/3hYLEu4geX9vfHfhyCQqKfS9abCsB6JyYbc9rvdFZU8xMeUqyiWAAj/+xb8MzmbWhPt/wYLX+JoEzrmknJZZmQxAEv2xWtY0yW2Vt6mjibnJYf/XCSYrXdNwqdeL9Uyb0mbp3uV6NAEgvmkkkEEptw+3X7c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668523; c=relaxed/simple;
	bh=ERxRefnY2KY+Aw1wsBN91/roDxNHq52aopow1nsVDlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UN9E2PQaprPTTNXraXePHJgdfIrlwCwoqc1aWR8+sSVrFzk7QWq6J+p4AxMSyCYDOP3c5ReOjYz25iaqh3mkg0Dbj6H2rpSl1Z6TbgC8njiW+NkzUrsLIr8nwaUHLpsJphu9lwLsNDRgrlKucBliMXlgI0XGIeW+VEMWL2KKibU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCIqx5Hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCIqx5Hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E3C1F000FF;
	Thu, 17 Sep 2026 18:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668522;
	bh=D+gOVvCDgd1aO/gXZut1UrXw5X4YlD7dKeqECNMAIUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCIqx5Hy+TK/LAiTHgN1X8zSRZPw7t1PKOM8xPPECvW1vjMA9EK3xyy1ba+9zbRbp
	 JsCc34GgVBu19MXqqUX/x4JLuE6iac2v80rvXjIYxd7HmsdzIDpRsO6e7D3NJ3nThU
	 MYK5xt9OaQdg/wIq+EkeCtxN1+h741n5QopVohZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0451/1102] ata: libata-core: Disable LPM on some WD drives
Date: Thu, 17 Sep 2026 16:06:34 +0100
Message-ID: <20260917151551.009570281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 356d8241cf3c7b07a4a491dbab43b5a41513ca86 ]

According to a user report WDC WD100EFGX-68CPLN0 and WDC WD102KFBX-68M95N0
have problems with LPM.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 89cb03a5e8888..816f756c5b094 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4317,6 +4317,14 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "WDC WD3000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 
+	/*
+	 * WD drives with LPM issues (irrespective of supported SATA speeds).
+	 * (Unlike ATA_QUIRK_WD_BROKEN_LPM, which is only applied if the drive
+	 * exposes SATA Gen1 speed support, and SATA Gen1 speed support only.)
+	 */
+	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
 	 * log page is accessed. Ensure we never ask for this log page with
-- 
2.53.0



