Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828979;
	b=dJKXhnHSzt695uX7zEvK7fGPyrXRcxsA7Gsgkj4+3JnljOTbHCgghSTzvKyDa0AUebcV
	 6h7EMEfZq6bY/z40MCjBw41+4hklnLkBlk5070OGLESO/fU1vuCWA2yJFuEorktpGMesj
	 Pqiz7lmeIZAETOka7gXqLiDV0BnSUlBZ9AbNdp0VjXjrH3DZ9MjBgNSsQCZ7/5K3dCS0/
	 RQJ7JNSrGmYzvT1rBMM0yh9/2Qd6wKXmvhm/mwp4vFknxfBEzmHruq9OomRUG5hAwGFbI
	 1pWdFTOKDHploFtNkEwG6SQgpsORAa8OvGZ5nLEcEtx3y78uG2d2H1Bn+wRQ27HcDlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FtMcnAlaPau8Uicxzr5f18n56uj9anL9DFD7X6rlkFM=;
	b=4Gf9vnQkwPLn3cnhV7dwiQoN7eXwPLn3YmL1ty49C11j2E/uYhW6qo5yEwhgtn1n6M1c
	 nZlcVYSgyIdU6pG6rAKZIdazn/ReCki8z/bXHVXfK6Ax2FX3K+oDape5wkfmy+PWw7ivG
	 pSbxQClorm5pIHbRsZ7iLDiKilHCuF4OHRSsLP1FGN1GdwO19WsPEdWolUFIj1eGF8MN6
	 2BVEfNvHE3fiQSvdgebLUG5WDbE3VTyQdBIc8QUda/Qx17kpuQn/1MnugxsffcIUkN7zS
	 QVDZuxr4vPTnKyf0VFXevNx06HdskblLIk7aVpr6HB+IXHy7Xg0QCmnwIlZXYdmP5sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcTrTTuI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C03D6070754;
	Wed,  4 Nov 2026 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QcTrTTuI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D171C1F00919;
	Wed,  4 Nov 2026 21:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828979;
	bh=FtMcnAlaPau8Uicxzr5f18n56uj9anL9DFD7X6rlkFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcTrTTuIuV4mjx9qHC8PcGFJy1uR0heBwOmdzZkKsKu1/WrYBPDX7A3OOSeFEoHnP
	 akvkrFXXk3sL2DHL1kjeNezflKxCD30jH4udnEobrLWeiRadC23/9nsqO4Jk/Rai/w
	 dIKssidklIqtfMzGqPY+T9xY5124xkgDcza6Zqxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 366/547] xfs: fix data fork block count check in xrep_inode_blockcounts
Date: Wed,  4 Nov 2026 16:09:10 -0500
Message-ID: <20261104211048.692264443@linuxfoundation.org>
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

commit 147f9f8300cb284923e08bb8a7b32ba9681c45ed upstream.

LOLLM notices that for non-reflink realtime files, the @count output of
xchk_inode_count_blocks includes both the file blocks on the realtime
volume and the bmap btree blocks on the data volume.  Therefore, we must
compare this value to rblocks + dblocks to avoid unnecessary failure.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1724,7 +1724,7 @@ xrep_inode_blockcounts(
 		 */
 		;
 	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
-		if (count >= sc->mp->m_sb.sb_rblocks)
+		if (count >= sc->mp->m_sb.sb_rblocks + sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 	} else {
 		if (count >= sc->mp->m_sb.sb_dblocks)


