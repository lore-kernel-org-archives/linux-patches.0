Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BAE4FC35E;
	Wed, 30 Sep 2026 15:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782750; cv=none; b=QLaH/fAmXVTpK+x2oczzPXrsyXqdMA7KynMzUVem8bl03dYhZ+58Kl66XUr73/V5zsX0a2F1O7qQEvYC5YKfCGOlX2i6CrBq40wwd31J6RAUdNY1TG03fyMPix+VtX2ypdPcg3vlY4R1/bcvXF77c2s4ROAVCkSDawNrJD+doIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782750; c=relaxed/simple;
	bh=RkkasjVhsyu/Cvo1aIdNUSOxwR7voBRWoJoPjAzDHgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llgN19Njs7cmqcPPfZ/GkQdK2cxSqiRUTZCJG9FpC/kS7NE9kNlp/R5+2MzRvZNvuge6MFDKclT0oQv0mmFse1j3D/X7uZ4eWlgPJZd8cPHTfGUjGVcFUJVjkPfDh27s/as+/nZlp8iXLb0m/YCJglD5uAAgPvHD0zXXiqEGuew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkBCirJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkBCirJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152A11F00893;
	Wed, 30 Sep 2026 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782743;
	bh=bLUIYR0zymoxYy4e3HJuTfQf3RJ89oPjrlbXn67kKbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkBCirJJORqwBAkuoBT5Uhv1IHAOsMBDhe3eZ4SfvjMPHhyaYE20u5oqfJn+LMZ7m
	 nR3S3rjDxJZmlt1IiYWY+0+2H2cs47WRRavIA00r4FhUKtaaVs/cotVWzxfCmwcumK
	 J6F5i3syZeSabU9rQXWhWHaSItuhbq5csUHbrDFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/595] freevxfs: dont BUG() on unknown typed-extent type
Date: Wed, 30 Sep 2026 17:20:45 +0200
Message-ID: <20260930152351.004635621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 1fd41cf98b9fc..6e032ae155138 100644
--- a/fs/freevxfs/vxfs_bmap.c
+++ b/fs/freevxfs/vxfs_bmap.c
@@ -251,7 +251,8 @@ vxfs_bmap_typed(struct inode *ip, long iblock)
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



