Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121A4334C24;
	Fri,  9 Jan 2026 12:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961128; cv=none; b=U1UJ4oB8b/ZibKbRFIEDadghz5GBfO/pb5RQSlCYJyUORwOUHKEQdfOzTqSAf0gDs1jWgbOgK7SQbZDRmTWOQajCM+FlJO01HO7pPySlMRHyPaDomYU9G6CG/6BbSsdo5RK4nq+kb+Dea2vrFumorRfgs4wMTP4gBa8BaHNE3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961128; c=relaxed/simple;
	bh=wTo7SaQJqadzU1S8YWiITtpJFN3h1XhLEvmtd4ZypBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQ4c2CU6n6Ui7fVadpEMQil+37PNdG1DspLlwW49+FKnffmpoDA0WmpsMoCkSZTiDbioGaRUo9i6Hdk1Tz+MYMXXgx0Gc0NzvDSZAx7YZLcfV5O2QQw43z4IW8Q3WugpMSLHEmOOQspx6waibL/9oA/UFAOVMnwY2BUR17s/3C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uAx1b1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uAx1b1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94548C16AAE;
	Fri,  9 Jan 2026 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961128;
	bh=wTo7SaQJqadzU1S8YWiITtpJFN3h1XhLEvmtd4ZypBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uAx1b1iWBf+E3NaB7pz5nWArxJe22CJjNeWhisys+Hy+gH4Ie6Vl/c6593EsUNgf
	 E+QJFdgDZMHlaMsE22SGrda1sDPUOYavJiHsMXZ8jyWTtC4kZHCpWw+qGz43rDcXLb
	 3atN4IA1H1uImsyPZ8qhnk7X550lKqfY+cTpmph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 637/737] gfs2: fix freeze error handling
Date: Fri,  9 Jan 2026 12:42:56 +0100
Message-ID: <20260109112157.971588767@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -776,9 +776,7 @@ static int gfs2_freeze_super(struct supe
 		if (!error)
 			break;  /* success */
 
-		error = gfs2_do_thaw(sdp);
-		if (error)
-			goto out;
+		(void)gfs2_do_thaw(sdp);
 
 		if (error == -EBUSY)
 			fs_err(sdp, "waiting for recovery before freeze\n");


