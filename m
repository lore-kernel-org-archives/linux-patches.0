Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0DA4FD786;
	Thu, 17 Sep 2026 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664772; cv=none; b=g04WiFrgbeiuNLf7eUXsjxpJVb0SD6mV3+Gw8hf5cQtZimaQyee4o0U87Lu0WZm2p73wSWEVjnEIEzIVBb+p/IO29/gg0wwXzTznOAXpMhMuGZwWk8TI79tVQEYgdgSHCHD5SbIGVcYNyUCkquVLfwRjCn+f0hIIdGgaZ7iABfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664772; c=relaxed/simple;
	bh=d1/xrpOELrsoEQDveGWTR5/j0PpMRgaRyNL8e3+ql3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sbw3xmdIOQtre0woE9QSp9drrm7G6b8f3sZjB1YTvhpilyzlhl4bmM9Z3koyLCekZQpcqe2tNWvywLqyU8GKAnq9Cmz9SGMQcn93373+KilpQXir7Yurpl3F+tK5hMoEtz8pwXyxMWexfftBdPHygDz6uNX5D7uPzZTgmLUG0lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJtKdHVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJtKdHVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5292F1F000FF;
	Thu, 17 Sep 2026 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664770;
	bh=Ohld/zU0T29cdVTibVTaxlpGl4qgJB7u+DxdeP5g65E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJtKdHVCEOUrPKTt7mM5eU/jBQ0JaM0viW0zmmkbrMEpUke8hLd/GvxZPiw4tmeg5
	 JO3nRyY/W7qsnansNrrHBCs7JlAN8XDX4p1MytVQAqsYTr1phlytdh1WQjqoCrJmhW
	 dR/gJbHTIUWPWGSo3TJSB0FYkqr8awnFUHCNPwRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0484/1250] freevxfs: dont BUG() on unknown typed-extent type
Date: Thu, 17 Sep 2026 16:04:39 +0100
Message-ID: <20260917151605.085826909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 26d367e3668da..de4003597b555 100644
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



