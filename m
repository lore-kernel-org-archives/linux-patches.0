Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D52230BED;
	Mon, 10 Mar 2025 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626972; cv=none; b=kggwmFv/ljEQEKuD0Y+ZZARqIGn4gMZfRxLVax6tgLJHp2Dz1iQxbMPMvuZ+Mv3wu5DShIRL55rgq61+uYcH1sV+rz2FRMwu6ZaUaCJl+kmqNiyzKb5elxoNUmk9nNQpaE1u3CfiqVRrmFhYolqO5r6oKUI5OSUp9XSEN7KWxaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626972; c=relaxed/simple;
	bh=Me07l6A8+smu5n1QZjXvuXA3jV+H0OfXLyP1DY0vfDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGMZnjeNgPElNhtIubN84q+YiZHu3zTR1p4vJvo1H2iX9Ci+DkzcPHM6kYhEmUAh7iuV4IAqabNBWMeC/iDAomq0pRpRpfyMYTF70W5r2z7pXwgOcDn1v0hYGX+BXGHwGWHKfGWV+y1RDnO+jAhNXYBWkM4747JeaXd/cPI2LXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka7wUNhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka7wUNhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACBAC4CEE5;
	Mon, 10 Mar 2025 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626971;
	bh=Me07l6A8+smu5n1QZjXvuXA3jV+H0OfXLyP1DY0vfDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka7wUNhyMKnbgWVqYlUSV65FtpHPTM12/FvVXuDrMHIAFwSh1r1ub2s0pLcaeopZm
	 7kfaAX1r+jgOb8Y0yDoAndQMMoeTeS3wW1W/nsE3jRWVH1FDrSX3fRcQP9I0+TiiN9
	 tHN+ql14g4sx6/iR5HB85FlEciIJgFR5ZKFUxdrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 145/207] net: dsa: mt7530: Fix traffic flooding for MMIO devices
Date: Mon, 10 Mar 2025 18:05:38 +0100
Message-ID: <20250310170453.561965388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit ccc2f5a436fbb0ae1fb598932a9b8e48423c1959 ]

On MMIO devices (e.g. MT7988 or EN7581) unicast traffic received on lanX
port is flooded on all other user ports if the DSA switch is configured
without VLAN support since PORT_MATRIX in PCR regs contains all user
ports. Similar to MDIO devices (e.g. MT7530 and MT7531) fix the issue
defining default VLAN-ID 0 for MT7530 MMIO devices.

Fixes: 110c18bfed414 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://patch.msgid.link/20250304-mt7988-flooding-fix-v1-1-905523ae83e9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 086b8b3d5b40f..b05e38d19b212 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2591,7 +2591,8 @@ mt7531_setup_common(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	return mt7530_setup_vlan0(priv);
 }
 
 static int
@@ -2687,11 +2688,6 @@ mt7531_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Setup VLAN ID 0 for VLAN-unaware bridges */
-	ret = mt7530_setup_vlan0(priv);
-	if (ret)
-		return ret;
-
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
-- 
2.39.5



