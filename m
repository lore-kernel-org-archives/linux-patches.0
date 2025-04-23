Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED0728DEF0;
	Wed, 23 Apr 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421979; cv=none; b=jHWilFDJGSl3fSaOFY0elSOTfgGFACbBigay488+VO2IUvsvSLeadxu8ZMQYwRtsLBLmTFsJlBj0ZHEYDlhb2mIpWuvF9xpLDj+YN+ysDyjNc4VRJLS5GBWxsQC4huMWfxK2sySotoqLd6S2gOKTKszT8u3Oe0j8yWu3iST8hoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421979; c=relaxed/simple;
	bh=VDp6i5JumPudVZT4wElQWWyRTytqN/4shxkjHsixKEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATXy+neDptYJglE12LtaB8RTAagI6C4LEoi6WaEnbJjdPGMCmrwIeG/Lxv43sFS+FOSPd5MYSXx492Mmaxmsb+r9/qSaTyCpEDyBFE4nub4csp1xXpx7jFVvpuZ28Mc9UlARMIQxexxv8e43aGvS0fVjL8nQVr2Vj2WtKE5r1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYB7l5A+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYB7l5A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E65C4CEE2;
	Wed, 23 Apr 2025 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421979;
	bh=VDp6i5JumPudVZT4wElQWWyRTytqN/4shxkjHsixKEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYB7l5A+SHGzB+aXbt/yQc2l1Vmtzs9mGqTfaql74+8zPV54EYdWJ333KjZIbHIiR
	 FK2qhFXZ4exoixs8ds3Ph1Z9NULOx2BcjNWhBgOzkCRhkzLZiAjYsJa/WbginL9uza
	 BB0uosoOZGfpGgwYzK37VM5u7+/NfcRnBzrlVUAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/291] net: b53: enable BPDU reception for management port
Date: Wed, 23 Apr 2025 16:42:57 +0200
Message-ID: <20250423142632.064510922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 36355ddfe8955f226a88a543ed354b9f6b84cd70 ]

For STP to work, receiving BPDUs is essential, but the appropriate bit
was never set. Without GC_RX_BPDU_EN, the switch chip will filter all
BPDUs, even if an appropriate PVID VLAN was setup.

Fixes: ff39c2d68679 ("net: dsa: b53: Add bridge support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250414200434.194422-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 463c6d84ae1b0..ea7d2c01e6726 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -724,6 +724,15 @@ static void b53_enable_mib(struct b53_device *dev)
 	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, gc);
 }
 
+static void b53_enable_stp(struct b53_device *dev)
+{
+	u8 gc;
+
+	b53_read8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, &gc);
+	gc |= GC_RX_BPDU_EN;
+	b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, gc);
+}
+
 static u16 b53_default_pvid(struct b53_device *dev)
 {
 	if (is5325(dev) || is5365(dev))
@@ -863,6 +872,7 @@ static int b53_switch_reset(struct b53_device *dev)
 	}
 
 	b53_enable_mib(dev);
+	b53_enable_stp(dev);
 
 	return b53_flush_arl(dev, FAST_AGE_STATIC);
 }
-- 
2.39.5



