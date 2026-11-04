Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828964;
	b=TL1yrFbcZUMdqgSJAVOy1Qad3hYp4qZzuVsuQEIm/PkKyWDeqjAUo4l6nMzVX2q2ZcC5
	 f68rzbfok7UdEwcd3bAatYxOsi7jsyRJXo6BivZUpETrLtDj+2MgAIifrFwHcVyyQeUKZ
	 6ZYsvCK1Kq2w7NTwuHa5N1SoztDccTwVo3fps2TWVJsmtejEpxLK9B12TCqh08VPkZJRU
	 o4gIxM8ZXlo8GCQnhwkH28+6fmLPvZS/i319t9Wgp7NGwgaz/U023lkh11/zgIEx6654p
	 Q6vpv0EDN1Mjo2XFam8mSUkKlWdAJkUpHhYQqxTm8Q72RK+oYp+gDptbmT4vIKf1yow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JzfxslzSedBVksJEg+/Va+FW009Jjb/QAiF66vpZpjA=;
	b=xUXlyc0gRfo0THsmAZQX3H/jY8kdg7d5pPMd/rErESLqmIp6+D/+yBIZtZNOm6kW2YOB
	 Ocb1ddnfICwfo1FIGjq9TnSIxy/NG3qCsvpC7dIZxujPp7r+bbSbA425m2/pVjcywg8bP
	 jq9eGOCpUnxxBQeei3ylUc7oVPE39ihuFfMwciEBzRobwwjbrrd31pfO8gz1eCSQisuIS
	 3ndoMUSD7SFm+CDT32NT5eWSrP6gq1CQPBe1fbGdrinLgxVicRTBClA4z5+cTMpkmM7Sd
	 RZ1Vlm110xZsAfMhFJxWVgOEKEN7ym6Eeo4tP7mEMZnAtnIGU9rK3COvtTu5sOlJjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsHVV34Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B916070749;
	Wed,  4 Nov 2026 21:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsHVV34Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D81F000C1;
	Wed,  4 Nov 2026 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828964;
	bh=JzfxslzSedBVksJEg+/Va+FW009Jjb/QAiF66vpZpjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsHVV34ZP7y8nodRDbgiKw+SrIou6UN5I8FIhKNw2YHJbC8mmahAugVlq5iHEqlDd
	 pF7m5vfcPNR4lSPYU4aslnrbaClDfWSOvWfTvCfMYdk1q5bQ17VkCPucCthX/YlhzI
	 1V0vVVpKwoYyxVULwMKfUlI9ZgV7aStWqm+vbqa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 357/547] xfs: dont overrun incore inode when cleaning attr forks
Date: Wed,  4 Nov 2026 16:09:01 -0500
Message-ID: <20261104211048.427707627@linuxfoundation.org>
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

commit c28b4b48deac17749ed1ebe4289a4ba73541ddc6 upstream.

LOLLM noticed that xrep_dinode_check_afork doesn't check for a
di_forkoff value that is so large that the attr fork would begin after
the end of the inode space.  This causes afork_{ptr,size} to be
nonsense.  What we really ought to do here is zap the attr fork.

Cc: stable@vger.kernel.org # v6.8
Fixes: e744cef2060559 ("xfs: zap broken inode forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1243,6 +1243,8 @@ xrep_dinode_check_afork(
 	if (XFS_DFORK_BOFF(dip) == 0)
 		return dip->di_aformat != XFS_DINODE_FMT_EXTENTS ||
 		       xfs_dfork_attr_extents(dip) != 0;
+	if (XFS_DFORK_BOFF(dip) >= XFS_LITINO(sc->mp))
+		return true;
 
 	afork_size = XFS_DFORK_SIZE(dip, sc->mp, XFS_ATTR_FORK);
 	afork_ptr = XFS_DFORK_PTR(dip, XFS_ATTR_FORK);


