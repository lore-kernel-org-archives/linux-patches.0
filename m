Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059378;
	b=sUmTAe73Tl0BfS3LKdwa5W0BfIcOTPsXHLyzp2lXfpRXrKW1a821cwxjuwguKc63ZXDW
	 tAELl7xo8DHmqs7AqWFnE5vwnar0anXmuTG6zVJLK1Gxb9ygfUbuKfoZallN6P1gHZt/M
	 CkUG5Npf7EhwfuhQggLYIlQ6RZeHGDxXM3QUzJphMWzCEWZjIwubJagonb4Sn/hGZLsbT
	 90HYGPbA+8BCAnWKN9NxbwbAldM+NQoakfU76LiwIi1F96WD0+/SQ4E6VBFAbzpEH9uCz
	 9dqjY51i9P68be5rWxi5M6jMmPvgb8APTQH1eno4T/vwqHihNGtZASl13sEwK39TECQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srTLDJ06MQnDQjCMMhdD9fdm2ogWNC84IZtLgqrpuRE=;
	b=MFtaqw8YnAicXvw9XvHJZMJBKM4tHQP/zH+q12KUaiT8l1TlhxxkL7o8EqEDaeZD0fNS
	 rdE4aGb3mBa+QLSfxYX2ZibIgwoak3299BZ+cBL9U34yroOst5iUXCOsMkFOXt89oMH1u
	 eUGaZRDV4nmkjnf2GtCgWBOIaI0tXPsyaFY6fTachx/Q2sGl7mEbv5xEssy0oR6zXO/SO
	 I4zfQuH+Wsp5Pnp7eBNNPuZqVCRve0nesUr2N9B88EYOwmyMxZScDigj2OiLodgZMsT/9
	 4KHFX84NweL9sEPfWapGKWVMYBpa6a4U/8AdSF1R8SyzQV/C8RE9Xq5B9BwTth41cqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLhfOqzh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EB0606A320;
	Thu, 19 Nov 2026 03:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLhfOqzh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59B61F000C4;
	Thu, 19 Nov 2026 03:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059378;
	bh=srTLDJ06MQnDQjCMMhdD9fdm2ogWNC84IZtLgqrpuRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLhfOqzhlzisj3cGpSG9ir6WyyrRXyu3Gp+CBp/L5ONpYc7QHc9YdqrRIaBEo7VCl
	 BGXFT7pu5scHSg4Zp0rgyReGQDptz/tRyJ5vwQgKAv/Ccwc18gFvVY8lA+WGW+byEi
	 djFmNrC39UnW8vOYi0NSIGmWt1A1q55YYDOvRrnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0820/1848] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Wed, 18 Nov 2026 15:47:38 +0100
Message-ID: <20261118145950.879688821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the existing sget_fc() call instead of sget_dev() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdsuper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index c3e2098372f2e..1bc23028f400f 100644
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



