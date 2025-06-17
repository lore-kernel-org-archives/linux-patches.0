Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A692ED87D;
	Tue, 17 Jun 2025 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177299; cv=none; b=Nm+stk2O1A0vn48FKegUETXjHK0zvUB7m98B465juWp51ZCH2d6zw7/Zowl2Jp0wnerYySclGE/1P0Y2nMo3n8LpJS0Q3DG+qyS/UFo50YsE3Nw5/od5wLpt83BXdCQ+kAvBFFCWw9fc4Ls8rhpeBDYf8Jy+36KlZxkdtX52t/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177299; c=relaxed/simple;
	bh=0pvm4aBAqMPR/FNGB1OQumJS721jYeGJQLRBAkdnAb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO5ZMt3ghGs6G5fNP1JRV11TUhrM/ra4EgRzIaTEq+v7P+L9Q07KWwPCI7uvLjp/zxJWqXysrd3F+1CWYo36oFByvHRlTz9CuePI0KBrAhapfksiv9Bj/P41aTJnFhv7Nkl8ueeInG1LFlNJw0Bj+BM6mfwJlKqz1YJn/DLaggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo7541Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo7541Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3F2C4CEE3;
	Tue, 17 Jun 2025 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177299;
	bh=0pvm4aBAqMPR/FNGB1OQumJS721jYeGJQLRBAkdnAb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo7541TbXPkDUYfoE9+ajLMJAknrnl6AHAhylNlT27cv5TmKwkHsyhrVw9ZOJcm4a
	 bNj/NfgoOmRuOj98MrrbA2HbHKMq68CaoS130XLbdBLCKlczRpH77+PrqFilSS8B/p
	 13MFerAoPkOTaFKEK8k68rRf4amOjEV07gbHjLjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 286/780] RDMA/bnxt_re: Fix return code of bnxt_re_configure_cc
Date: Tue, 17 Jun 2025 17:19:54 +0200
Message-ID: <20250617152503.118921922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 990b5c07f677a0b633b41130a70771337c18343e ]

Driver currently supports modifying GEN0_EXT0 CC parameters
through debugfs hook.

Fixed to return -EOPNOTSUPP instead of -EINVAL in bnxt_re_configure_cc()
when the user tries to modify any other CC parameters.

Fixes: 656dff55da19 ("RDMA/bnxt_re: Congestion control settings using debugfs hook")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250520035910.1061918-4-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/debugfs.c b/drivers/infiniband/hw/bnxt_re/debugfs.c
index 9f6392155d915..e632f1661b929 100644
--- a/drivers/infiniband/hw/bnxt_re/debugfs.c
+++ b/drivers/infiniband/hw/bnxt_re/debugfs.c
@@ -272,7 +272,7 @@ static int bnxt_re_configure_cc(struct bnxt_re_dev *rdev, u32 gen_ext, u32 offse
 	int rc;
 
 	if (gen_ext != CC_CONFIG_GEN0_EXT0)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	rc = bnxt_re_fill_gen0_ext0(&ccparam, offset, val);
 	if (rc)
-- 
2.39.5



