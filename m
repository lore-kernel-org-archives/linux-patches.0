Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066CB4176D;
	Tue, 30 Apr 2024 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474290; cv=none; b=u01MJUd94bS6YH87+pzkxQZKf6EAJfF16R9+lCXoPOkJ1UFhSwBQYCEmin7bH7zecfbvg2MZwUjC/whL++zR8fEJ6UbVoM37Zdql9P3/Zv6Vab3oyBU/ZQmeXuDsrhfN/8FFD8S6vye9Z3gZb3gTwTUQI4lfozOnrREXMihnk0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474290; c=relaxed/simple;
	bh=MY714E2bsYK74FI2L8Ha3Us72kOh4isBkmIq1RZ8LeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k7P5Zvp4nzbP88+jeW34R+lfgZQtX45H1eMCInLZWXzxjEXMobsj869HT5N6FjJqqQ/+HxQdUzo3VZGMdCv2oAUT7RroKv42lrSIP5uIgAUXIRw8bco1DFaHPimkXsb+yL9SMVXmWaUcdizgvQo4rKJxdotRRTO/3A82+Z36Urg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRXsXagD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRXsXagD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D768C2BBFC;
	Tue, 30 Apr 2024 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474289;
	bh=MY714E2bsYK74FI2L8Ha3Us72kOh4isBkmIq1RZ8LeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRXsXagD0KEfLxMMEf6f3b+djGKqWzrz97UXZpF3felipfzW3vvi5BlVVEmfqdsm+
	 AOPLuScVWgmcuobS2dZNJ9nhycIX+quQJKN4ca8PGxrKf1o9JIdqiJ8lkYLAeWIV+N
	 7zJk0AUFtuNx6Q/ZP3zqMuUPtzQzaUqkHB0vh3Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 114/228] octeontx2-af: fix the double free in rvu_npc_freemem()
Date: Tue, 30 Apr 2024 12:38:12 +0200
Message-ID: <20240430103107.099501561@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 6e965eba43e9724f3e603d7b7cc83e53b23d155e ]

Clang static checker(scan-build) warning：
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:line 2184, column 2
Attempt to free released memory.

npc_mcam_rsrcs_deinit() has released 'mcam->counters.bmap'. Deleted this
redundant kfree() to fix this double free problem.

Fixes: dd7842878633 ("octeontx2-af: Add new devlink param to configure maximum usable NIX block LFs")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://lore.kernel.org/r/20240424022724.144587-1-suhui@nfschina.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 42b5ed02bc87f..d94b7b88e14ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2181,7 +2181,6 @@ void rvu_npc_freemem(struct rvu *rvu)
 
 	kfree(pkind->rsrc.bmap);
 	npc_mcam_rsrcs_deinit(rvu);
-	kfree(mcam->counters.bmap);
 	if (rvu->kpu_prfl_addr)
 		iounmap(rvu->kpu_prfl_addr);
 	else
-- 
2.43.0



