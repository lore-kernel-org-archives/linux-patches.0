Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7679322A2E;
	Mon, 18 Aug 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525408; cv=none; b=I75/XZ3tdVzslXs+z34hiBxa9UDc1Ky0LesXvAvyv1P5jhtBcvomDFoIeNFWRwvMtyvo/tee+4rtB8i1i6IdqUqoMP0e8WWFjEr6P8go9oWTq+TYTP8CvkHnHCkFZV44foX09wVtlsi4ptrXbeVoNafMQG9cuyZs0ekp567MoQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525408; c=relaxed/simple;
	bh=wJ9+JRbHGxbHXNqOiYWFfehqdxvC6lkslto//RFFs/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3QnT/GjIq1nnEPrYgYQrNCnBXgwXjBtHERLut5EYdlzbKfJpDyWjwUZyiN6M8bAo0bYwEcWSFF+FRxLvzjbK0I6mz81sBz2e3X9j0QiNBK/YoTlI0ujKs3JO/XgA0XJFTDBkvqOeOfp7r83IHLLcUnNFqcO+4nueAbRIkk0yvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvA+5xN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvA+5xN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF38C113D0;
	Mon, 18 Aug 2025 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525407;
	bh=wJ9+JRbHGxbHXNqOiYWFfehqdxvC6lkslto//RFFs/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvA+5xN4Z/DrdZkdSW0gfuUJpC02OOPquXFz2xKj/yKXlvRxmAwzhYQMT1qXgM2Gm
	 Gl4j0I/jg6ET4EObAub832AzgRvb2FAau3QBsuYbVX2PrNrxME1vINX11lgvTVqMbn
	 zKIsCOX16Uwpd/7aAkP05RAqvpmvU8JDsDr3Bf5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 254/570] wifi: iwlwifi: handle non-overlapping API ranges
Date: Mon, 18 Aug 2025 14:44:01 +0200
Message-ID: <20250818124515.603637700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 6fdd41b25fb4154bcde7a38ca1c98e072fa1177c ]

The option to set an api_version_min/max also to the RF was added.
In the case that both the MAC and the RF has a range defined, we take
the narrower range of both.

This doesn't work for non-overlapping ranges. In this case, we should
just take the lower range of both.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709200543.1628666-2-miriam.rachel.korenblit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9504a0cb8b13..557a97144f90 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -298,13 +298,17 @@ static void iwl_get_ucode_api_versions(struct iwl_trans *trans,
 	const struct iwl_family_base_params *base = trans->mac_cfg->base;
 	const struct iwl_rf_cfg *cfg = trans->cfg;
 
-	if (!base->ucode_api_max) {
+	/* if the MAC doesn't have range or if its range it higher than the RF's */
+	if (!base->ucode_api_max ||
+	    (cfg->ucode_api_max && base->ucode_api_min > cfg->ucode_api_max)) {
 		*api_min = cfg->ucode_api_min;
 		*api_max = cfg->ucode_api_max;
 		return;
 	}
 
-	if (!cfg->ucode_api_max) {
+	/* if the RF doesn't have range or if its range it higher than the MAC's */
+	if (!cfg->ucode_api_max ||
+	    (base->ucode_api_max && cfg->ucode_api_min > base->ucode_api_max)) {
 		*api_min = base->ucode_api_min;
 		*api_max = base->ucode_api_max;
 		return;
-- 
2.39.5



