Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062336;
	b=1FzE20l6HR6B5YSgQjAsN1pG/z5qr4bNG5mfyIJYqh+b8J9hKhky6eLbjpdm5lWeFcw4
	 IWUtnNa+d5O/ZnWx4dfGU+w07Ocs+ja4RRCuu/XuSCTAlsd/rNDNE2B7XzgitWq9EjMo2
	 g3BhCABIY5k+infaiPQuYyYo4Z+3LAoG10yqpD+7BeyMe/KhPpzLLnGLajbt9xdVy6cJm
	 JtFBipi9bgR9zyF/ilOLvKCmlrNQHD1x1nnozlYMO29GYgloUZ33CaCxtWR86Yer+EeHC
	 267iLLESaNhUEMz4rG0C/9bHnJph8XbBRASdGU9gm1+IYAlNL38wCmEbiWrerLlLrlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SbFOMhGa+ML+A08qGVSaCkcO1oIuv94KaCp2ycNqQ80=;
	b=hhbr2bOxDu20OonX78ENRNOMvxRH4k8fLYraTiXs/B59apOSeZixV8rTv+6pi5m+f3hh
	 d5SHqsXR9guUtzB4JIxRjaORfyFixzu9g+pjuayN2h2sweaLJFZiHTsvSXaRvpLYXYJqL
	 wfhqUvH/uvo1qqtaZRsDiEHpcT5Z9VPOxR0TqpdbX13MV00/K/L0Mjh/nPR+hyfIYtYKa
	 o5Xjq12CLsQpAWQwCfySMvKfPaGVE+BSiVD4FweMu5WYK1WDKoYezzGK3VJhoUow4PQAu
	 vdk9Y6HJGhflXNS4QD/cRhu35ZOEzrW446l/5dz7WTM5fT2rY74Ucn+huuPjAB6E9DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PC+dptU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77953606D807;
	Sat,  7 Nov 2026 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PC+dptU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1F51F008A7;
	Sat,  7 Nov 2026 14:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062336;
	bh=SbFOMhGa+ML+A08qGVSaCkcO1oIuv94KaCp2ycNqQ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PC+dptUv8t8tVY4wCHHaEvYXResHijWbh5klx3skxfZ7tTKS8Shw7w+iwah2liyv
	 39JZvv72zq3ZxugJrxNTqCbnKIuwZwHG/h9qsTBvWvshqOzJ9F+tIT4K39tE95AGoL
	 izFOiB9+/QBp6DZm8Tp5jLjyxiHsr94EYI01GUTM=
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
Subject: [PATCH 6.12 1265/1536] iomap: dont lose a fiemap iteration error when emitting the last extent
Date: Sat,  7 Nov 2026 08:54:41 -0500
Message-ID: <20261107135033.302551044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



