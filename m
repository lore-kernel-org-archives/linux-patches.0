Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062994;
	b=A9BO00nx5qPi2EOAeMJQqKmBzWnRnauRxHK1BrM+ATLGEEHg73rHyKBTwli8M56IWO8B
	 7mnyylkf6q0B+O1pb2C9NCmBGXOTAwRFzv5FGsG9D3twkZNtHX3VsgK+fOOiWnDydYQG5
	 izl/by0sHvmV0KQTqgSekIcATRd8DxxGKh4f5xMHvk7WCUDdcvR7eyNTh8aoIOmrW7R3N
	 85b2WVmm/Hb+3mEXyVgCr9DuzBznJsuPEEUbemDXYqz9Wee2FeQLZFzf7WNEdX+FfpF+O
	 KfxKBeOb/pKfPyd0Ap2dwgq7HAPNCJOQBqkGKb0Y/AQqRsMHUDmwZjW8G31ZWp4dQDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltdTr0v0X2YZOFdPY6bqsqCBc05ouVBmdkNqPGu43fw=;
	b=XgNb1TVxAIbrU+3r8Q3YlD7ReQJuP9c4waahZkbJW4scm10CfqMKK8dAzyZK3Iu/A4pw
	 R6ak9OGdJGpkJEaQIlaV98Zhi42FPnL6OdGDYcMaO09u5gmkzmZ8VbamviTIN9hFGAsBE
	 x0Iuf/vN//yycPUePRnmJuAH5xT8I6vn/TE27OfwZBrKaQwgyfljj7ROpaPSuSqv9bQgF
	 58LyFFXGQn633AGj8Qr0v5hjfIcvLhJbsSKYgurK+qRURjl8Kj7KNSaCM0TKhNYKh83wC
	 P3VXXTjy9HJtx2GLfkWDLS1TMu3iNFYE+MXAQk2Fns1D9heIoqw4PMLCbuAgr3P0qPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLPmtleW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB484606A330;
	Sat,  7 Nov 2026 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLPmtleW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D351F0089F;
	Sat,  7 Nov 2026 14:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062993;
	bh=ltdTr0v0X2YZOFdPY6bqsqCBc05ouVBmdkNqPGu43fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLPmtleW7ZO/q/Nm5wjrPXy85KgDxrWERZcnF+edp8FExDn+48Hzlu4YqjZZti31T
	 QbUxojCWw0uQEdcCcfDDMwJbJeykeVlLcea+i0iwUmfUY3NDUgXCF5H2mSMdSlqKOo
	 kRV9ItrzB2oNxeVH/ABn+tTpScU6pgvrVraW0/oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/869] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Sat,  7 Nov 2026 08:48:52 -0500
Message-ID: <20261107134900.243204936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



