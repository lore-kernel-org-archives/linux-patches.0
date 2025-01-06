Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B28DF71;
	Mon,  6 Jan 2025 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178135; cv=none; b=lG4z6+OolJ/pEIsBPcO+cCNVPZ3P+ECdUKXIhq/8pWkhl10MvRMzRVsLTa47m+I9NKX4C+OA8E7XBDhDRZFcHnG40v191n31GXi0tW1kjqN0iI4CtXJJE3ip8eqk8tZxUivWWn49CexP6RH/lLZWCDv464DK16Hdxyj6K4ieQl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178135; c=relaxed/simple;
	bh=0lSMRdDokC6BuvealOXeLMSDPnHLhm9W4Tf2NWjnxCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX3vs6oRLm7p8g4qBPaux1bN9yJSbpGbQwpDhuYDoH4OPCq+x4KG17jxz+95hMaaewDToBTU9Z2VoQPGSqVizdCHijbw86mGrociakBOC95SinL/bIBTCDbKslzjBoRngj8fC8sOzlnndOZ9c86zVVfoUhwlg7ltHpHx9OgKw0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8c/wtJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8c/wtJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AC1C4CED2;
	Mon,  6 Jan 2025 15:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178135;
	bh=0lSMRdDokC6BuvealOXeLMSDPnHLhm9W4Tf2NWjnxCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8c/wtJePVJRH0N1kvtz1Lei32mWqEjmw99rKaUIXBD10ubyEjMdu17sOtwzLjEvc
	 0qLG6TLwEMvmfbihp2EMRF8/75CVVW2sXrRi5pYRcSGHGkLFRONGlG1btoR3bAOeym
	 BTv0TXkqvyloa3wPVdZnCRWv3d+wOJxJaJz8IVAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/138] ionic: use ee->offset when returning sprom data
Date: Mon,  6 Jan 2025 16:15:41 +0100
Message-ID: <20250106151133.871862360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit b096d62ba1323391b2db98b7704e2468cf3b1588 ]

Some calls into ionic_get_module_eeprom() don't use a single
full buffer size, but instead multiple calls with an offset.
Teach our driver to use the offset correctly so we can
respond appropriately to the caller.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-4-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 8e5b01af85ed..d0a613fac9ff 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -835,8 +835,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
 
 	do {
-		memcpy(data, xcvr->sprom, len);
-		memcpy(tbuf, xcvr->sprom, len);
+		memcpy(data, &xcvr->sprom[ee->offset], len);
+		memcpy(tbuf, &xcvr->sprom[ee->offset], len);
 
 		/* Let's make sure we got a consistent copy */
 		if (!memcmp(data, tbuf, len))
-- 
2.39.5



