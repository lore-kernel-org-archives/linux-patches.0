Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053629;
	b=U5aH5yf0OykTYpyjBeBw5sjAoKe924K2smWW2EVHBVNeW3ooeaGDE3GHhdNRWLzs7P7M
	 GWAcT0uBtkrZfM0fEqATd3PlAjaIr7VxIf9hQR1cVdyaQhkYgRIsd3qp6uHIjmZktqeIY
	 6rmQqayTg2x3SazC2mJh+Qik8ZiNilllD1AaWrO7XJjcPS4jTH3LH1FXiVYB809gzX03W
	 YV/5eUo8UJ2ojBCT3pNfNtkqIzMRqgnvvydDWIFqytFMU7DNFvelyGQ1+1h38CIGRw9yA
	 zhK0zyH/G5QxmiovIrGVqfHF8vzyuGPbpZT2ieliwi6P4FPmmeeoovnU5FbmH1QRopA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ANZUY7gnGnxNaQCZ1PlCrTyEFGW9nWR12PY1rFZ4PY=;
	b=mRq8b7tHdpqXCXRT35BtayP/2chq8KO/tLnstz9CnxOdDdDt82p45p6P38kq8rgn0Db5
	 hG85ykeyenzMbkwLctoNiW1Fb4xMpEOKdvDj2mSoA51nB+ZOnbuCBjF7/S0A5PwLBfTnJ
	 kJaXcrP4IO8Jt26HDWBfbo7BZIokqOGORIqXuFwl/Gz+EJ5tP5g7p8ikrJOsMTG3s0xOq
	 7H+Wa4ia7wYublGe6Y4Mx9pV8mFnFNkHs/A5CmdfQ7eqEtDab6BbgdGa5ywV7ZZCYPkC2
	 s4+3aBex9eJLBxdfSweIDG3tNg4ouX58sOyMnFXfk9NSW33UmZeodscaSiJ2RKDkReg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYGs6VFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DED7606A32C;
	Thu, 19 Nov 2026 02:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYGs6VFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E515A1F000C4;
	Thu, 19 Nov 2026 02:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053629;
	bh=4ANZUY7gnGnxNaQCZ1PlCrTyEFGW9nWR12PY1rFZ4PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYGs6VFTZ5K2SAFOfNCQs37ZvrAge79oSmFVDwFnJwMYSgJFjtRZliqbDY6U/LNVm
	 4n/DMyBvEv25jyjbwXJtsXtRbA5L1B178wbIH0aJhWUGuso0auVXWjIVDGMogHGhe1
	 8deFzx4pO0oJLXz4rd5aaxVtgd/+f7dtSRVPMe0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0988/2214] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Wed, 18 Nov 2026 15:44:24 +0100
Message-ID: <20261118150051.751848657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 62ee3da38f41bef83c1cf250f6816a0ee187674b ]

mtd_get_sb() is called with a reference to the MTD device already
taken by the caller.  When sget_dev() fails, the function returns the
error without dropping that reference, so the device is never released
and its refcount never reaches zero.  Every mount attempt on an MTD
device whose superblock cannot be set up leaks a reference.

Restore the put_mtd_device() that the fs_context conversion dropped on
this path.

Fixes: 0f071004109d ("mtd: Provide fs_context-aware mount_mtd() replacement")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: adjusted context around the existing sget_fc() call instead of sget_dev() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdsuper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 38b6aa849c638..24d6e3540f345 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -63,8 +63,10 @@ static int mtd_get_sb(struct fs_context *fc,
 
 	fc->sget_key = mtd;
 	sb = sget_fc(fc, mtd_test_super, mtd_set_super);
-	if (IS_ERR(sb))
+	if (IS_ERR(sb)) {
+		put_mtd_device(mtd);
 		return PTR_ERR(sb);
+	}
 
 	if (sb->s_root) {
 		/* new mountpoint for an already mounted superblock */
-- 
2.53.0



