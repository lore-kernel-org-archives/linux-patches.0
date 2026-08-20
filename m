Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9347F2CB;
	Thu, 20 Aug 2026 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247090; cv=none; b=tGS4Lnl6UEWuyiPun9beLZd0Stego0+oQ5HqTdx6AaGzK1oSyA50e+rAO7mK1f1RER3GVwgGoTdgF4DAeSl8lUx7qW6S/Fj8waz72U8a4PPA2gCXSPCKPX4PsuRmF52bgScEu9k+qq4GSaDtd6JmgxCzY4MxyuV2PmpMVOz3+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247090; c=relaxed/simple;
	bh=0brPsjAlgtdmbIkZbQYqp0+WVrEvptijMjkC3TVuIyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwQsF9nvoMFQFd/TXJZxS8GayRTcUxO2UVw5MpV+lYM+dxk9Rxj3psnvgcDGB67zyzgVomWQKCpOcdSorKGo6vr2Clyht4BaIqg+HCQZkKzI1gDZooSVJWH/TRf4YLrGlW5DTuawpbKqhPm30Ni3OVYfokrOijr9bFJhdZ9OESE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l714Y4Ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l714Y4Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BF91F000E9;
	Thu, 20 Aug 2026 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247088;
	bh=nHcZX611QiMHZyF7Tqo1ty4xzwJ6KtOvPoMC2Gh0GU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l714Y4KisMeUJfRXaVS6g/qwBL5aBnSZKtXXamnHL6d2zBhyXpbR+6tJKF9i5Yqt+
	 qK7npAXJodfVes9C+xHqNxf6sonZDYryxj4R7p3fF1/sTRNhM0xVjZTtJquWtVHo7+
	 I6zr+WwoKNNvxNyOBMgsesaGEjLhUhHj2rKR5Zk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 106/220] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
Date: Thu, 20 Aug 2026 16:54:56 +0200
Message-ID: <20260820145226.666354291@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -173,6 +173,7 @@ out_release_inode:
 		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
+		sc->tempip = NULL;
 	}
 out_release_dquots:
 	xfs_qm_dqrele(udqp);


