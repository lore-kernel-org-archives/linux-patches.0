Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48D22E7398;
	Sat, 30 May 2026 18:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166729; cv=none; b=AxoUbA6Y+ZVNG7ocMDYlQ/ycbHjL6BSND5BhRzXYv3cvezYpaFn48W1/K1yJijrkMzGf0NjHyhbQWI6wECbMORpAaGxqZYVKDtvqVjs90byzoha3J5ll9x7kFkw3nJ1gq7bPbCFG53eAemyXpz/i78zHPXkIl/euccTbWMqT5x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166729; c=relaxed/simple;
	bh=yFuIKgs3VGFXxNexsR8w+O+qCIH59zaXLrIK/9ojtrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am3IiDtWcAEAWQDFnGgeZw05gQ5l2KP2neZm7CB9KH/RHvNALF2FrPLwqS7Gu7wGTBJdkH8bYUxmcl7zu18TtlXp/P6H1Xm5sDNsGxHMPYFyt/b5P74a/C2fpVCgqj/L8vD0Rq+D7ULCuUc3j0PZTcuRY1abC2gDb8OIcYCDcEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlMuVrID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlMuVrID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB051F00893;
	Sat, 30 May 2026 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166728;
	bh=nANaX9zUkWksTvHZvRVkldyhgUasIM+A9m7aMH8WJbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlMuVrIDWaubZCvyyfRqT3fDRxhceivjFMX/m0r4KIo19Z3F/jPWU6DhzmZI+VsQ/
	 lf8ngHRnuMm1vu3m2SRwJ7K8ZCdCXF9Ei2xPVShYAPy9WzURM0hcPIYOYQFrO5PFNT
	 qFVkOFQOHt3iILuizUQZW8f1tmXnMNSOk81irTeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 453/589] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Sat, 30 May 2026 18:05:34 +0200
Message-ID: <20260530160236.593943043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bae Yeonju <iwasbaeyz@gmail.com>

[ Upstream commit dd9d3e16c2d5fa166e13dce07413be51f42c8f5d ]

Reject ADFS disc records with a zero zone count during boot block
validation, before the disc record is used.

When nzones is 0, adfs_read_map() passes it to kmalloc_array(0, ...)
which returns ZERO_SIZE_PTR, and adfs_map_layout() then writes to
dm[-1], causing an out-of-bounds write before the allocated buffer.

adfs_validate_dr0() already rejects nzones != 1 for old-format
images.  Add the equivalent check to adfs_validate_bblk() for
new-format images so that a crafted image with nzones == 0 is
rejected at probe time.

Found by syzkaller.

Fixes: f6f14a0d71b0 ("fs/adfs: map: move map-specific sb initialisation to map.c")
Signed-off-by: Bae Yeonju <iwasbaeyz@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/adfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index bdbd26e571ed3..7da236fd7a119 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -343,6 +343,9 @@ static int adfs_validate_bblk(struct super_block *sb, struct buffer_head *bh,
 	if (adfs_checkdiscrecord(dr))
 		return -EILSEQ;
 
+	if ((dr->nzones | dr->nzones_high << 8) == 0)
+		return -EILSEQ;
+
 	*drp = dr;
 	return 0;
 }
-- 
2.53.0



