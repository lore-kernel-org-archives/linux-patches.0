Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063332;
	b=P9Tpk+vywsx/jDviPtL24Pglo0OTSmE5evJicfZIs4CiNZ7iyjVW0s1C8sqOlNkyYXok
	 lxCVe0OU3bA7lt+Egj3f8O0YBPfQj+w6XRYY/rRzHpPZ1qbwK8PbOHwginrhAQ/WvWvz4
	 fVWws0VQl1axhySr01zIXHbAcnbF8Vc62dYwkP/ePH1iPX+plRYXUax3Fedt8Hj8d1zvH
	 fcGyfayoHpyNQdRToXfK0V2FSeP0oJ+2bZIljst7EiVBdOBV08CTS9JfFsyYDCS0hwvMH
	 3jjGRY0zu916oIHX47thkA/Rp16zn+TIYNlyMj4ylj5O70nIdahNTYz1pmpbFlvWvEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=79YwzLtzKid3Nhnwa04hw6hZ0slQBzl8dcYo8JnTkP0=;
	b=Ic3iT8E09ldit3wdfRjWGUrDVeJL0PxMvNXWG8DM3XVmpj94a5Vnq6mAiu+nuLCgaB3L
	 XZu26Vez8iFfi7rWCaAH3LDfCzbJK+TfFunYnIItZkBqpS/9WbrOGp3E8GxOqm4AZl+r9
	 4DkEXObUH6C8onf+diZh8Aaqm8ColwTAoRLSGOBOT4NEQ2bCwHGYvlMZOYKUyd24UuW+h
	 2zlxDH3GTDvk0ByZPuiNblyw8jfbiw3JDPoQkpaVKo5CfsfJuJ0BbDAdHbsA5q03Qp2wn
	 GQrTu5itQvC9qaOrG8hDEu2QenBwaNnxY/r1nFDiZ8lhP3gsTN2gPqqKIGg6J3Rq5gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvodJ0Bx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9DA606D809;
	Sat,  7 Nov 2026 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rvodJ0Bx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE2D1F008A1;
	Sat,  7 Nov 2026 14:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063332;
	bh=79YwzLtzKid3Nhnwa04hw6hZ0slQBzl8dcYo8JnTkP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvodJ0Bx2LunJPd1YbREk6uphLzm4MRBSBfHruKhZ2abgTFh/cuFziIVJ23Fzdbxc
	 b96QUFyJkZ/ybcQ19o3uyF8W8Dhoyrb3Y4oMlRNjrncw6jG9agbMq87u8nC4eRNbP0
	 Cl//AthbNixSPwg1oR07/V+eV3SzkdmWjB1MCvgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/869] iomap: dont lose a fiemap iteration error when emitting the last extent
Date: Sat,  7 Nov 2026 08:53:16 -0500
Message-ID: <20261107134910.985798236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 0d0104adc2c8316433b660cdf6d182a09881864f ]

iomap_fiemap() emits extents one behind: iomap_fiemap_iter() flushes the
previous extent and remembers the current one, and the remembered extent
is written with FIEMAP_EXTENT_LAST after the iteration loop.

That final flush overwrites ret, so when ->iomap_begin() fails partway
through the iteration the error is replaced by the result of
iomap_to_fiemap() (zero on success) and iomap_fiemap() returns success
with a truncated extent list whose last entry is wrongly marked as the
last extent in the file.  The pre-iomap_iter code returned the error
from inside the loop, before flushing the pending extent.

Check for the iteration error before flushing the pending extent, so
that real errors are propagated and only a successful iteration emits
the final FIEMAP_EXTENT_LAST extent.  -ENOENT (no mapping) is still not
an error, and the pending extent is still emitted in that case.

Fixes: 7892386d3571 ("iomap: switch iomap_fiemap to use iomap_iter")
Cc: stable@vger.kernel.org # v5.15
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/250226e33b3b23c6b1714a45dc3c465c2a45cdc0.1790342457.git.parri.andrea@gmail.com
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index d11dadff82865..54b824b7edb5c 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -76,15 +76,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_fiemap_iter(&iter, fi, &prev);
 
+	/* inode with no (attribute) mapping will give ENOENT */
+	if (ret < 0 && ret != -ENOENT)
+		return ret;
+
 	if (prev.type != IOMAP_HOLE) {
 		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
 		if (ret < 0)
 			return ret;
 	}
-
-	/* inode with no (attribute) mapping will give ENOENT */
-	if (ret < 0 && ret != -ENOENT)
-		return ret;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
-- 
2.53.0



