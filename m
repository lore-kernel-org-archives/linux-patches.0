Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC021A7065;
	Thu, 15 Aug 2024 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728778; cv=none; b=nfVpWEpkDDdAgDMUClUBp9gGW81nJ72QSW5s0gj1K4rLhLISldQOKeI7Te+2UrGDPF3tjmhYVo5CCU0LcwZCe9pCyFqhw1d4pgpnffu/XDQUEEbFg33FnupCuwvVirVTiCJzq8dQP940u5au6BVH8NugccaHqnZmSDn67twGHu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728778; c=relaxed/simple;
	bh=baVIuH+eR6LS8WEEaQ2yxNMjOXgcRX4vowY5hEzPpww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og25mp6NNQDYdluq+rqROvSySiQWex9osQPDQZtfW7xEl3ztZbWtDHoBlMaV+wbuGcHasdAkmYSNFMmv1COoizj7LXIjWQ//XpJIOM9sZCzn8AviJGG78sv36E0C0zVg75YZ0ImHfrM1BfwcMMpM0xXjmpLYBbVIPW+pPky6hDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOQ3Fphv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOQ3Fphv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236DEC32786;
	Thu, 15 Aug 2024 13:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728777;
	bh=baVIuH+eR6LS8WEEaQ2yxNMjOXgcRX4vowY5hEzPpww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOQ3Fphvd6+QkEN648BadSyftws6BWXCYyagNra9EStekbpR9AEYMEkxJfovCHMl3
	 iSoULNSJZQxJmoCXDfR0vFuRdgScXIWdPoqk/P4T3QIglKXWT43XgzltO/tuo+Ub3C
	 E0nQsnwgYX7MbELhotHy8MvIPJbsJYQwinUu1bSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/196] mISDN: Fix a use after free in hfcmulti_tx()
Date: Thu, 15 Aug 2024 15:23:42 +0200
Message-ID: <20240815131856.099245264@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 61ab751451f5ebd0b98e02276a44e23a10110402 ]

Don't dereference *sp after calling dev_kfree_skb(*sp).

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8be65f5a-c2dd-4ba0-8a10-bfe5980b8cfb@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 60b3a4aabe6b8..9010d5ca3cd53 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -1945,7 +1945,7 @@ hfcmulti_dtmf(struct hfc_multi *hc)
 static void
 hfcmulti_tx(struct hfc_multi *hc, int ch)
 {
-	int i, ii, temp, len = 0;
+	int i, ii, temp, tmp_len, len = 0;
 	int Zspace, z1, z2; /* must be int for calculation */
 	int Fspace, f1, f2;
 	u_char *d;
@@ -2166,14 +2166,15 @@ hfcmulti_tx(struct hfc_multi *hc, int ch)
 		HFC_wait_nodebug(hc);
 	}
 
+	tmp_len = (*sp)->len;
 	dev_kfree_skb(*sp);
 	/* check for next frame */
 	if (bch && get_next_bframe(bch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 	if (dch && get_next_dframe(dch)) {
-		len = (*sp)->len;
+		len = tmp_len;
 		goto next_frame;
 	}
 
-- 
2.43.0



