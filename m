Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0F51DC1A7;
	Mon, 12 May 2025 17:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071023; cv=none; b=AwPwGnqZag9ZQiS1KVH5lFfOB/XiJqpGsCDh3VnfqP745lxpljnLyZEUGG6DIR8hyeQZL+g8VByGjpJwSZTZNSNX5Vy3C7YltthlTOuDkgKPxfILhNh6TA4DDlHAvbdaIwQe9VG+v2FKBpaUYq/Ak8ximDYg+Sg5qaqQgHQ8bWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071023; c=relaxed/simple;
	bh=BYFZqDGGLjsmii8MhKq9jKmVtY1MIrXj2y/ztz0LvYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb1eLST9AanhgtRzD2Ood57d+nMI404ez1/cR7HGzqPpEnBxp/pxMwcA00EsUBu45Ol68acYcoZ089CcwQbowiBtcOEamNFgBRaahSt2tREohTwBYmXT3G6fOuqMKjTm7TcixadZ1xqvKFYhfkph8px5o7NgRa3Zc/7pqfXudHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMGWIV0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMGWIV0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57CFC4CEE7;
	Mon, 12 May 2025 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071023;
	bh=BYFZqDGGLjsmii8MhKq9jKmVtY1MIrXj2y/ztz0LvYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMGWIV0E3yFulqjZ5dnr03ub5R8FYz04LlarkrmUYkgz3t1D4w5uJTfEDSx46bLat
	 QMp6Il7ZB4ebJ0MNoPjqNasQdsutbjyFbM+louRQUnwNuREwmEQ4MQZbWgBL2Hul1J
	 EBEO408W9/Yt7C3DvsmWQBhhu5zs8RpFu0CYBUas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/54] net: dsa: b53: fix flushing old pvid VLAN on pvid change
Date: Mon, 12 May 2025 19:29:23 +0200
Message-ID: <20250512172016.105259452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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
index 83296ca02098c..29bf2fb5e532f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1536,7 +1536,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (!dsa_is_cpu_port(ds, port) && new_pvid != old_pvid) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    new_pvid);
-		b53_fast_age_vlan(dev, vlan->vid);
+		b53_fast_age_vlan(dev, old_pvid);
 	}
 
 	return 0;
-- 
2.39.5



