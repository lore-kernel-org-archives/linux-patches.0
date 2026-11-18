Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037304;
	b=YpI4mjid8+0+/kvXnDL4DWVT6YJZAraVHqHKEAYztL1TluBM+vgAu/jfMDXI1ciiWp39
	 UYN4YAdlH1ZmwQlWyvqt9BspZr6HcniXmH2ir68hXItOwoc56EjLH3bsChO9RIi5Q0XF1
	 7Hyb2Z5AOj4kE3IBW4TpLTyag4CtcITVskaIfroy+oqLScw99LDJiGYdgxmFHVNAK/2Ay
	 uT8vGrGERDQtW9yvL9s0zDY4p+fIhDR8piMqtP3Gz6gWHfxZ8WuArJtOMq5Guv5+t1CDC
	 XGdd6DjIjvHI6j0JIBmZljFZ8cokma/Xypw8OJw3STsHsZNMYstNlf6ra8nQ1jm02nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QWd+OntIS01wCC0Tdu5WblHe9I18d8ynLRZrwOA7JAw=;
	b=ESI2Ht5VtIOmxwLMS104R6t7DQ4rpTSKp2ivdIWzzOeJ1zvvBD4Bf6PAC5xAGkcUiSMv
	 J/PRPz/Vc64zeL+kJZjhpE9pTV/2GjiB9auI/JjMZ6nDAtSKf3AGMFKFFTmmxEdR2rk0o
	 xmHz1tWHuQ5INDUE9pHlXKEnuhGY0xWeWTKA2B+qe2Ug1eOJLW/9xA92fEFv1S7dmrIQR
	 uO2VXhq2i///X2JVRCKGucduzo9/FG9aWta7gWYtyix5lwlcG2yC7HqOHegsYpWmav+az
	 TcVzpby3fy3sMiC1ZjcjsgPbN8p+N9hgCuw7Z3cju7KHmHYfvFTt3poWNzw+JyeZSvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNzIyvBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BCF606A320;
	Wed, 18 Nov 2026 21:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LNzIyvBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2881F000C4;
	Wed, 18 Nov 2026 21:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037303;
	bh=QWd+OntIS01wCC0Tdu5WblHe9I18d8ynLRZrwOA7JAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNzIyvBaH8JtV4w+tr1dHn/Cz6sM8vmGTCowbGRyQ+rolS0Yp/TbHGiFrZ/uq+UAv
	 TIuJwwcjr6yf3k3jPq5lLFtbxWC7O1XLPaQztokL6EiwHZow10SEzUsJ8mIx8gw/nJ
	 dSzcxG7xeojqDdbyGuwMtzSK7nZVUMr2BZ+cS3zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1359/3318] xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
Date: Wed, 18 Nov 2026 15:33:01 +0100
Message-ID: <20261118150401.217816772@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit fd012955641881169a9f01a00f656f6ca73842ec ]

LOLLM suggests that we shouldn't try to allocate absurdly large buffers
for xattr value checks because that will push reclaim very hard, never
succeed, and is pointless because nobody can create xattrs that large.
Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
we can flag the corruption and return early.

Cc: stable@vger.kernel.org # v5.3
Fixes: 6d6ccedd76823c ("xfs: only allocate memory for scrubbing attributes when we need it")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted the check to the void xchk_xattr_listent() callback using sx->sc and goto fail_xref ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 04fe6446e9705..568c255ba8449 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -199,6 +199,12 @@ xchk_xattr_listent(
 		goto fail_xref;
 	}
 
+	/* Don't even try to handle a bizarrely large xattr. */
+	if (valuelen > XATTR_SIZE_MAX) {
+		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
+		goto fail_xref;
+	}
+
 	/*
 	 * Try to allocate enough memory to extrat the attr value.  If that
 	 * doesn't work, we overload the seen_enough variable to convey
-- 
2.53.0



