Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828969;
	b=JTXdB18NZ54dy/95DDAeWMi3M1O7ORHMbnCZBq1AMGMKCkC9ZmBazHV+Fqpy1dvNGaY7
	 IOAogTq0xp1u0H60zzE3zr52kxQ/8UiMh5Al/tBH9fFqsHu0ViY5itTq62QoHLY/YFsWR
	 yhRy3L79R/E8WvBhV7t41iL1H009eL0B3It7up2z8vjsLsjAbP6nU8mJ/83pYoV+pJdpp
	 HUCkfRPSL3WBXHmBcdallDUlJ4djR7DWI7UkKDuhTyMkKdAQGP0kPKCcTiomM7QOVvHVn
	 Ah9fvLKhH2I8Fw8JMunOp+Pq9PcUMJhRMeYGJJr7EdlQm95YW9UAjlZqsMXGBvsacmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQ7B5xoroX41M+9HIef5emg3Dh2x6/txUkZTID+Xovw=;
	b=GvNXxZFBJsjp3W7HSBVlb5FpiQx/z9TX3It4/en4YnWGbYPZ46nbMXObZbGLcyjxIRg0
	 XeSLHcro0iIGPjD+paJrdOf+yZbZW8cnG0lUWmY7opWTThLYAraobc2EYY+nfaIgI0top
	 HmMoHlk0IB2P4qtNW5EHQ9QXHRjzNH63UMRIrwO4pnqbgU4LBWuwA2vatXMKMB8IVUgYc
	 cDyq1tRSCigpKJOQ/4lvYHwx9pW2VpGlVXS3CPY4/+qGkx6rtFI37brvkgQWDBHQRY6Cg
	 C4+ALLlZNzkfm2hkVDkKl3Y+gISZFQ3YrZxk6QeYsXYplcibofuiHTgx+Qx6b/RD/0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0lK5cYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72D8607E926;
	Wed,  4 Nov 2026 21:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0lK5cYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745DD1F0093A;
	Wed,  4 Nov 2026 21:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828968;
	bh=ZQ7B5xoroX41M+9HIef5emg3Dh2x6/txUkZTID+Xovw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0lK5cYGva+fYr7chO+ZHwOSAjCDAizgtnw3n3NES63kdM6dO6ttX/e8Ho9o+y3uI
	 GgNlc1wnR4XejNc88M4qzeZ7df0tP2vI4d+I4bLbBbP7qxe9llcK1NzM+IwKu1P/U3
	 SJ6SYQQWcX14Vsbg/BBr5QMujuaqT2bSv/IUgPOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 360/547] xfs: dont scan across metadata/regular directory trees for dirents
Date: Wed,  4 Nov 2026 16:09:04 -0500
Message-ID: <20261104211048.515752787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 03ce4ca43c00394364493865f417d646e252bac2 upstream.

LOLLM points out that the directory repair code should never scan files
in the regular directory tree when fixing a metadata directory and
vice-versa.  Amend the scan predicate to check this condition.

Cc: stable@vger.kernel.org # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1189,7 +1189,9 @@ xrep_dir_want_scan(
 	struct xrep_dir		*rd,
 	const struct xfs_inode	*ip)
 {
-	return ip != rd->sc->ip && !xrep_is_tempfile(ip);
+	return ip != rd->sc->ip &&
+	       xfs_is_metadir_inode(ip) == xfs_is_metadir_inode(rd->sc->ip) &&
+	       !xrep_is_tempfile(ip);
 }
 
 /*


