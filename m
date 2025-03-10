Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF59D2253FE;
	Mon, 10 Mar 2025 17:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628104; cv=none; b=XUmy+1Dh8K8jVFE16qLkeyOclyc0+5wwB+HCe5u4wkTsb2IHJ3JZVm6nd8RODpqMBdykGsSv34Bm0MpGJISIbUQcUh/zQeOatMNtdZaPj7K2u354g+VXPYckuPUDub+f9x9ESqM9VmYfJ0mMWBJ3nYAiYIlaUsSDhmQwzHrFN/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628104; c=relaxed/simple;
	bh=2ix7QSPHf8HWJymzibF8iprWvkpSNNzoOqr+mv/WzS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMtjBqBb+DE4g5ICBKuJ28CwyMEEeseUNIvt1+xcMAfm+qlpGGzKlbWvM27Ay9o7bX1KfjcP3snHp8kNp49sgOUUn/rLqh8qG6Ern/k7K1JWwWRlFT9rWw6slTvq+OCRQga7Lm8w6pD6Ieof/Brh6xHIuY/bWzAPZZZYkJCE5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSku3Wje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSku3Wje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D84C4CEEC;
	Mon, 10 Mar 2025 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628104;
	bh=2ix7QSPHf8HWJymzibF8iprWvkpSNNzoOqr+mv/WzS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSku3WjeqWvDkqkh+lHSGrGrbixFKNYMBe3AJzHW7dPCUwofuRnjPkAuWCraNOBGY
	 LXgYXRGV+pCXKDWeydOlnx8TqWfOaXPuKwogroBgGaWhkf9ioIfnhP0iTW884fohbI
	 Ad3G7TklfpjM8xqvKGsU5Q7ywU8OSh3/KcsZKETA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/145] net: dsa: mt7530: Fix traffic flooding for MMIO devices
Date: Mon, 10 Mar 2025 18:06:22 +0100
Message-ID: <20250310170438.309354193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53ead0989777f..90ab2f1058ce0 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2640,7 +2640,8 @@ mt7531_setup_common(struct dsa_switch *ds)
 	if (ret < 0)
 		return ret;
 
-	return 0;
+	/* Setup VLAN ID 0 for VLAN-unaware bridges */
+	return mt7530_setup_vlan0(priv);
 }
 
 static int
@@ -2734,11 +2735,6 @@ mt7531_setup(struct dsa_switch *ds)
 
 	mt7531_setup_common(ds);
 
-	/* Setup VLAN ID 0 for VLAN-unaware bridges */
-	ret = mt7530_setup_vlan0(priv);
-	if (ret)
-		return ret;
-
 	ds->assisted_learning_on_cpu_port = true;
 	ds->mtu_enforcement_ingress = true;
 
-- 
2.39.5



