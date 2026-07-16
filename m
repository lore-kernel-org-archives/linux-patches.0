Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF4842F6FA;
	Thu, 16 Jul 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212135; cv=none; b=p5AIs3hMAYFjutLmzqU/McEUKUq2gJkQ3CpbjaSQjsUhqHSog88PCEzuAHdR3oMpU7ZLIi3ilNOqoNNtbTwM59OifrpEC4R2Qup37T/Rc0U2PaFIzQgf5tmOSaRij2cXxTVCmsKjy1WZpE0BMUX7jXNA7COvkuelwDICdh+XK84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212135; c=relaxed/simple;
	bh=ra18xau9TnqGXMWg5j9lfdb2AN3xT5HMD1gxQ/8qrzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWMkKn5Nxdl8CxYzxLpNQXQ1/ccBVXHsK5Jhr0SCWwM3+i5Ilq/62+8AMS8YNp+2GtNrwmAjWo6J/sreZogWm54TcCaXJfRZNkle8q0uQIa8LxlaK+Ny8DSPa9HY9clxs1jeH8x6Dp0ncPx1m7vte8BzuWORwaJmjywg69U96KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkoGdJtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkoGdJtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE971F000E9;
	Thu, 16 Jul 2026 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212133;
	bh=PqWPGXP294CnDnfMqWB9kC0Eb1stz2gXqbXwzh4fSq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkoGdJtF8q4rLnLzpoLR0m2wdEhMXQuDAKv4/TZJYqkXeEOepxl3gSKZgZOhZAQXx
	 r7Nkskglogxu8qud+p60vcpVLSgEZXSqpfKoyzuhxxqK5uKXXb7Qr/WnBi8RwJ90Zs
	 tOG20n5O1wILN9Tt7OLrm6A1Eqy24XMWTUzxcjNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 212/349] xfs: release dquot buffer after dqflush failure
Date: Thu, 16 Jul 2026 15:32:26 +0200
Message-ID: <20260716133038.105544801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -160,10 +160,9 @@ xfs_qm_dqpurge(
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


