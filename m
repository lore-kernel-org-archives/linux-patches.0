Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6971B28FF;
	Thu, 13 Jun 2024 12:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282094; cv=none; b=NMMYGddmXzNj/Kd2r4Gr+jiDLFW5o/vyyYWDV/+5Lzym6iOYQI7rO1U7Yj7nUFAq5tE8E9qtlwP1pdcJTJGD5/Lv7vae3bImPiLpOtBpfH4Nw7PH6L9ikX4v3bxNLw1Nk/QameRXRW2A26yqvB4NDbPFwQLTMnvyEwSTkXKx9Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282094; c=relaxed/simple;
	bh=j0ncoBzso884t9Cp+ixDbatGC/uqkYXqAcYQu6Dmejk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azqd17rvS4ksoRVLFuWjy7ncM7qsDylWUi+LaV7apocqxnky6Utl/nJ0T/PNmNR6uTsTr0WEhYxrgD6CrBJteu/Tm4CYI+NBrON7RJU1giuzRuxHUjb6lJLqbtvNKhFvD3itbq1hfuk6orukHVDqsdKnY5FmT8i2HNtC3dxIldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOEVNUY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOEVNUY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60F2C2BBFC;
	Thu, 13 Jun 2024 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282094;
	bh=j0ncoBzso884t9Cp+ixDbatGC/uqkYXqAcYQu6Dmejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOEVNUY8x/OnM0AXvNOrRYrAvh5W756PQI0nXKPGGLwUSrNbt16royGVazbq5ABhf
	 yNGjmc6sI/nCEOsHwc+7UUwFez8HaI+/gthSNBrkCX7cyKeqk8oVrl680IRXwnZ+GI
	 9q+ZcrvUBR86OpwUbebNku1nz3U3HvLmvBbkIbG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/402] sunrpc: removed redundant procp check
Date: Thu, 13 Jun 2024 13:31:58 +0200
Message-ID: <20240613113308.414355750@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit a576f36971ab4097b6aa76433532aa1fb5ee2d3b ]

since vs_proc pointer is dereferenced before getting it's address there's
no need to check for NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8e5b67731d08 ("SUNRPC: Add a callback to initialise server requests")
Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 9177b243a949d..8d5897ed2816f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1238,8 +1238,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argzero);
-- 
2.43.0



