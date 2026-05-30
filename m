Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3329B799;
	Sat, 30 May 2026 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164669; cv=none; b=BCVdyLMXRK0aug4MZXPTmQrMhckqENGKP15dIzyeZj9rtkCM0SWOglk/iLgWAjwTs5eELi9TvGmU79idfETjGIjLK8Ob78XCIN3Hi7k8GJl1+MVf7uVdMJ1K+05R0Zpd5zG9Asvgt9BgXUZx/ePHwrhzgwbXrXaW+M1I+xb4kdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164669; c=relaxed/simple;
	bh=QV/X/NbtkaUkrvkwau9/vNw8IBfFk8AjeTHUE5YsebU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtdumqTMRt5OxuyFYkFWR0+m0DPu3p029qSjZXlHfznBZ0diBE+TNEicqxT0ZXDGkfRz1V5/25kyDxEgxZO0DnbGUQ6PtlosxPnjfuwCNSVOocL+5KMCF/nAwxiV3vfpa+sI4ZBNO4NCuaJvr452dRxm019Mk7juUiQlwaIfUW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIPrHFz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIPrHFz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555851F00893;
	Sat, 30 May 2026 18:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164668;
	bh=W0Z4yyQylPQkST/odny1QioL8G7W0pZAiqeyEhGbH94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fIPrHFz+Se2YUtl0i8FaXp6zp2B6r3NT9MuMNszvBdYcWiR62H1ysiOdTsAimcU/r
	 pryi71oV1CiGTQ0pY/4HCFV3HiQL+bN8+UX0wA9wFcf4O8heGYRM3ZSflF/Ax9MHYJ
	 980Mqe80EAnC6FKrnBCoeSl/h3DnsJ+pu3VzPez8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 594/776] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Sat, 30 May 2026 18:05:08 +0200
Message-ID: <20260530160255.401024104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



