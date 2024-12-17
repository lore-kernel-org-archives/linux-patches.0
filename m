Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53D21F8918;
	Tue, 17 Dec 2024 17:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456665; cv=none; b=VqJBg9cV61oEw2qN7ZJ/f9u/0iOG3y4Iyby3nJQBCg27lE3wrGnUDv5C7Sqyf1BQCxcDQmXwui0OmSi4z63utT1yzTmNsKhvz0byAJZQ+irlPtucVFLmYa11S1OG1OwE4ee6utxsyuPJl7z+yeUuqoRVgclzzp86Q+Ufwa0OiI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456665; c=relaxed/simple;
	bh=k/p+CpvEVGAhkK+7svTft8qyLetDV+Gvs3MvskbCjrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvUelSI3WfzljqbR9OaQ7jF/+fN4cylIurlndZ9bMmNry2hFCZ5Qn22WIcNtxoWHO7371Nq/e4+xt56Ghw+UAenqVEKnveu7KTI3EISJLiln7FaTViOSrjUVyflKn2zjBUL9P9/2EsnmyNRVKYt/YlCcAoNALBn6z0sf/XC5azU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7J/SN5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7J/SN5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DED3C4CED3;
	Tue, 17 Dec 2024 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456665;
	bh=k/p+CpvEVGAhkK+7svTft8qyLetDV+Gvs3MvskbCjrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7J/SN5h+jvsvA1T9uNngzHPRv90onZRPocsDgeBrzknEXJEqVd7LB9CK9ZevTPSr
	 SXyZwe8j+KBBGQQ6Kv9M+29qnscKk6hu99uiv/vH/5BwEKgZK/bAH6U4Ek3+CsWnsG
	 ijkHOdaQswg3huIc/U54d0XIfLHBKDjGJ0Gs0D9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/172] net: sparx5: fix the maximum frame length register
Date: Tue, 17 Dec 2024 18:07:47 +0100
Message-ID: <20241217170550.929185013@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit ddd7ba006078a2bef5971b2dc5f8383d47f96207 ]

On port initialization, we configure the maximum frame length accepted
by the receive module associated with the port. This value is currently
written to the MAX_LEN field of the DEV10G_MAC_ENA_CFG register, when in
fact, it should be written to the DEV10G_MAC_MAXLEN_CFG register. Fix
this.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 062e486c002c..672508efce5c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -1119,7 +1119,7 @@ int sparx5_port_init(struct sparx5 *sparx5,
 	spx5_inst_rmw(DEV10G_MAC_MAXLEN_CFG_MAX_LEN_SET(ETH_MAXLEN),
 		      DEV10G_MAC_MAXLEN_CFG_MAX_LEN,
 		      devinst,
-		      DEV10G_MAC_ENA_CFG(0));
+		      DEV10G_MAC_MAXLEN_CFG(0));
 
 	/* Handle Signal Detect in 10G PCS */
 	spx5_inst_wr(PCS10G_BR_PCS_SD_CFG_SD_POL_SET(sd_pol) |
-- 
2.39.5



