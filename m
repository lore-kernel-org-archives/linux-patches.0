Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B66023D298;
	Wed, 23 Apr 2025 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420200; cv=none; b=qUKWhshcPi1cyv6NcJyIcKaCFiuEN5yc+9lqoFSxfL1iL2FM7WMR0BvK1GDKp4h87xqpwEX/SpNqu0y6Jibx2tcdWSXsiaag+mHN9QfObtdlGyaaQXsEcaPYPSs6z2E2WecGYLh8UDdGp6/XZ2K7y8Thv7vFMvVTPQFKS+fVdW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420200; c=relaxed/simple;
	bh=xT78nCPnXjfGaok6iydY6I+PpDNunJBayZAe9fQMVgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udK+qXd5z4Q9lDwm8KNa8fTYBQ+Btw6UHYX5OwlmxLkAIDoLTdJYTbKgbNXLQS3/cGvlE3AA7aixT/f+WS6ga37WLpuAk4Msc/xficfvMlJ+JjAfiIHbDVYMEHfr+HJ0NIpKe3n84x2wKfplfViTmGRTp5tFta3yllbPpknw+VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKPM2GVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKPM2GVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F58C4CEE2;
	Wed, 23 Apr 2025 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420200;
	bh=xT78nCPnXjfGaok6iydY6I+PpDNunJBayZAe9fQMVgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKPM2GVaZsTfjYOKgvPyfEFsvRHTKryYFyLmtwrOTQ2gWS3PAAUSaMp4r/rGO5cTP
	 Rwz6tGu6JCLWG6FjOgFmACZEae3R7MNRfjfmRrfOT+BpVtnb1VgUVndgOKqcsDHK3x
	 vbbC1DO951LPXXRdc6j5vYoWAdcTbxdijZ3h6S68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 071/241] net: b53: enable BPDU reception for management port
Date: Wed, 23 Apr 2025 16:42:15 +0200
Message-ID: <20250423142623.496309789@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 79dc77835681c..3b49e87e8ef72 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -737,6 +737,15 @@ static void b53_enable_mib(struct b53_device *dev)
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
@@ -876,6 +885,7 @@ static int b53_switch_reset(struct b53_device *dev)
 	}
 
 	b53_enable_mib(dev);
+	b53_enable_stp(dev);
 
 	return b53_flush_arl(dev, FAST_AGE_STATIC);
 }
-- 
2.39.5



