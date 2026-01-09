Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E096F35BDC3;
	Fri,  9 Jan 2026 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962944; cv=none; b=h25jj8EkNStk4L88ijCmqsL61Y6WzHf/0MZiKCF3KdSxSRYxi3HJ9Vi+CcOtPKqdIXgqldwoowhH70v8mkSiEfHFsjDiTdeJcibmuU7cGR1Oaq6LIxyHDfQVrI1GJoC1aWoImwxuU5/NX3CEkozREgJ1ZLjUxdVhyr5ywssVCdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962944; c=relaxed/simple;
	bh=TZ6feuEtM4r0xkaqzwUGFIOhpwTQN466Xjlt8LlftiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU88lWXV3WmpB3liGsOFaH9ZX8kRtFdgBJpE4Xh9uo2GcXx4/CWPN2XK7+s2d0CADB4rpHjJ+doIV+tevZWRwmyHd+mVy8eSQZrM7MHSsYzf16BNXi4VrxQvy6YxVM9nwTM3aOe1TZvk81G1EvlvDcpRN82kPhU7Hz3/u0yw0gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqkMNVYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqkMNVYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E59EC4CEF1;
	Fri,  9 Jan 2026 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962943;
	bh=TZ6feuEtM4r0xkaqzwUGFIOhpwTQN466Xjlt8LlftiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqkMNVYsgqeoM1tS8JDuN2eWlxqRYmAZ2keJBjF+f4IsWzfCxdubrYgVea+mH+NoH
	 Tbrisvhqynt2WG7GXk7k0EjnPuzRKEtCXmg7Cd4zxg1bFWc7tt3p+t+LEsLI4UBWia
	 Q/tbtpg+OuyHfSDT58WMc6eHiP42T8pEocAkJtNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 542/634] gfs2: fix freeze error handling
Date: Fri,  9 Jan 2026 12:43:40 +0100
Message-ID: <20260109112137.981035974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 4cfc7d5a4a01d2133b278cdbb1371fba1b419174 ]

After commit b77b4a4815a9 ("gfs2: Rework freeze / thaw logic"),
the freeze error handling is broken because gfs2_do_thaw()
overwrites the 'error' variable, causing incorrect processing
of the original freeze error.

Fix this by calling gfs2_do_thaw() when gfs2_lock_fs_check_clean()
fails but ignoring its return value to preserve the original
freeze error for proper reporting.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b77b4a4815a9 ("gfs2: Rework freeze / thaw logic")
Cc: stable@vger.kernel.org # v6.5+
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[ gfs2_do_thaw() only takes one param ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -771,9 +771,7 @@ static int gfs2_freeze_super(struct supe
 		if (!error)
 			break;  /* success */
 
-		error = gfs2_do_thaw(sdp);
-		if (error)
-			goto out;
+		(void)gfs2_do_thaw(sdp);
 
 		if (error == -EBUSY)
 			fs_err(sdp, "waiting for recovery before freeze\n");


