Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A97BA34;
	Mon,  6 Jan 2025 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179052; cv=none; b=tswIeMhNzZLciYIVzWYKUGQPu6cYPiAWuGXioE1sZfe1iNizfa7l+feH50SvWxEYwRn5V26h/Fmu1n/B44MMXxbjLVxWz4ZkZhGqEMIk7AldXwmZJfwGuNvTKbU6gzctiSeUuNVkctClmVi1BEs0FhA7L7Q28aM417sADpGFa2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179052; c=relaxed/simple;
	bh=V1rgS+B8b+NMIVNmZwAv2K9nV4trQwrabpgKClo1SgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB3XMIRWhWPSlD9ZsJc9kWKCKjPlGa8ebyvqAS6GrO2FE/zAg5MI7XHTz6/sBB2KPD47EKVlcKvyD2wMp3dopaODUEeB4xI4Xq14NOWVltlLyMF8/xoPUi9cvj5I3RAl6bXtICW6QDXabw/y9RDKUphVhMEBLxX2bntAg1fWq2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKAt667u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKAt667u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA32C4CED2;
	Mon,  6 Jan 2025 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179051;
	bh=V1rgS+B8b+NMIVNmZwAv2K9nV4trQwrabpgKClo1SgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKAt667uMQoBOeLtzw2OnzkVu7RIh/WnostwvC+ZesgTudAjvlyHPyX7QDuUbxI65
	 6hMKtqSDNpmgh8QQDeA+THyJwb/LspYLGYEd+p/dF2dhQuQkm0z1DndvHbRg20Q74B
	 pDuFOtl5XMQBr/t0aX9EopOXdxdO79NklPhSsfco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/93] ionic: use ee->offset when returning sprom data
Date: Mon,  6 Jan 2025 16:16:47 +0100
Message-ID: <20250106151129.126583523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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
index c53d2271d8ab..dd4b89c90d67 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -711,8 +711,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
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



