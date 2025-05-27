Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FFD280330;
	Tue, 27 May 2025 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364980; cv=none; b=GUVzhUMr2LfNSvLI+jkDiZtX2HADoVrWhUAE79w2DF1L9SwxfZsWOHHVrpD6JdAzCmMccFs7ZFvZfSIjc0DmuOwiMdxBVDObUyCwF9I+7vxigp+YbuZAu05Tnf9obSUL9351A73o953d/LgywHsUvk9H9qX4htuaCk2hA3Pjw5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364980; c=relaxed/simple;
	bh=M/f7h6nvEnwo0QC4NLrVmsDxr30rZg4UCrjCOXK1Y9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjEaqY1yAZgbMfLI37Bg6xQoXToaPvR5a+lH+scilZWBjAcbqlF0GZSqVqPJutuPhkYctr4cZcgb5P3RKtRa9uzyPyKI4zl1LbCRGx/qgQ780WNDlmPEbN+3h5UwG0p57Su60LD7UN701UD5RDj8Arf2t+I9b/pe8WAgZtjYqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmPCzJrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmPCzJrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA44C4CEEB;
	Tue, 27 May 2025 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364979;
	bh=M/f7h6nvEnwo0QC4NLrVmsDxr30rZg4UCrjCOXK1Y9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmPCzJrST6HWRAqyvbNwV+8MzyUL8mZHY3cFB/OFFj/7UskkRFpY9YbPhzhz+KM7L
	 83xsXX2YbF+8ofLr+EBSpYUPFwu0XFtmcSOfkjuuLh5p7jsV/3kOyyEAm/x6iW8nhB
	 IUTbnuUmLjLPPP6U4hcZ9nOZ8a1ddmZ4gXNlnTAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Choong Yong Liang <yong.liang.choong@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/626] net: phylink: use pl->link_interface in phylink_expects_phy()
Date: Tue, 27 May 2025 18:22:02 +0200
Message-ID: <20250527162454.323585958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Choong Yong Liang <yong.liang.choong@linux.intel.com>

[ Upstream commit b63263555eaafbf9ab1a82f2020bbee872d83759 ]

The phylink_expects_phy() function allows MAC drivers to check if they are
expecting a PHY to attach. The checking condition in phylink_expects_phy()
aims to achieve the same result as the checking condition in
phylink_attach_phy().

However, the checking condition in phylink_expects_phy() uses
pl->link_config.interface, while phylink_attach_phy() uses
pl->link_interface.

Initially, both pl->link_interface and pl->link_config.interface are set
to SGMII, and pl->cfg_link_an_mode is set to MLO_AN_INBAND.

When the interface switches from SGMII to 2500BASE-X,
pl->link_config.interface is updated by phylink_major_config().
At this point, pl->cfg_link_an_mode remains MLO_AN_INBAND, and
pl->link_config.interface is set to 2500BASE-X.
Subsequently, when the STMMAC interface is taken down
administratively and brought back up, it is blocked by
phylink_expects_phy().

Since phylink_expects_phy() and phylink_attach_phy() aim to achieve the
same result, phylink_expects_phy() should check pl->link_interface,
which never changes, instead of pl->link_config.interface, which is
updated by phylink_major_config().

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Choong Yong Liang <yong.liang.choong@linux.intel.com>
Link: https://patch.msgid.link/20250227121522.1802832-2-yong.liang.choong@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 3e9957b6aa148..b78dfcbec936c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1811,7 +1811,7 @@ bool phylink_expects_phy(struct phylink *pl)
 {
 	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
 	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
-	     phy_interface_mode_is_8023z(pl->link_config.interface)))
+	     phy_interface_mode_is_8023z(pl->link_interface)))
 		return false;
 	return true;
 }
-- 
2.39.5



