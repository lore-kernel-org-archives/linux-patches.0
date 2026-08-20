Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A207A337107;
	Thu, 20 Aug 2026 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238537; cv=none; b=V1qmn/XAt+UShw0KmE/gpQq/HLhJkaY8zuiBauB3bEPwzvecuvoOKxwF/cgDkXmyZmxdUBPMGsx0+8KZEPqrz1W6I5YBvtXzN4d+DSt0LelbHLgBM9C5SUEACNpve7mVroq3nSU5pl22HG0VhJiVb/ffex9poJdlqZ/GKl1rtTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238537; c=relaxed/simple;
	bh=2Qh4NsHZR5P674z+/fnqlL4KDEedkM/Hnav73KRAg8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzY4v6DoOFa/RxjS9meGPG6uF/LzAypStZPsTR8IXN/iFEo+UdOO/BEoxpFyXy//AuPI+hs2/X8+JW4BOlbbnmCOBB8szLVMGtPiSeee6EsLu5CL6A1MUilsF9uHAuLpZnshw2iDOQWiRl32e+z5IV6WjVYSUDTTrZUTaawmm3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMTEWdBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMTEWdBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65A81F000E9;
	Thu, 20 Aug 2026 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238536;
	bh=aYEqaYmEDB4w0U14JV1+1jgiTqsTCSwvIX5HSgQ8O+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMTEWdBkn7Xm6BUn3s1omZKFpM9DWyuA7sLaOlLtibA5HCcniTzE5NKUhsDBG2s7Z
	 1MNcrXCrpzr+Eu3e3GvlWKn/VbjIr8Ag0maN0K/SG6hCfG3gHUC2DSKhRe/fgr7974
	 4+k7oRr/rPFfTj+SW1qggjhc1Em+P7c+qKRkrLuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 145/228] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
Date: Thu, 20 Aug 2026 16:54:47 +0200
Message-ID: <20260820145249.016598619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 0c88e10d12de9ca7cbed1467bb1b52310101bff8 upstream.

LOLLM noticed a potential UAF if the tempfile creation code fails after
it set sc->tempip.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 84c14ee39dd388 ("xfs: create temporary files and directories for online repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/tempfile.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -174,6 +174,7 @@ out_release_inode:
 		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
+		sc->tempip = NULL;
 	}
 out_release_dquots:
 	xfs_qm_dqrele(udqp);


