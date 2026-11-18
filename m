Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036528;
	b=uhU+b3mhIkxZpvpi7P/7lIc1/uKPXuNE1xobfLaujfF6RrC+EYUtihJJVn5EEmckSNl+
	 dRuYQLgfwMrkkku263BJKgwbwekwVg+2CY8yhE5SiGkHlAMQjyQnqjwa4nSa6u5J/RCFx
	 Yq/THSQm6xOTELj0OPGUssGH/RfwfzBVEt2Qc0A/ifBe2G4Yp7vAAjHK6b2maYALby8I6
	 MP1Z9L5oi4worGkBRd7FEdR1tjDIXD0tdZA1q90OQ6f3ZXToP5eHFeShxS9ybqad0npuy
	 alQuMAOD0xX5NxqZ76FL6x0dYuaqb2IgmefFee3awTUStjVfB2HK+ik5gZh4bX7kgrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DKqJ4QWXsJYMDnSRlMBrGpDl3qLgvUVpYcwNKlJ6X+4=;
	b=nbYj+lbEaI9ID3beS/vpW3y6lHwV0LhzngQLgrGwZLvDycC48yDvGff/x2PcBnS1kE8B
	 53wF/nSGiSxtD303o/z9ud0kOyl+qLg9vtfyajkYfAoEyBjCol06ONtpqE6/ieOFXGGmy
	 /W+QHn3InCdG8ZOHaB4HFxl3sAtOqNn99hAvrS8jd8FnKBHn8rJBoWSt+PhIpN2SJdMtv
	 9TfBJ+FW6DQyLdMDE93z4Eu/MPUyXTDUnSBBYYRZi+c8eC54210AX+4iWEcSRhCNkCzqB
	 GBdbmVY8XcwPYHAdh8x3Qee0z9SpXp0gUbFP7pZ/7W/wFNGr8oM4yxKbjz8YXt3SH6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GPTVCo7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8D0606A320;
	Wed, 18 Nov 2026 21:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GPTVCo7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8E81F000C5;
	Wed, 18 Nov 2026 21:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036528;
	bh=DKqJ4QWXsJYMDnSRlMBrGpDl3qLgvUVpYcwNKlJ6X+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GPTVCo7BkxcHCaAOuQQhGy2CN/5k46kkwOZ64aE6ehAeMCLw+daTwn7XkCkcWFaK
	 uAvbouGSaaRJ6NbqYjspzweNrV5X8P5R5lxIInDAVCsIeFhtlGwSgP7vbRT9tghRds
	 H7khqEQlsWeGziX1RlctOUITfTmvbawludywdOcg=
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
Subject: [PATCH 6.6 1091/3318] iomap: dont lose a fiemap iteration error when emitting the last extent
Date: Wed, 18 Nov 2026 15:28:33 +0100
Message-ID: <20261118150352.706353005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 610ca6f1ec9b6..1cf49bac25011 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -80,15 +80,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_fiemap_iter(&iter, fi, &prev);
 
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



