Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29734545;
	Tue,  9 Jul 2024 11:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524621; cv=none; b=cLlEINXBrPVPIZ9JVopUciFY1jiic8+pyYC60WD/mhUFR4l1YbJhkcz2/+iVFjYraoKOLqQ/bM2exPvbBYzOcKTsFaSpSVbpx8K8dViGvtRtWFWQU1/TKe7l4wcPfsO5/B7XSZQ68UI1bX6DVi4svUdmX7eT9O+jalTyFSXioHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524621; c=relaxed/simple;
	bh=rzaoArMU2mnaZThEJWN8ohs0FNxEYQimj3LneHBHF9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaW4tDwnAJaoiRoOYAhxIQdvVVUIuvQWBUZZRgvSYA3IlCXJDck6g9xoQ2ay/jfFM5Mxde6EqGM0SELZwAeZ4LMcV8PPaVMo9jpyZPn9mKFXeWDxLVQYVTrmg5OJ6X9XK1VCPwj97HEPQF3xQlwRwDJFhrd+inqRgWb4CiTFanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izx6u+/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izx6u+/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99ACC3277B;
	Tue,  9 Jul 2024 11:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524621;
	bh=rzaoArMU2mnaZThEJWN8ohs0FNxEYQimj3LneHBHF9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izx6u+/nBUcvjOomVUrVVvHQIUiU2YlsnTOEg6s47bDvQwF90k8iqFtXBBh7pRkBQ
	 mn0bEMhTsVJjordOwjgV63JOSYIsxHsvHTzwStMQs44iRbPGGGp1TcoC4ZnUjDkrO/
	 +KeWx4tb3qlphs+1SZJB3cPuAk6RN8xU9X8IUUsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/102] mac802154: fix time calculation in ieee802154_configure_durations()
Date: Tue,  9 Jul 2024 13:10:07 +0200
Message-ID: <20240709110653.087504618@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 07aa33988ad92fef79056f5ec30b9a0e4364b616 ]

Since 'symbol_duration' of 'struct wpan_phy' is in nanoseconds but
'lifs_period' and 'sifs_period' are both in microseconds, fix time
calculation in 'ieee802154_configure_durations()' and use convenient
'NSEC_PER_USEC' in 'ieee802154_setup_wpan_phy_pib()' as well.
Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 781830c800dd ("net: mac802154: Set durations automatically")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
Message-ID: <20240508114010.219527-1-dmantipov@yandex.ru>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index bd7bdb1219dd8..356e86c3c9b15 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -152,8 +152,10 @@ void ieee802154_configure_durations(struct wpan_phy *phy)
 	}
 
 	phy->symbol_duration = duration;
-	phy->lifs_period = (IEEE802154_LIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
-	phy->sifs_period = (IEEE802154_SIFS_PERIOD * phy->symbol_duration) / NSEC_PER_SEC;
+	phy->lifs_period =
+		(IEEE802154_LIFS_PERIOD * phy->symbol_duration) / NSEC_PER_USEC;
+	phy->sifs_period =
+		(IEEE802154_SIFS_PERIOD * phy->symbol_duration) / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL(ieee802154_configure_durations);
 
@@ -175,10 +177,10 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
 	 * Should be done when all drivers sets this value.
 	 */
 
-	wpan_phy->lifs_period =
-		(IEEE802154_LIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
-	wpan_phy->sifs_period =
-		(IEEE802154_SIFS_PERIOD * wpan_phy->symbol_duration) / 1000;
+	wpan_phy->lifs_period =	(IEEE802154_LIFS_PERIOD *
+				 wpan_phy->symbol_duration) / NSEC_PER_USEC;
+	wpan_phy->sifs_period =	(IEEE802154_SIFS_PERIOD *
+				 wpan_phy->symbol_duration) / NSEC_PER_USEC;
 }
 
 int ieee802154_register_hw(struct ieee802154_hw *hw)
-- 
2.43.0



