Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206A367B6D;
	Thu, 20 Aug 2026 15:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239136; cv=none; b=q0HUQ0zNZbN57eHGZFaYQcncorsQTEDSTA6dwZn0o6Y0mHMNRWXUZeLAQBOrOpAUW6R85g8GvkPCl0HKjTKkhc3uXjRO06whnmIdwHaTzkK1H2OusWBAVvpINTbdIE/gS16J0o4HncVk2UNzzt6SnYM0DY1SIjgkvtLd6fOFatI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239136; c=relaxed/simple;
	bh=5ZK6RH4istyeBPnmgFoxlIFX78pG9DSLfak0qpunQFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8umMrz369YXEu6QA3NsWfwjJjdu6RcyhSkV8k4Pf7fmDarVMdlM/kcKQXL3ytfekpOM9PxvXvBTwP9idB5Sv8Txwn6imMhvj4GhPaQmK7HVz+4aisRPe3qWj/gmrlg4NYj4RWt3eYDJLw+TYFB400aSdlfHgFgtcI/8xjNefaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBMe87gW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBMe87gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAF21F000E9;
	Thu, 20 Aug 2026 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239135;
	bh=hMZ3fdWGrfn2JwCm0sPkQGKgJ8yFZm/oQbo1YyM2WOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MBMe87gWwFYVJvd6tJMLrqIaL3t+mA+ZB97i5yQUBjC/Jy0zEWPFbHrVjV3c5yZmz
	 Sld927kDruJsZotJ/UZ06kfSSPyxqTtIWRloS9U/ITIo5vdWAznxHzP8bxsavFKBN3
	 T+zT78kTNe+z9yFKCj/ZDHC7QRFsEbn94GDMID+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 123/217] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
Date: Thu, 20 Aug 2026 16:54:51 +0200
Message-ID: <20260820145241.433226109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


