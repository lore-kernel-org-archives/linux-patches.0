Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F202F2EC09B;
	Sat, 12 Sep 2026 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218661; cv=none; b=dEbx2fBWopXHHyi0rxsuVQ8oTlPJ8dLHVlyKOxs4euPA7CNMUZyzSJzmC4dMaM5T+JYw+tWhS+ftSwsOGQG2fVdf6j5u0VxHm4Jd6vw9HLgydYIkCiOq54tHUxUJcMNv1vioFmybP1PpeBefecJ+JxDAzmFEH7FtzVJiEnfaY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218661; c=relaxed/simple;
	bh=hsvRIphU/chpU+zvU2sbRZPOg+YtUhjQy2RgYDObCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUdoDH2nflmFcos4K0F8fJDFDqgoZwdL5s9i6dYaL2+ZxmroX35FtHotWNazfmbZUH3TH/VlcCofunNMVtiZFNDHCMvrrxo3R3pmvnI5GXsrgfqV8G5khPwUE/1SbzSKtpUahNwUKbV8u1yE8bGOZDUhgArTmpVQh9f6AC0ERMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp1HSrxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp1HSrxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021911F000FF;
	Sat, 12 Sep 2026 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218659;
	bh=QFf96Hzdc0lsfbTMuCtqiVtG4SjZ9sUKwBomKgvzpKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kp1HSrxSfeg6gMfmiotChc/I6qifKDuVXVAre1Gp44e6MqDB6dVJaGLX8o+PWxSNY
	 KeNUI5Q80aSoMHFPdQHJB0vAjhzURyHCARMb2AFgLKpVVoJaixonUc5YYhCSmzqFY+
	 Cq4jZEwsVI9KvlaQ8NXtNLk09eW9lJPDPdXuK1xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1189/1376] octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()
Date: Sat, 12 Sep 2026 09:00:15 +0200
Message-ID: <20260912065634.052023480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4b92a3710d4a1d850ed6421c773e735cdca69b07 ]

rvu_mcs_set_lmac_bmap() declares lmac_bmap without initializing it and
only sets bits for valid lmacs with set_bit(), which ORs into the word
without clearing it first. Bits for invalid or skipped ports keep
whatever was on the stack, and the garbage is stored into
mcs->hw->lmac_bmap.

Initialize lmac_bmap to 0 so only valid lmacs are marked.

Found with Clang's -Wconditional-uninitialized.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260812060730.6181-1-kmehltretter@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index d39d86e694ccf..006d3258fd4e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -854,7 +854,7 @@ int rvu_mbox_handler_mcs_ctrl_pkt_rule_write(struct rvu *rvu,
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
-	unsigned long lmac_bmap;
+	unsigned long lmac_bmap = 0;
 	int cgx, lmac, port;
 
 	for (port = 0; port < mcs->hw->lmac_cnt; port++) {
-- 
2.53.0



