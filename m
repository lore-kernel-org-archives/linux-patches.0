Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379003FD133;
	Wed, 20 May 2026 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302668; cv=none; b=aKIFwKTxrS+EchKggckQP0Gkq++aBplI9uMFv+83doy08VC5qQkhvKvE4CY2c8k4nH4Ds8lHE0WXI0p0YIOr6vn6xLJ/aO86qG4HcqOQ3LUa/b15hkcIlPfxwHXdmp2WMjYzM9A8OvshFDVkZ6ho6ECv0aQvrYU5v147TNSf3I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302668; c=relaxed/simple;
	bh=WnJw1nF3IGwPKKqZ5K3QSJ610iJYKfGohcrfu/VW8AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjOUhEgwoUuv7t/S1pZ0JBFEv436T5oHy8f8t3cOIgAlncK+YkZ3edZcb1VaI5UThvUEfn0rKTqMV2rK6SskzNhsLShNxRHJi56o7S8dGN8hrVKFeINmZVzw97HiUr62Zi0BCz+FG7enmv/WsqfzqJSO0zK2A92mv/FS+3s5RJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TehzHQEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TehzHQEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D08C1F000E9;
	Wed, 20 May 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302667;
	bh=HKcpvFYY+44aynlOacJSiL0Ro0wrrRGdfq6xwAax+yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TehzHQEEwMzIG4UYblEivClxBGQP5qoKpZjP1COsYIX/O7rgjpzElOr0WlMMpuAQy
	 Jb1qhjjXbV0Ti7Nlzzys2ZBV+jgGf//0gcIXru9caTUOvw75YqhOK6k3v+S+2vv4Ek
	 k9oe6f3vHe8tebVEwAM9E4Cxczq1xxFjR+yLUlRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bae Yeonju <iwasbaeyz@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 355/508] fs/adfs: validate nzones in adfs_validate_bblk()
Date: Wed, 20 May 2026 18:22:58 +0200
Message-ID: <20260520162106.325140786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8bfc38239cd5..76e37c6d4cad4 100644
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



