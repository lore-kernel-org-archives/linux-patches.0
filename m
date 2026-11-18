Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046687;
	b=TCYK7uyxgimP75crPhBb+K5GRYCrNDPoqwlED3oVMQTPKCHpxomvR1iUFX/RLxoe7/ng
	 XNaOK9rw9sDpiDtbz3vOU1UDjEbfNtGO/lvmK++XctiUClww7XWCptZKXYMjErh5AAj04
	 EYJQl0ONH0JbE0eu/zKAYfcaWhYINmE1gWlncnOapCGDE5fc4ltgef/V7DgFmwnZ2Q7eN
	 SafUiEctwm7xKyTeuMWkpPAqKq0b8FdnMLiHwE70E9p1Q33BSkBkWJfZJl1dGERVgA7ni
	 lUNDdjLfvhLFqDoDyiW3P2NNEoWdHi80AAsjYd/uvDkxN15NKi7N+uL/6LNVPunFb9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmuBukoz09Prbla7Lv6O/ls0GMC9rRVgynSQ+hknkmk=;
	b=WU5MfxDzwxOB5jG/UA7XMgW5p5fRmDkTDylMtA5X3/2Nww6Lv1QJ4bxn99RZfg76aFLk
	 2t7o0EvM8KnDL4uLjSVfMoFAEw24N3IeH+luW8ISmGSAQsiBYCs098QwYoXjVTyJtLxPv
	 yOkOdXX2Ckl1brYeXTueYU59asToXQYjwRPscxAqur+xVyZmB9gesYECOnCSjRysraKSf
	 N5w+QwvCoV2UYBjzXiqLAtwZ/rI9/i7+LeOP/RbakapKROvvjxF+h6btvzKkO53AEPFdH
	 YKFzUadoTWW7YshAhyJ3d6nQQ/JgVsJEj9A+qbVLtPz+M9UUD5fHOzBqeDpbqk+4DkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLtnZD98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3058B606A31C;
	Thu, 19 Nov 2026 00:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLtnZD98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EEE1F000C4;
	Thu, 19 Nov 2026 00:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046687;
	bh=gmuBukoz09Prbla7Lv6O/ls0GMC9rRVgynSQ+hknkmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLtnZD98eCXt9hp2XHULdBR4Slfq0ayz6EobNk9fpVs9BwTvTN6vjyMTtk5j5LGFX
	 WD/GomAD2vx6P/b8iEuBQi1iySwCUymUsdloVrqXB8x/tDwuXiKUydxlcp/dByYXAv
	 6kABotCL8zZyt/sFbEnufkh1VQpg9iBjeio5hjlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1369/2857] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Wed, 18 Nov 2026 15:40:03 +0100
Message-ID: <20261118150250.684643297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to retain sget_fc() with MTD callbacks instead of sget_dev(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdsuper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index 5ff001140ef4a..2b1fc3fc5fb25 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -64,8 +64,10 @@ static int mtd_get_sb(struct fs_context *fc,
 
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



