Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82FA296D1D;
	Mon, 12 May 2025 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071891; cv=none; b=gRoUdgjr0nenPVuBA6SH2tAzwAra9j7QXQ4e6q85xWUpgoTgF74ZFcHw7kcZQ8QfPZpRqIFnhgQNnwUZ/tZTeYAmIs5saraG9vG13O1/FtuBqlo0IRFa+vNhvssOeLIy7OLRw6MMJuIVNg48smlnk1D5NwH6+DxHiFMyUoXi64k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071891; c=relaxed/simple;
	bh=gWzUg250QMqWZeJBp1zxyOu9HVA+nxdgvZ3vHCTlGkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F60S5VDngYtARgNEDNhK4R9Fx7y9mfvzNGChE9d9hul8+tM5OtQB1GEM6QIT4cRnuJafd21OLfyJqEHhL91VCKwtCKb6mU5gFYfQJ/LAtijXyO7mXPc24Pn9OK2wuSO0UUVVhfS5sYF5pTC+XAdkC1euFwgzo/Fm9vNINK43XKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wspixLJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wspixLJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6CDC4CEE7;
	Mon, 12 May 2025 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071891;
	bh=gWzUg250QMqWZeJBp1zxyOu9HVA+nxdgvZ3vHCTlGkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wspixLJkNhyjErDcF42dv56jThiIhx9XGQrdagS9REoz5MLUr7waVreKmLblfBLvt
	 L/Kq68UuxJCQTgptPvinFpvdGiLUM7eR3zbkoJgnCF7rZRLeNtJ1lLx5keQAq57KLI
	 9xzEttYZG0U0gyBGmBGxCakvbxss92Rmx8b63SQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 037/197] net: dsa: b53: fix flushing old pvid VLAN on pvid change
Date: Mon, 12 May 2025 19:38:07 +0200
Message-ID: <20250512172045.883522864@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

[ Upstream commit 083c6b28c0cbcd83b6af1a10f2c82937129b3438 ]

Presumably the intention here was to flush the VLAN of the old pvid, not
the added VLAN again, which we already flushed before.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-5-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fb7560201d7a9..e75afba8b080a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1574,7 +1574,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (!dsa_is_cpu_port(ds, port) && new_pvid != old_pvid) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    new_pvid);
-		b53_fast_age_vlan(dev, vlan->vid);
+		b53_fast_age_vlan(dev, old_pvid);
 	}
 
 	return 0;
-- 
2.39.5



