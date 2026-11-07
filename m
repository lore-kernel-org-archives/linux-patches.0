Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061693;
	b=3354uM8fSkn3cpXY9TBL6MKWfPEi3i29IAUI3loeGuOlA4msK+odFiqTv0PuNrN0J2wI
	 qARh6GHMnnulMOWF28Nzc8aKG8L8H/tMmAELWqbzVE/1BhCJR++5ufmh9FcHGLFrDi6te
	 WQ2EAHBNaLnApOEgOJufwm/mi7EUAQx/eANhiHlmUb/F/6/wTeKuTyHJRCsDhWRHOarKL
	 4PAmKnv6qqokQEmS7RAZxtDOtzHZ3W7uxQ6Mv8EtcHUqMrorexipM6QaY9csd+F8C311s
	 HwEXuKPLPyzNPlNhfAkZzVDC4DQsajkPQ1VBmtLCSM/3twHenvzeHeZZm0ZgvsvXWNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E1lxzS38NlKKYEMC6Vnqa3eVaieSjecMRUJQvtmlQnQ=;
	b=JZPiAHGgFzU2FblHLF3vr6EN4fVe8qIJyKBcXOCIr8rmvp0nymnT/QdDAk2R9Wn8ogLh
	 ZTkSDi/E1w+DKKeAvr4exT49bt19hjw1euelZO6jt5d8wdSYJ00p2hMJxTvrP2AE+SSsJ
	 AuZK4DDIuVWl3VrDL+akfLoqou9nNaRdYheJqmAGKbEtcUfGmh6wIFGCkrZJBdiQFElVv
	 qZ5/z20b8V0Wcf901S5YWCsD2ZQarZYPfZgx4M7CXnpBFUxJQKnJNa/1Lv/QJDPoT0RRj
	 UV5EwqvcqkATY5FQYeTfTsKP0XDnpOEXvM7FaSrnuOpDmsGB/ddSFSz400JPYNSM/ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XbyOPJhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14078606A326;
	Sat,  7 Nov 2026 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XbyOPJhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A4C1F0089F;
	Sat,  7 Nov 2026 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061692;
	bh=E1lxzS38NlKKYEMC6Vnqa3eVaieSjecMRUJQvtmlQnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbyOPJhNhscseMowH9dZVWV679FBNL5E5aTET7FOx7bK4DcUVGUetbyXfYcJ+xs4v
	 pFHhS9nfPZnNze50zkOwNe+6viwcHd+6WptUHilx/3w9k3A6XcjGWFxJuPmuFmTLHz
	 LW+loTuVYdaNdS5KsTn2fJaR/2YNkqwtg/TSTYLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0741/1536] xfs: fix data fork block count check in xrep_inode_blockcounts
Date: Sat,  7 Nov 2026 08:45:57 -0500
Message-ID: <20261107135018.336661878@linuxfoundation.org>
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
@@ -1528,7 +1528,7 @@ xrep_inode_blockcounts(
 		 */
 		;
 	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
-		if (count >= sc->mp->m_sb.sb_rblocks)
+		if (count >= sc->mp->m_sb.sb_rblocks + sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 	} else {
 		if (count >= sc->mp->m_sb.sb_dblocks)


