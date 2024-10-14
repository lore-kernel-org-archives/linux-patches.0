Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCDD1AAE25;
	Mon, 14 Oct 2024 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916198; cv=none; b=FPHN0NBcXsgVhsbmXeJE36fjzghb+PTx18/AZqEWN1LJc/oPFXscUK6VRG2+qgnj2WELl5X7LD0zLxwq0986/jeqOa0sDb9W1gEhSYvBotgDe1QhAxmdwGNGQjvOgjBea8x5FkIxAOv2mA3YCWs7UQseaqxXJl7qCcWQdcB1liY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916198; c=relaxed/simple;
	bh=9U/g9mfvxr+VPDUmVXXnsAWQ3hIbMnt8caYE8R8ONQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7dR3lKrpBG9VO81cwQ1aZr/WHkFpNtGEJvCUbD5Ryl67Nm+O93aXOUm5utkM82G2E8latk6L+gorj0No6loVg9EWXRdCdXJvkNt1Fvd5dSC1A3m4jcba4jluOYcXYSg2Fk4tzmXMvqdlnhePKMw/fzfCrdlj0JMwYpOFdS0DsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVkFGR4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVkFGR4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D64C4CEC7;
	Mon, 14 Oct 2024 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916198;
	bh=9U/g9mfvxr+VPDUmVXXnsAWQ3hIbMnt8caYE8R8ONQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVkFGR4s+C1Sz2CXhzlxuWzKOM/f8nS7wTMCCf3s3x6CNqcOloDXAobiC5LPye99m
	 9wNUjtPngey4Pg9T2P5VxL3B6yz0m2LWLgj3Yxt+znZ92tQ5Yv9hg6Cypqy43SZmyn
	 s02/nbvsn2FwIMrPjNUlYyV8n9M682J3Cu+74p28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 111/214] net: dsa: b53: fix max MTU for BCM5325/BCM5365
Date: Mon, 14 Oct 2024 16:19:34 +0200
Message-ID: <20241014141049.327755546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit ca8c1f71c10193c270f772d70d34b15ad765d6a8 ]

BCM5325/BCM5365 do not support jumbo frames, so we should not report a
jumbo frame mtu for them. But they do support so called "oversized"
frames up to 1536 bytes long by default, so report an appropriate MTU.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6fed3eb15ad9b..e8b20bfa8b83e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -225,6 +225,7 @@ static const struct b53_mib_desc b53_mibs_58xx[] = {
 
 #define B53_MIBS_58XX_SIZE	ARRAY_SIZE(b53_mibs_58xx)
 
+#define B53_MAX_MTU_25		(1536 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 #define B53_MAX_MTU		(9720 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 
 static int b53_do_vlan_op(struct b53_device *dev, u8 op)
@@ -2270,6 +2271,11 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 {
+	struct b53_device *dev = ds->priv;
+
+	if (is5325(dev) || is5365(dev))
+		return B53_MAX_MTU_25;
+
 	return B53_MAX_MTU;
 }
 
-- 
2.43.0



