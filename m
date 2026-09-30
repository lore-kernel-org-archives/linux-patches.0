Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C933BBFCC;
	Wed, 30 Sep 2026 18:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794738; cv=none; b=YPCloy9BZKkfnFOYKxO6n5MDM68F2ciWL4xw09RmHNGNT5DmF7AGq4Inrdaa530qnIj4yfR4+fkxpjtGsm0NJonW/thZjSza0BvEozr9sjoIFEF6oCt7L8ONO0CaY6zBfTYoxOJeiWL1yG7A6OQKT9Pbh8oXOQh4BSJ1HAzv0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794738; c=relaxed/simple;
	bh=bGQGyMrhog6GKywSxH3YrItGRKd08BwySvEWV6izqDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5uZcrP+HfQ15OlaN7iDLGGAhRGYwlDAzcX78ImhL/ynxUFnPNO6ymSa32Oa/UYOcuQ4uMLepfRdcHok6qouA7GAuPsi/9c/kaNSJYvRJQmkncOwkAOtE3KfdWHcXnQnqJFXJ0o9rFYVh8ACgsHhJaUxMvG21dvQUHI0gVk/CVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaEJU00r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaEJU00r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491541F000FF;
	Wed, 30 Sep 2026 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794736;
	bh=omgQoSVWTOpMwq86VqmWTm+m5FIdyAmJogmqlMkNlbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IaEJU00rnSjg9Gy7Q6oYzzNVRmpXqOJgrnx5W5b7JaPQUA++vaoaDteYMkc6/B1TK
	 mFy48Epr/Xjwd7D5COC4Qv7ylOloAwqnQ79EnNiPyPsVyggTm5yT8e5ZKviNvzQUDQ
	 8hj6RRsvoYV3IrWRh04YMEJzh2B1F4TBccgw32Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0279/1193] freevxfs: dont BUG() on unknown typed-extent type
Date: Wed, 30 Sep 2026 17:16:03 +0200
Message-ID: <20260930152440.363562831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



