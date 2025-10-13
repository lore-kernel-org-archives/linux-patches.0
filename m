Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457CA308F2D;
	Mon, 13 Oct 2025 15:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369402; cv=none; b=bF3LhY5guuoF9acx8XUUjQyeQdkm3KPYR2wG2rrJ4lkH3kffE8qODhW8ruDNOvBIyoMZZi9MKgvH8hLZV83Ux3Pvfuoq27CvHRkERC/Ei+iBUhSS+sID5jW0+3mNgDdj15EQq34KvOE6pibA9m/du5+yD8t7gnakkVqSXpqMa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369402; c=relaxed/simple;
	bh=sGiMmpNB7Pt6qGbrCNkhxazGk+LvdI/zShEk8jk57Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZxFhkNaugvvvOYG3mefWAWFSXLs4mCgVoOfpaIhvqRzwTMfDTkr90Jd02QKLyEGJPkvQ1IbtSrGyCfoAzLXc+SmGpS1pXiV5AKDp7fTVjnej8nyTkcGJcJy7nNamzFzutEN4RXyH5OExKEQSW36T2cxNGWo9gp2lYT1cMmyXaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJIvoGrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJIvoGrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C533EC4CEE7;
	Mon, 13 Oct 2025 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369402;
	bh=sGiMmpNB7Pt6qGbrCNkhxazGk+LvdI/zShEk8jk57Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJIvoGrd4DPdEHxpZ+qp7mKdg7k0BWS9/WBxiGnBONTt8Fy1QrFEOypMdPWPMMXKb
	 Q4pNuVEW/4mN6qVKmK7Y2CxHW0SEAMYT7epU/z7YSBKfLy7XaHYkRYqNSAkIUlGmh9
	 yo1H//e9+uW3t1L4y24K8VJxTXKZaDRiCCEqqunk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 200/563] i2c: spacemit: ensure bus release check runs when wait_bus_idle() fails
Date: Mon, 13 Oct 2025 16:41:01 +0200
Message-ID: <20251013144418.532853592@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 41d6f90ef5dc2841bdd09817c63a3d6188473b9b ]

spacemit_i2c_wait_bus_idle() only returns 0 on success or a negative
error code on failure.

Since 'ret' can never be positive, the final 'else' branch was
unreachable, and spacemit_i2c_check_bus_release() was never called.

This commit guarantees we attempt to release the bus whenever waiting for
an idle bus fails.

Fixes: 5ea558473fa31 ("i2c: spacemit: add support for SpacemiT K1 SoC")
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-k1.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-k1.c b/drivers/i2c/busses/i2c-k1.c
index b68a21fff0b56..ee08811f4087c 100644
--- a/drivers/i2c/busses/i2c-k1.c
+++ b/drivers/i2c/busses/i2c-k1.c
@@ -476,12 +476,13 @@ static int spacemit_i2c_xfer(struct i2c_adapter *adapt, struct i2c_msg *msgs, in
 	spacemit_i2c_enable(i2c);
 
 	ret = spacemit_i2c_wait_bus_idle(i2c);
-	if (!ret)
+	if (!ret) {
 		ret = spacemit_i2c_xfer_msg(i2c);
-	else if (ret < 0)
-		dev_dbg(i2c->dev, "i2c transfer error: %d\n", ret);
-	else
+		if (ret < 0)
+			dev_dbg(i2c->dev, "i2c transfer error: %d\n", ret);
+	} else {
 		spacemit_i2c_check_bus_release(i2c);
+	}
 
 	spacemit_i2c_disable(i2c);
 
-- 
2.51.0



