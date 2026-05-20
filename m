Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F534233933;
	Wed, 20 May 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299307; cv=none; b=IN1ZSZ1foi3NVq7lY8ECyLcnCwdMy14HQE1b7WwfXAIXb0W9hdoEqs6bGNIFkGabatlW8jbISBvVIlcWVcUCYGPDwzeG8t+2x8y9ASi/8VhvwIhh6B3hwsgLB94sm8rk5WzNEilV5bHGaZtEHa3Op4qBfbrml3SaXXfIeSM/Jw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299307; c=relaxed/simple;
	bh=9/n36nBzxjdu6UWZyuR0w5px93nasx1sSXaI4/FUmAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRpS5YuBpHRuRzudr9tZJSOQqHaG3cdynnNtaxv+fa9wV983Oj29LXSI9c4b+FhwsLdhpDfIV3VcXO8uvpeEfjFzkdNfE5mCN+Nz+a4VmvbbTDAgpua90ZJtfwLPKB1t8LsKJjU3DopoqxDZLFvjrvs3/8xr1y1rCYOaJiSEgTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNTMTdYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNTMTdYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5CC1F000E9;
	Wed, 20 May 2026 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299305;
	bh=4YckN3UlHOLT4YqMNgnixF/unYWcwmzRHLD3xMWttzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNTMTdYbMuoWvXIrK2JyV7rv8y9JdQa1wc2eiRCqAEZX8FZDEfMOlzyGWosX6Nm2T
	 0gjez+eAlV6Th9kH46XlYMU5thcMKn5JYXIBNWsVL3TFjFKvQEvFDU15vIGiaOh3+Q
	 yHnPjYfQxdSkiO45qolD1sQzF2+CvyjnJapDWumU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 723/957] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Wed, 20 May 2026 18:20:06 +0200
Message-ID: <20260520162150.230711350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fdccdbbfc2130..4f5279cd456fe 100644
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



