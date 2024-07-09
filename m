Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D8A15A843;
	Tue,  9 Jul 2024 11:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524146; cv=none; b=B03zJhOSYLY0vrHwOWOAp7agIH0pem5RK5nDg2m0vMNEq6pMC98hmV4r7UCC8Rm7DH1x+QLxEFyH+A89oHGnXLG2orohHBKyaJRU3PYL+QxhcPyCvDwXCmnAXroyWtjhQoYyQEPMqnteZiPGD0wi+dQ+z4rL3F3LPmwCmWCNDYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524146; c=relaxed/simple;
	bh=O4/tzaqi7k26c6GmegL+sPptTCOaPxdeBLTkjTJrL8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIaqSEpVp6MwhDbOJ5Z8TKU0uf0T5Gcb6TxWsAkgCR8Tm847sfE7Nqm24/dPpAcF0jqgUio5kHVKTvmmYl5Dldfu+SSKvhX6hxbtMu9nY0pKZuCkk54I8EqLHZcbEj/3CVC00DFE+q38KyYTO9BfPridWFSgjYrmMmt6e8ve0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6wBpvGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6wBpvGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8321BC3277B;
	Tue,  9 Jul 2024 11:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524145;
	bh=O4/tzaqi7k26c6GmegL+sPptTCOaPxdeBLTkjTJrL8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6wBpvGsiNxYP0HJt69KpSNmVMqTj8cRSyDF/XaviJCCppRDlFGKgt8QrUTR6jG7M
	 FdMx/tNekwAzJuOoNIhcw9SohvXYlCyrKPGX0Y+sq8V02ZZOL4QrU4NXcCbtcJ8A9q
	 V7CtBnp8nuws40rMdSymw0u5+Sc5fyz7v3Jvq5aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 085/197] mac802154: fix time calculation in ieee802154_configure_durations()
Date: Tue,  9 Jul 2024 13:08:59 +0200
Message-ID: <20240709110712.255551177@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9ab7396668d22..21b7c3b280b45 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -161,8 +161,10 @@ void ieee802154_configure_durations(struct wpan_phy *phy,
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
 
@@ -184,10 +186,10 @@ static void ieee802154_setup_wpan_phy_pib(struct wpan_phy *wpan_phy)
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



