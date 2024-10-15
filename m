Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28921EABD2;
	Tue, 15 Oct 2024 12:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994213; cv=none; b=DAhuh7cznewOPphyt4c3F+bJoojufuqZd87NDzgNbOzXvf5PxwsvaInpZgikF5kqLUjkQD6EqVXBfMdUe27edK3LxYZP9Kfo9M1E2Ar2AgB+uoabugFw4fsXU96TqWBuGdYHWGzPHDtpXBxZKNEBICK3knZZ8P42Jw+TXiu6a1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994213; c=relaxed/simple;
	bh=c0c7Tr8v9GKW2bIYeNly9hlwDEPvY3mBPMZCpTpzH4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L29Asogh9+e5MNb95rpCPSdfttg/wp/hB/iGfcASczN4Ey61/O/zTpew805S6WgPep2Ls4TtzWMsy/HeRE2Nn0AXLOpir330pmok9Ov4yHjm+05X+xTVeXqSHuarw1lffta3N8QQ2Ok4ygwMO4ZTYCbMQMZmCzW8G/UYw5CvcAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS9ghUh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS9ghUh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D3CC4CEC6;
	Tue, 15 Oct 2024 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994213;
	bh=c0c7Tr8v9GKW2bIYeNly9hlwDEPvY3mBPMZCpTpzH4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS9ghUh7y2TXUODLxMx5qPBszxOMSlxpwEyxW1BM5B5BIldFagjCVXn80GweAm8MS
	 0AfcPWMcCnaX9ftKWJX91C1Dyy3jCoWGAAdOOEZp3TdUCRBEPLVMoJ+zNfd1CdXKqz
	 Qf2i/NTaPSb/BksoPEbOneAKwcEJfx97U7bIMAEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/691] net: dsa: b53: allow lower MTUs on BCM5325/5365
Date: Tue, 15 Oct 2024 13:29:47 +0200
Message-ID: <20241015112505.689681183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit e4b294f88a32438baf31762441f3dd1c996778be ]

While BCM5325/5365 do not support jumbo frames, they do support slightly
oversized frames, so do not error out if requesting a supported MTU for
them.

Fixes: 6ae5834b983a ("net: dsa: b53: add MTU configuration support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3aa0a60d7c71e..cc030f8789053 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2225,7 +2225,7 @@ static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
 	bool allow_10_100;
 
 	if (is5325(dev) || is5365(dev))
-		return -EOPNOTSUPP;
+		return 0;
 
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
-- 
2.43.0



