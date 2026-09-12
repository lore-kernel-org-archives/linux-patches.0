Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DFE34AB14;
	Sat, 12 Sep 2026 10:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209108; cv=none; b=rtXUWQ9HBKe5Dux4SZQCRnIzxsH0RM2+jF/REVFE8sSS0L1a5evrvlLdvEHs7hdHoDllj9tcgD0wPpDYV7p1DBxkjlOEFn5dQAGAhAiv3zkGS3Q0DD4wdbruoCZtCRvgBM2dhCeLfhztCu4vjlJjOC3ONYq1fdtVorwltaWxvC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209108; c=relaxed/simple;
	bh=RUa3zHJydfeWLYwC2OsD6ebLbOhriKfpFz8omR/vcjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwHabSL1+fIkL538y+68SBE6A1glyptrVdTvuGrkkFA+qQgYI2yINIn/RVGJy9k7ZyZAGKEk9DMlKysIA8m8VO6w/xO0uyXQT47HrLwiXTRpUIIOsUrc7jIBdRhOC1ZxlZg6PBrLFfte8PHUrLIM3gADWKnvv17RRaSm7oNtiZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/J3UlGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/J3UlGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7C91F000FF;
	Sat, 12 Sep 2026 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209107;
	bh=f1yHqVUYlwIUTiHBTPbWOa/YgBDpI+HiT47aJyoXlb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/J3UlGGqLcqjdXXz73vliMIBkOJtmncqjB6GHllq/xoJZmruNGxXvDGa5zMWrKAE
	 kpD1E3JTB66DRFMDa1EHzjATxdLrwJS8YZkOmKvugcD0wwbSCcImEkH3B57F8mBRmD
	 OEm90YopxqLaDv0OTeIqOwgsP8rMXQqQPpiCEcrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0754/1518] wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
Date: Sat, 12 Sep 2026 08:48:43 +0200
Message-ID: <20260912065640.487089126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit dd59a6126a8f1bd52bf6bd057bf0c8307f76a74b ]

The clock enable path for the second adie sets MT_ADIE_SLP_CTRL_CK0(1)
but polled the busy bit of MT_ADIE_SLP_CTRL_CK0(0), so dual-adie
bring-up could proceed before the adie1 clock was stable.

Fixes: 99ad32a4ca3a ("mt76: mt7915: add support for MT7986")
Link: https://patch.msgid.link/20260722082610.2699628-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
index c823a7554a3ac..df641c1334809 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/soc.c
@@ -913,7 +913,7 @@ static void mt7986_wmac_clock_enable(struct mt7915_dev *dev, u32 adie_type)
 
 		read_poll_timeout(mt76_rr, cur, !(cur & MT_SLP_CTRL_BSY_MASK),
 				  USEC_PER_MSEC, 50 * USEC_PER_MSEC, false,
-				  dev, MT_ADIE_SLP_CTRL_CK0(0));
+				  dev, MT_ADIE_SLP_CTRL_CK0(1));
 	}
 	mt76_wmac_spi_unlock(dev);
 
-- 
2.53.0



