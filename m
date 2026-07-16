Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CF52FDC53;
	Thu, 16 Jul 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211042; cv=none; b=H7gFd0pyiQ0AM5DvOmXMVS+j9Kg8UoF+kQv6YwTl8N1zlokyLNrHkKlLkwbrdpKSD5T8re9d7eJ+XuqgacIZwNIU8PHV0IC/tMO+JEuobHamjN645rnfetl0iULVa4pY3gEkerdprHmXQ2e3RSDIlqwrN7qUOPdiYRicdUAXzEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211042; c=relaxed/simple;
	bh=sBTTx9Av/t67bEtN4LpPcbQf01IMHK8vMSoKOOgEars=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5FdygT1Xj/rr6ODCagQ0uJeqqiQdMHgCflW7cwkM0vx0Qlb27XDnnjFon5AI9pDWZ6bjg+13QhfPTcjSJehizWjkeAaN6R82TKCZpj3r4YLbonWkYMzviffdQYITspO/uPWqy2HqHjtPg7zolt3laIaoI66zhPy6QMiTYnwaOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FkRKgUYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FkRKgUYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5FD1F000E9;
	Thu, 16 Jul 2026 14:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211041;
	bh=cPkGe/QN42+Z2GJZowjhS2LN6gzmLIOG0XMSF95EcbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkRKgUYZRdjv0cCZ0EnCEIIwZY7kbZ1k9UHUbSv0wtAouBJg6P6OtxMkBvfa/6dly
	 uWPPlyr9ygbs4nKSB9DyGwYZkcuRHdwC/R3p4Yt1Va28K86mAySAuMOlLyDdxZZkd/
	 raS5HwmyDoxOehj6SywMsIfU10tPU4V/32cG8XWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 275/480] xfs: release dquot buffer after dqflush failure
Date: Thu, 16 Jul 2026 15:30:22 +0200
Message-ID: <20260716133050.774125469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Yingjie Gao <gaoyingjie@uniontech.com>

commit 0c1b3a823a22af623d55f225fe2ac7e8b9052821 upstream.

xfs_qm_dqpurge() gets a locked buffer from xfs_dquot_use_attached_buf().
If xfs_qm_dqflush() fails, the error path skips xfs_buf_relse() and then
calls xfs_dquot_detach_buf(), which tries to lock the same buffer again.

Release the buffer after xfs_qm_dqflush() returns so the error path drops
the caller hold and unlocks the buffer before the dquot is detached,
matching the other dqflush callers.

Fixes: a40fe30868ba ("xfs: separate dquot buffer reads from xfs_dqflush")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -163,10 +163,9 @@ xfs_qm_dqpurge(
 		 * does it on success.
 		 */
 		error = xfs_qm_dqflush(dqp, bp);
-		if (!error) {
+		if (!error)
 			error = xfs_bwrite(bp);
-			xfs_buf_relse(bp);
-		}
+		xfs_buf_relse(bp);
 		xfs_dqflock(dqp);
 	}
 	xfs_dquot_detach_buf(dqp);


