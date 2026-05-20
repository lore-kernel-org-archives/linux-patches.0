Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8143F23D9;
	Wed, 20 May 2026 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296665; cv=none; b=uLBI4tzWfgPomu4cfAijCmz1rn8Ogt7qvNn2vTB1CA5kajot56vNAgBlplQrOU/IgkzYekU+XRnE+ahgYgN20rFRRWDIhUvn4FUFvQMQTEt8wiOMBEM2Ub2TBxDPCQRDSLErTx8z8gpv/i/9B84Clm7PlPpebBowWpb4wrMfCc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296665; c=relaxed/simple;
	bh=F6HZXWmzYE4cHA6zx8Xl2F/aO2yXe4/PNq3AhXpQWys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwhdgwJvJSUwog2xxVTAS2nBDyWTX/4U7IOYaKg/M7jAuRRi1bGaT9O0GDw9xCE1gcQp/DHanLDhzvVosaItnL/97CTcnQmeUkHzWccMfoV4QRajC8Of17JB3h1BeujpK8VYw38lCA7BY7lhVDEBCny0UO6m2hSRSI2qNZveRqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+Wisv4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+Wisv4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16131F00893;
	Wed, 20 May 2026 17:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296664;
	bh=r9HxFwxtktZDy8EdD2JjmCjUtRaIxxlYiD1YKZ2hopI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+Wisv4/ReEuvLpUKzIMbejvWIP9NBrSvEZ+hg4AcXWVyDBwbbtIfFypGbRAQ2Zgl
	 CBAc7hb8jpYlqMO7VEQfA2etphBiDvtCxchs2D9bNiwWAE4MaQxkxTQdJJWlBPc6sd
	 wl3elmgn+gXWefwcbV9UcP+yqwRKQP9vo5oYguBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0868/1146] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Wed, 20 May 2026 18:18:38 +0200
Message-ID: <20260520162207.883001485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 2c5b2076acf9e..a4cd0a5159dd1 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -317,6 +317,9 @@ static int adfs_validate_bblk(struct super_block *sb, struct buffer_head *bh,
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



