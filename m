Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939431E5B71;
	Mon, 23 Jun 2025 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714157; cv=none; b=VaM7a97Yc/zdU87PXqCENlsXomPocpP0/qJfZqPA1yjqPo3wVpgDKRkpnfplvvamgcOLkQkAl75uSJrw9zk/mkHEHAWobCRI/CGXt9I/YTtm19zrSKGOv/5WZWN/aCToXbK9FRCGZO14VeOHXuJruPxwWE7Phih9zDUvehdPoL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714157; c=relaxed/simple;
	bh=ngtdygAut+1bEYMuRKdp/8uPJS9xkWC5vFiaw5hmHNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPnPF0BvvKHmReP+LCpb0HQDe0/4aID+Y8dgytdXumKODoSn/HGAhlJ/qHD/DNTK8a4PuVORoEVb1UKZU2a838HDr6QgA2k4Qr5BOeeFC9eAPJ/ED0UfPRB+nloT0M7JukCJOpoUl3wDkZV9rQfnMPSARQOr5bpOXyvLJ+uaP8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBXtwjE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBXtwjE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2897FC4CEEA;
	Mon, 23 Jun 2025 21:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714157;
	bh=ngtdygAut+1bEYMuRKdp/8uPJS9xkWC5vFiaw5hmHNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBXtwjE20Jw1cziRkZuAxSeBO0n+imbs4GhoO3uPLz72JNaNJKFXhWKPPkqs5i6yK
	 hLJGsFKjX7KPzJVcb9rBkZMlb/FXnZh+yuLrscu3N7i6qBw59Uyqqg1GVzIsvTkLZp
	 4uOLYvicqarh7lbUk2dAxTnV+iu8aELQq8Rkgh9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/290] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Mon, 23 Jun 2025 15:06:41 +0200
Message-ID: <20250623130631.112208291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit edb888d29748cee674006a52e544925dacc7728e ]

Logic here always sets hdr->version to 2 if it is not a BE3 or Lancer chip,
even if it is BE2. Use 'else if' to prevent multiple assignments, setting
version 0 for BE2, version 1 for BE3 and Lancer, and version 2 for others.
Fixes potential incorrect version setting when BE2_chip and
BE3_chip/lancer_chip checks could both be true.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250519141731.691136-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 51b8377edd1d0..a89aa4ac0a064 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1609,7 +1609,7 @@ int be_cmd_get_stats(struct be_adapter *adapter, struct be_dma_mem *nonemb_cmd)
 	/* version 1 of the cmd is not supported only by BE2 */
 	if (BE2_chip(adapter))
 		hdr->version = 0;
-	if (BE3_chip(adapter) || lancer_chip(adapter))
+	else if (BE3_chip(adapter) || lancer_chip(adapter))
 		hdr->version = 1;
 	else
 		hdr->version = 2;
-- 
2.39.5



