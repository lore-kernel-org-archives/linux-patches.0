Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064161;
	b=ylkDJB6tnmtiz2pURjTWFG5Z7Tb7qYPGYuYuzCQFKGTiVQgJyOMutpqPOeeT4pOwHLsi
	 vim2lG4mDzb70IkmejL3LcvDj7yRWOcFjqKNzlrHGoWLAfu7bIlXe5rzHn1ZBL3Gs9qjo
	 Qws/M2wmPoco6RCNFPxuABjKacde4Z2vJmGB5yG+Y6kB6GV7M3eNY45GA8bgPSf/eXR8R
	 bfj8Nb1ftUMXMorS98moqt3oz0/RsyFJGUCCLoXygJL0u46v3OwMlWghijT++Ijf945BU
	 K02sJccfRosZc61LGetscp3e9KQ9FlN5W/h3mEMA4WYZBhDfFNLJ3Y7SVJAk0ObNhwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Leqibie+18fsQ869hph5EBnjN3NeXzRJ2up1y6iRXrQ=;
	b=poLOgA9Q+mufLVOcRIBpUhGg9yXGAMAcO+5vlOWs+/rcOgAaxrZ0U01JGrfmINgjywre
	 ux+7QetyPhnAzYBSBHzh8EjNF5jGEs6g1jEG/QOo82rfJAxarVSompfKgz95HTHl99IBZ
	 49QEk2WxmYEtDykN3kLHTwVIUjmVqO1YW8pojrA1HkWmsP0Buw5c5Dz7pL3qJm8ZxkIpR
	 F9gjf9RgMJqyn/glVP8tJ2l9l1TopfC2bam7SVaV0W86he7eycEsV/Cn0LxleakSQjJj0
	 pNZacr47SgSqLtYAE4EOIqZcX2ZfGr1xlWe3+4rEokYXLMQ2yNUYlfeSVE4hz6He2DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rq5II21h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8D606A32E;
	Sat,  7 Nov 2026 15:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rq5II21h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A51F008A3;
	Sat,  7 Nov 2026 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064161;
	bh=Leqibie+18fsQ869hph5EBnjN3NeXzRJ2up1y6iRXrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rq5II21hHK5mOLGAYRmoi8TyP9d5IpUVK+Dav48NBMBfSxx17OvK29josXTKCZj+5
	 juEL1zngKw7kcFLAFM+WXUTDV9zrPdcPOIJ3tTGS9O9jiepDcgK8N6JS2CV3Q9DXCu
	 j9Zw2xx4mzpNfAKakEwpiHYQcrz02OwBTL9KWWNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0309/1257] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Sat,  7 Nov 2026 08:43:25 -0500
Message-ID: <20261107134947.973287611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c709ff7aa6b57..02eede3fe582e 100644
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



