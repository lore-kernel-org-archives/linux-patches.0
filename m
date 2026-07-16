Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30411429827;
	Thu, 16 Jul 2026 13:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209704; cv=none; b=WvGSiFQj7v7JwOS4AxyOOnGsnauePC3+PVMpjYRXDJKOguDnsmCSF4yrtYk0YB5hNA5Oq5Ph378D9m/0GnH7aCUAvbmdkJcTGukmx1EvIut5iNNx3oeE+wzfpydu/3EemP3pOXLsGMRTPmyW1+iph8SwLVGQQjAxy63L95CRIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209704; c=relaxed/simple;
	bh=Okmjc+ynlik/jsDVoPk8QH7P3DmK59MQtq8JFLkaoyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IV9JN0Sa1nLT0gf8HY/i598/YuSA/CfYUPq8bZNijsZOi0w0g98T/0rD5P1XptruIcv2NOXvAE3DMaokjlkwTKDantAhpC3yGy3lgbdN6qkGA7Q70Oknmr+wP3Hr4/M0DuSM0yKVOL6rPMgWARrgqVPRDUniQbQ/j9iWf7MoPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQ/8n7Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQ/8n7Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1261F00AC4;
	Thu, 16 Jul 2026 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209694;
	bh=emxHuIOipVWpy+6AzFWfHygviu2kb+GTAnPpDZVlbA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQ/8n7FnIkPnkE1kWC3MKTUXDC+2x8HcgbKRg2gC802bnSP099sQJe18LqdJzO063
	 ZWVkcQofwL5NfnUJZNoFs3CLSNtqnV9pTgLAaY6Ug2FRpmSg40rqJIM/UI8XQkOdRZ
	 IqbX5+4+qatUVlBaze49JLevfl6V45/44qvPXD9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 283/518] xfs: release dquot buffer after dqflush failure
Date: Thu, 16 Jul 2026 15:29:11 +0200
Message-ID: <20260716133054.006441871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -166,10 +166,9 @@ xfs_qm_dqpurge(
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


