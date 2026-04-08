Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5A03ACA41;
	Wed,  8 Apr 2026 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672852; cv=none; b=T9SDH4tuwyB6i75YDbNpi/QNt2fG4KmBsFBK7D8kGv5TL71Js9Gi7H9wuWf62cQmuVlcKzefvpOLNHAYHH3Xm37wScaoxBYFX3tDc1+JOZPYEZqRe+GaoY0HKo3PW//xYeO/f3AcK0YxxsQxmA61cmoP+f51K0ooXSi28oWR5i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672852; c=relaxed/simple;
	bh=qPKdeAEopu81ueNN05aXTiSBVY2Ab2cIZngZDz8Z8pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xbv+y8sJivaVySo1t+lpkppd0vwoA/G1UUMzwgN1fi+WieQolN0v6fedcZ/5WLsV3bUR0eAYB+Y0E2ufGUbQjT1XTW2fZpB79WU4LAxoUKMxMJ6pCUTlOGnwv/UqUbgagc9+x1pg+hm5pAiCyIG879dp2IbxSnsBl27PRAtg60E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccj7VHsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccj7VHsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEAEC19425;
	Wed,  8 Apr 2026 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672852;
	bh=qPKdeAEopu81ueNN05aXTiSBVY2Ab2cIZngZDz8Z8pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ccj7VHsiLmHtcjzMXJ3OYYKvcfJa2h0Pt7RPTHTboRPrUD+37VElkT5ABBrzI7S8A
	 6nxV8ZnL9iC/zOe5botWhp/Ndh076nL3/nwGBwvcOKDgwZSesgyhCaKKMK0qFQbmQ7
	 YmuADe+NMV4SZmFkepuaEdws7yvwhYNzLDHwJlEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Ron Economos <re@w6rz.net>,
	Brett A C Sheffield <bacs@librecast.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Schneider <pschneider1968@googlemail.com>,
	"Pavel Machek (CIP)" <pavel@denx.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Markus Reichelt <lkt+2023@mareichelt.com>,
	Ronald Warsow <rwarsow@gmx.de>,
	Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/160] gfs2: Validate i_depth for exhash directories
Date: Wed,  8 Apr 2026 20:03:47 +0200
Message-ID: <20260408175918.413462054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 557c024ca7250bb65ae60f16c02074106c2f197b ]

A fuzzer test introduced corruption that ends up with a depth of 0 in
dir_e_read(), causing an undefined shift by 32 at:

  index = hash >> (32 - dip->i_depth);

As calculated in an open-coded way in dir_make_exhash(), the minimum
depth for an exhash directory is ilog2(sdp->sd_hash_ptrs) and 0 is
invalid as sdp->sd_hash_ptrs is fixed as sdp->bsize / 16 at mount time.

So we can avoid the undefined behaviour by checking for depth values
lower than the minimum in gfs2_dinode_in(). Values greater than the
maximum are already being checked for there.

Also switch the calculation in dir_make_exhash() to use ilog2() to
clarify how the depth is calculated.

Tested with the syzkaller repro.c and xfstests '-g quick'.

Reported-by: syzbot+4708579bb230a0582a57@syzkaller.appspotmail.com
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Tested-by: Hardik Garg <hargar@linux.microsoft.com>
Tested-by: Ron Economos <re@w6rz.net>
Tested-by: Brett A C Sheffield <bacs@librecast.net>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Tested-by: Peter Schneider <pschneider1968@googlemail.com>
Tested-by: Pavel Machek (CIP) <pavel@denx.de>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
Tested-by: Ronald Warsow <rwarsow@gmx.de>
Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/dir.c   | 6 ++----
 fs/gfs2/glops.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c252400e59994..c4e9488483d90 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -60,6 +60,7 @@
 #include <linux/crc32.h>
 #include <linux/vmalloc.h>
 #include <linux/bio.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -912,7 +913,6 @@ static int dir_make_exhash(struct inode *inode)
 	struct qstr args;
 	struct buffer_head *bh, *dibh;
 	struct gfs2_leaf *leaf;
-	int y;
 	u32 x;
 	__be64 *lp;
 	u64 bn;
@@ -979,9 +979,7 @@ static int dir_make_exhash(struct inode *inode)
 	i_size_write(inode, sdp->sd_sb.sb_bsize / 2);
 	gfs2_add_inode_blocks(&dip->i_inode, 1);
 	dip->i_diskflags |= GFS2_DIF_EXHASH;
-
-	for (x = sdp->sd_hash_ptrs, y = -1; x; x >>= 1, y++) ;
-	dip->i_depth = y;
+	dip->i_depth = ilog2(sdp->sd_hash_ptrs);
 
 	gfs2_dinode_out(dip, dibh->b_data);
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 2ec0b6871ae94..f575cd8ff47c1 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -11,6 +11,7 @@
 #include <linux/bio.h>
 #include <linux/posix_acl.h>
 #include <linux/security.h>
+#include <linux/log2.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -466,6 +467,11 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
+	if ((ip->i_diskflags & GFS2_DIF_EXHASH) &&
+	    depth < ilog2(sdp->sd_hash_ptrs)) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
-- 
2.53.0



