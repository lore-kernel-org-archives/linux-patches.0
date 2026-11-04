Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831570;
	b=xlq1x8hgy22X1Wq1TBGZ47/R51tcWKuBEywVmKUHIOMEEmvDW+0nuC/LWyw+Hkjh2cmO
	 m2vXUw7poW7yK1ypqV6LHEhx83xu9pEDLocKVwe0gJj5IiFjkApgIge0Ygvzz9Q1Z9JT2
	 pdQK7pyAtsstTmreoZNXCdHEfm3AGFBxFM0KZ36j54z0/YajawUlJm9gG+h7nTGYYjibK
	 iY1b5M4Wln88L8lsc3Bvn0BRQmZZTV6b6B5i3+MnyHiO5dONxuS1FFbQIvyB1u8iGPL7F
	 XZuqANla01xlIp83/2nldL6w4s/+9BnKpjgxaTSvUedM0QCT5KBnZu1I++nBfpaEXSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j7G4imNLJ3dE9Ot3swOkrzpddwcKXM4eaQJE3PMhHkU=;
	b=RQwQsVjHPBVu5XgN/L+adSQbZpMpQaQYVacxebJ/YaYE0Ro/UdWRsekw1i7zZBpQlsaY
	 5s/7OceTZA6Nnpmw4OVpW/w1KGBNyw5o5OEx54iBSNbQ+xorD5kGMcEHzqtLAzQ4kkqVX
	 l8FVFjiVCx1FDx4xjgl1Vhac3u8k/TJdmSClAqEdTrzRe2RtPX5YEiBGWy8MLCm/RBA2Q
	 aZI1JtxOk9g6vN2Y/dxKGrbSXkII1j5plGxevlibmbGGTnZt+33433R5p0IrzirbIXae6
	 veF9XEOOPKZiWoxXcxKdB8gWpB3m7JLCn3J3AQ11cT5DARcgnzM/f86QTMN37bn1EDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvTQLLH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9009606A844;
	Wed,  4 Nov 2026 22:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvTQLLH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D211F00A16;
	Wed,  4 Nov 2026 22:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831569;
	bh=j7G4imNLJ3dE9Ot3swOkrzpddwcKXM4eaQJE3PMhHkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvTQLLH7Hw51QP5aIrqgswREWEpUqC/Y7CuGQmOmf63hPswSLwHa4noXpgVXL1a0l
	 hXdkWGoFE46jtfUT+ZHKZYjysLkpEyrwD0Qat1qhMB28Tg8jfXVeV80La60JK7Dp49
	 v7TTyAaQwi+jXhAyYujyEdbAT9mw9cdZMvI1roUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hch@lst.de,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0782/1005] xfs: actually lock the metafile reservation when adjusting after repair
Date: Wed,  4 Nov 2026 16:08:35 -0500
Message-ID: <20261104211105.263349130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e53c620b3670fc0c162b5f768a10a3a17d0c04f6 upstream.

LOLLM reported that xrep_reset_metafile_resv performs unlocked loads
and stores to the metadata file space reservation counters and thus can
race with other threads.  Fix this by taking the lock.

Cc: hch@lst.de
Cc: stable@vger.kernel.org # v6.15
Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/repair.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1377,12 +1377,14 @@ xrep_reset_metafile_resv(
 {
 	struct xfs_mount	*mp = sc->mp;
 	int64_t			delta;
-	int			error;
+	int			error = 0;
+
+	mutex_lock(&mp->m_metafile_resv_lock);
 
 	delta = mp->m_metafile_resv_used + mp->m_metafile_resv_avail -
 		mp->m_metafile_resv_target;
 	if (delta == 0)
-		return 0;
+		goto out_resv_lock;
 
 	/*
 	 * Too many blocks have been reserved, transfer some from the incore
@@ -1398,7 +1400,7 @@ xrep_reset_metafile_resv(
 			mp->m_metafile_resv_avail -= give_back;
 		}
 
-		return 0;
+		goto out_resv_lock;
 	}
 
 	/*
@@ -1412,14 +1414,18 @@ xrep_reset_metafile_resv(
 		if (delta == 0) {
 			xfs_warn(sc->mp,
 "Insufficient free space to reset metabtree reservation after repair.");
-			return 0;
+			error = 0;
+			goto out_resv_lock;
 		}
 		error = xfs_dec_fdblocks(mp, delta, true);
 	}
 	if (error)
-		return error;
+		goto out_resv_lock;
 
 	xfs_mod_sb_delalloc(mp, delta);
 	mp->m_metafile_resv_avail += delta;
-	return 0;
+
+out_resv_lock:
+	mutex_unlock(&mp->m_metafile_resv_lock);
+	return error;
 }


