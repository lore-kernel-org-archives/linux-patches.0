Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF91DDC12;
	Mon,  6 Jan 2025 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178555; cv=none; b=VQ26dIzhhrWXatC3d2gwdIs4KDF85zFtvEzECIRn0qTaIV/3cAd7hRs9avDwScuMuWaGgxnQjWOh4wKSQP91wMfC39w2kR0tMx9bob7C1CXJG01shpjc1G7iEylREEqdfrxBBpA6BrC7l7jHb8To/pDqxGtcRU4bvmwJG5wHUUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178555; c=relaxed/simple;
	bh=qh2+g4BC9Gpb4bqm6szuBEUiabWgMzzKrES4BzsOIIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuvWgtdJzTEhQaaogyR+ZowB3fvAZUTHqQXohkCn4gD5bC75A1RucUBNBOqfmn2gScSDUsuSOKLZTL9CvNePry9y1u2jqAiVd2aLOdgOThJC+Z9gzsZfuXFXgCajsrjVPDTqfS4uoQB1bF0l38gFl7xIuEbL6o4Xg1u0vDxFtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEUKSHu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEUKSHu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD9BC4CED2;
	Mon,  6 Jan 2025 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178555;
	bh=qh2+g4BC9Gpb4bqm6szuBEUiabWgMzzKrES4BzsOIIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEUKSHu6rqOBpDS7L0uW7OXVtW4rzxjb+TI0cvCY/32QA6vUyRcc24knSHs//RAUj
	 um4/15VS3MhikxzYdPDF/M/UmGLSgcFtVRCRtJB/VKqPwOg4OCGtEoJvW5a1fFX30Q
	 VuVmvihqOdAABds6prA25XqC7VL6IRc2zD6GBFrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/168] ionic: use ee->offset when returning sprom data
Date: Mon,  6 Jan 2025 16:15:27 +0100
Message-ID: <20250106151139.188573402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2fa116c3694c..8d459d563416 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -861,8 +861,8 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
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



