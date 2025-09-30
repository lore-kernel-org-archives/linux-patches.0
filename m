Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B04303CBF;
	Tue, 30 Sep 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245204; cv=none; b=aDGA3Ho77RkrgErY0+zNMbkHHOfj69TEguTe/qOCbHFVk6S3X7XlD5j+xCM0wnUiuWVrdxt/9LJmB7q8anjF4Ju+r2GXDLLT044Fb02eTNu5/Wu4sUGDI7atwrNkMUznjRCPapooxyncGswfjrKyR6kd59ahWC6XrBhGitHq704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245204; c=relaxed/simple;
	bh=bm112PxAtJWwql4UtHSIp3fH232/EbX68LMP/nh5iFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNR19WMDTd5aaupsEbFpHI2GsRCkbvjviuFH/vZGKytDwiqF0/TMlIK1uU0Xt/HCk295IkScD+MUx565jmDMASTXCN5ary9YgwmqL7vOG+G2tKu/l5O0EN+WHYuqfZqQZhcLFFlmBk4/GaNc2ildLpofZfUCArDIbatTiqsFimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLxgzeFP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLxgzeFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01523C4CEF0;
	Tue, 30 Sep 2025 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245204;
	bh=bm112PxAtJWwql4UtHSIp3fH232/EbX68LMP/nh5iFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLxgzeFPClKqsRbyU9wvE0RDGV2vmZ5bc1KvXF/I+uwJd1i9yR1NGyRkZMq2DHlU5
	 9qaBL35bK8zGzUPf2lyWCL8s8smGYs+TGrcdKPx8wgK/Mp4gz0G4OI6ZJqyuptYrDP
	 UZY1B9j5AUhO9rvVMGbq+N9cPi/nQka34DWDVkPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 098/151] mptcp: set remote_deny_join_id0 on SYN recv
Date: Tue, 30 Sep 2025 16:47:08 +0200
Message-ID: <20250930143831.499539153@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 96939cec994070aa5df852c10fad5fc303a97ea3 upstream.

When a SYN containing the 'C' flag (deny join id0) was received, this
piece of information was not propagated to the path-manager.

Even if this flag is mainly set on the server side, a client can also
tell the server it cannot try to establish new subflows to the client's
initial IP address and port. The server's PM should then record such
info when received, and before sending events about the new connection.

Fixes: df377be38725 ("mptcp: add deny_join_id0 in mptcp_options_received")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-1-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in subflow.c, because of differences in the context, e.g.
  introduced by commit 3a236aef280e ("mptcp: refactor passive socket
  initialization"), which is not in this version. The same lines --
  using 'mptcp_sk(new_msk)' instead of 'owner' -- can still be added
  approximately at the same place, before calling
  mptcp_pm_new_connection(). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -758,6 +758,9 @@ create_child:
 			 */
 			WRITE_ONCE(mptcp_sk(new_msk)->first, child);
 
+			if (mp_opt.deny_join_id0)
+				WRITE_ONCE(mptcp_sk(new_msk)->pm.remote_deny_join_id0, true);
+
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */


