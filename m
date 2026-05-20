Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C23D88FC;
	Wed, 20 May 2026 18:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301292; cv=none; b=bj7qGYOODxTHoP/bORXGPCoMmpznrQZlodM16ZGRmzwr36M36Y+FRWOinDIAJWZA4MM4HV+m3Ir/gbOKpJyPtpq2fgrYsUE2XYpNh14wLiifu57k9nQrWP4vyzfg7bGTM3PPPbydKPn0FpQb/xEaUf9wp2VsH55XAugvJhDl650=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301292; c=relaxed/simple;
	bh=hUEcYLiurQiykA3pC/soJ8bi+UJVZRR7xTuRqSw9mBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER64RwYKByAqKIg2+YJEGPAkUSjxBbI1h+YGO3iLzE+nPUCcF6KeiuOB/FsAB+6emU/YNPIZaNyH8T9odhsgOIyMdvUcA0r+YrP+KtrKSnvu3wxFtXOOJPbwtZ8hHlXUXrkDvj6c8/yq4F/1HXgnGa3lc0kubn3eUeIKK67XCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDlnpyC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDlnpyC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75751F000E9;
	Wed, 20 May 2026 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301291;
	bh=b0jBY6T9LpyEJ6sUwcFoh359vXk15dVcSf2rN4G3d1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDlnpyC+09YQ9v+x4KaawIPxp/o5q/zMSspGJAlkd1cYm8cMMmYZyDlf/V3vNsRF8
	 8SySwdwy3TLDm6f8O3JvE36Ff9bMyLY0I1OLo+K9SS1jnEvhIBIJleoluTqzb2J0y3
	 dVlij+IDF+Q55ANUbWZR6gSQlvfSjElQ7UsYahmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/666] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Wed, 20 May 2026 18:21:50 +0200
Message-ID: <20260520162122.074952710@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f0b999a4961b2..998ea8a2f8337 100644
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



