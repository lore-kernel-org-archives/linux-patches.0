Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C651588D;
	Wed, 30 Sep 2026 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784687; cv=none; b=MttJK/ywkmeIYUtTm7zZARhWK7MHa60ZKUrEtBeGnkZu44QWGQSd2PAvX5/pS54hM/cX4ZXbHU4vLrIh9qwqewXWGF5aFyKrSRmVot6zHahHSfWW46sYC+JhYgeBTo2lKyC0fykWPFuoLJKbfSq8VwirGfcOf8IKLFSbWyXRfPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784687; c=relaxed/simple;
	bh=UwBcqbBaf0a6II90iItrCzUJi8g9hwxLdEA2spRr5F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8cvQPKhuFS3IMdjH4IYTECJD86GPZFThFyQ34SWa7YVtu/+GUu1xJnEbdPCvhG4n5BCUi/4IAU5t5Wi2+TT1gocVbfemhXVapXQY10GqxPLOCn5XAxJg+hSpQrwyfsFt0cy1wr4CC3PLui9cbcz/p+iBCOfUJgt/LINPcCkSZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGAy6KbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGAy6KbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40871F00893;
	Wed, 30 Sep 2026 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784680;
	bh=jcuhN8deLqOKMcoWZ0WbyRCUWytENj05AdMW2Xm1OBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGAy6KbDHLQENPyU5B2d7vrAMJAK/k1xiADxaO4m3nc/vziJVtRMHYmT+YK/CdZYH
	 Oze9RUx4H3LSffKEQUoUw+h+z3eYhjc1houmA9lMtWEWkxT+isRoC0m+UcdK/rfQUD
	 jjSHO2z+OXiiW1w18tDKJd/FRWZM2NS0RGwhOaL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/982] freevxfs: dont BUG() on unknown typed-extent type
Date: Wed, 30 Sep 2026 17:16:16 +0200
Message-ID: <20260930152421.949794463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhad Alemi <farhad.alemi@berkeley.edu>

[ Upstream commit 704d48d81dc41470e108811c32c577ada66192d4 ]

vxfs_bmap_typed() handles four typed-extent types and calls BUG() in
its default case, so an on-disk typed extent with any other type value
crashes the kernel. It is reachable from ioctl(FIBMAP) on a regular
file:

  kernel BUG at fs/freevxfs/vxfs_bmap.c:230!
  RIP: vxfs_bmap_typed fs/freevxfs/vxfs_bmap.c:230 [inline]
       vxfs_bmap1+0x128a/0x12d0 fs/freevxfs/vxfs_bmap.c:257

Replace the BUG() with WARN_ON_ONCE() and return 0 -- the value
vxfs_bmap_typed() already returns on failure (and from the DEV4 case
above); vxfs_getblk() maps 0 to -EIO, so the ioctl fails cleanly.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Link: https://patch.msgid.link/CA+0ovChveuAwv=t15dr2m09E32bM48hHJxvfeEYZOhdNiEc9Tw@mail.gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/freevxfs/vxfs_bmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/freevxfs/vxfs_bmap.c b/fs/freevxfs/vxfs_bmap.c
index de2a5bccb9307..d10a99b25be8c 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -227,7 +227,8 @@ vxfs_bmap_typed(struct inode *ip, long iblock)
 			return 0;
 		}
 		default:
-			BUG();
+			WARN_ON_ONCE(1);
+			return 0;
 		}
 	}
 
-- 
2.53.0



