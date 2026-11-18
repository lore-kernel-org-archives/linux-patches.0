Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036112;
	b=YbJCS7eI8GexNRPh8G+i91XDacrev/U8cDu4Xavl1EOnnxDPYSw67WAgoZzmh8d0bHwM
	 aeRnkgVyKc7rsYUMWBV+0NLy2mIpgAEW6+JNl/le1GbUp6csf5ZNufrWuMwttaxvzzpV8
	 0xhl2eGbfmh3k1hW9d+22fUJMWZ4Tg2zvWO9qAQ6cXl1bt+ToptbMDCxM9++jZ4Wz5Sai
	 /NoQgEufUY0BEqEpyScJkrKuAOO7VaFuZlbL/WJdpsgl4ZaRDkQgA9v9vQw3Geaer1A/C
	 7HruJdpHM8YY1hh5ttqLPXZgqfXouPPX4x2MK5+Ov9aOP0qt/bzNnbb2JrRSNI3OiIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sB7igqXnflmlUD1XSCfLkaHsVc03eRJmQla0abx7Ts4=;
	b=neo8PM8ZmzHHBNddm4/aYWwMCsjDvTUm0sCJO6sJu2sr+CsGGSxXy7+XfAjYMsmGJQtS
	 QR8LV4qVfEuNtRI80mGGXk1ZhbG51MRrU3Tm4kUx0Oi4tboRpIiTNc+7AwNjyZUjT5ORb
	 WfMepdsOcoeowWDbDTLM7TYCmjG0szEvxMg2whqVQqQk5V58ZWAo4zh1lp81Xvdji9pIR
	 C/kvy4CgKabQXQN0DNEdrn3Cem8EWTLCgJMo6eLAF4opLKKtC676wImNHP4yfDGzxGeL4
	 MNoZaKHe+stN2CHC52ZJmNO7o9OH5SmE95DomCbDx7QwVdwHRmOMjmTppRlATbFWowQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSl4x87K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF385606A330;
	Wed, 18 Nov 2026 21:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSl4x87K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD8A1F000CB;
	Wed, 18 Nov 2026 21:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036111;
	bh=sB7igqXnflmlUD1XSCfLkaHsVc03eRJmQla0abx7Ts4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSl4x87Ks3szbT33gPGYsvlJWefBpkMFosqoTohDl44BFJeqllVlkz8XgpBZhNF0b
	 TiXPmmOXe/NNGTv3rVUcnaC+iz7OHSPXkQiB9m7iBqAeFwI16+jB/afZ6E1L5FBc8F
	 VrWYt/+JS/YQIbYhpq68Da62ODkumYApSd5pxpck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0943/3318] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Wed, 18 Nov 2026 15:26:05 +0100
Message-ID: <20261118150347.876456173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdsuper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index b7e3763c47f0c..22ddeaa7d5221 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -31,8 +31,10 @@ static int mtd_get_sb(struct fs_context *fc,
 	int ret;
 
 	sb = sget_dev(fc, MKDEV(MTD_BLOCK_MAJOR, mtd->index));
-	if (IS_ERR(sb))
+	if (IS_ERR(sb)) {
+		put_mtd_device(mtd);
 		return PTR_ERR(sb);
+	}
 
 	if (sb->s_root) {
 		/* new mountpoint for an already mounted superblock */
-- 
2.53.0



