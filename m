Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765FB1A08CA;
	Mon, 12 May 2025 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072368; cv=none; b=TDMQlIJrCVP4gqUy2cUiSNzM7NfHIh3TS4NrvYUxhtsD2EqHVMO85XLADAOF12xxeBbu48dHn6Qf5Z9qykC57iL04Eew7dFjAj6/2kZj2v76Rv6/CKtzrnlrwENdummU28bYmk560eZQAim/9CC6A7Td2bvGBhwhL8IOMsosu/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072368; c=relaxed/simple;
	bh=WVFH6FDjzIbckkHkX5kvFjITxB8RMPQyH3CWVhlus0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwDcsEcu1UrOg23yG0AadBZ2j1U22oh97nN9BxfdwExCdkgiljUIg8FuWtnupkclzwA4lkAEIfQDGBm36PkOOCkfNlDE474u6oMT6j+zB3nCKfLtPemiH2GK5jtPjR7S7xYe16mm+1eJ1i0+K/ShH15YzEmbBlGeWurF+DvDejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVfEi6mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVfEi6mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9528C4CEE7;
	Mon, 12 May 2025 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072368;
	bh=WVFH6FDjzIbckkHkX5kvFjITxB8RMPQyH3CWVhlus0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVfEi6mgmlgfeuVuKoyu0wceO6vpwSli2HEdO2rKt2RMZCSA35FFNIOEHq62x1BSN
	 S0jCLK0YuNVbj0cf4m7Nbw1PsjPcXP/ecSYv15NzOzrkPmh9binIFfkGrMGYP1eNn1
	 UAo4fLMAl2OlTPGYErdVaW4vXq2l2DwJdw6HT/bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/92] net: dsa: b53: fix flushing old pvid VLAN on pvid change
Date: Mon, 12 May 2025 19:44:54 +0200
Message-ID: <20250512172023.902715507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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
index 9e33e713b9c83..cff0e1ecaca51 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1511,7 +1511,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (!dsa_is_cpu_port(ds, port) && new_pvid != old_pvid) {
 		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
 			    new_pvid);
-		b53_fast_age_vlan(dev, vlan->vid);
+		b53_fast_age_vlan(dev, old_pvid);
 	}
 
 	return 0;
-- 
2.39.5



