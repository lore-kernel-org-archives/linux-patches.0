Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D11FC7C9;
	Tue, 15 Oct 2024 13:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998461; cv=none; b=U4Bt719Y42uFnIQffaep5PmS0Hj1mwxveMm4bJ+QPAbgLbvuWWTzvxlSelBcc5sST/H0YXGH8hpCxGbXtEThceE2VM9dripTpqg5i+uOZJFAo0J2Xju2Vxvpc+e8LD2m53LJ2pUNyOHK7n4FSvRkhiUvPOoW2/XHrFbs2c6+IiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998461; c=relaxed/simple;
	bh=WcyQRZyLCKMDF+2sqK9nidpm4938Ujji7V8irGjoYWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQnq+fonO9+bl7BQQbN+TSLfBF7QJBTZlj4QS44B/CIs1p3zt63tpINi8h8UvzKoNhdkahNHrUNJtIXsEqaR1J6sgETi9ihOdwhG4dW5Jwvh03CPQjweWV95Je8OMzjypjwxzbjSjhRw0z3zJEuzGtmVeCptpya2G7EWw3k+SBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rR1nh0AF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR1nh0AF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B3BC4CEC6;
	Tue, 15 Oct 2024 13:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998461;
	bh=WcyQRZyLCKMDF+2sqK9nidpm4938Ujji7V8irGjoYWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR1nh0AFbt76IP83mrzV5ZvsafYp1j3AoppPx67CcT7XnV2X5Z63tSOivYCc9un25
	 tkWx0f9K9Ic6NIEpmJuibCEQsDrhRm/an1a15G2IVgh8FBlLfG4HxmPQDk7gitQQCA
	 OSLmsvSFAXMfxrtvOotvjQwDrKocllE4otgF70L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/518] net: dsa: b53: fix max MTU for BCM5325/BCM5365
Date: Tue, 15 Oct 2024 14:46:28 +0200
Message-ID: <20241015123935.680569554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f7ae17ee6a32e..eea4d61a354cf 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -225,6 +225,7 @@ static const struct b53_mib_desc b53_mibs_58xx[] = {
 
 #define B53_MIBS_58XX_SIZE	ARRAY_SIZE(b53_mibs_58xx)
 
+#define B53_MAX_MTU_25		(1536 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 #define B53_MAX_MTU		(9720 - ETH_HLEN - VLAN_HLEN - ETH_FCS_LEN)
 
 static int b53_do_vlan_op(struct b53_device *dev, u8 op)
@@ -2194,6 +2195,11 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
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



