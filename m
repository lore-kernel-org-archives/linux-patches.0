Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD8133D4E2;
	Thu, 28 May 2026 20:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999859; cv=none; b=HNKxvx93B3k0NmHiA06F8dYx/hXc+m+qrtp45+4iwxqFl1yPbhOTBxWsonwRXvk4EVGfioHbhbR1NQ0+Hsah9gzsJil4kk4LHPN0JLFZX5wQ2/kB8IIMbSE8CvTbw3lNbRoVXtGRhI+8/B9IFufMkSW+krHL2Oo9p+wgW91Vg0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999859; c=relaxed/simple;
	bh=COZkj6x+xFRYXg8c0kd/jUUUR6cQYBt4wD04KcWA5F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqo+/amUozkeft1iWD2QRUhTF0Qruy1Dz5KfzfHnDAbAw7V6VKa4UVsDtXZqcUjRfgOplMtju6NaAwTawfSHG8Pgq3fQ8oYUD5Z/eVQOhkJ0q0Oe/Aam22kMVOdbUP5KjHTCJWeuXjOGmvkpk3lQCs1zKqoBmxEaE9LNhKWg8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbsCW6pw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbsCW6pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC79D1F00A3E;
	Thu, 28 May 2026 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999858;
	bh=8K30amJfoY+p1MEn9JRxyPBZgVJMBc+t4PMVr7j9LsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbsCW6pwLgnKTtixMERHRrrqgk+8H0rLeqnLaxmu72fFGFBWvm4xpeHIVPzJJ2156
	 R/hRmroF86ny4QDuK2eRMeUC1p7yjpP4Kxd/5h9FgZsIrOmgkSj7JHDzS1sLNfAr0z
	 KrZF/vWaBTGSKt77O3Z1XBpyQ0QJ2a8IEaNOz07c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/377] NFSD: Fix infinite loop in layout state revocation
Date: Thu, 28 May 2026 21:47:34 +0200
Message-ID: <20260528194644.654520298@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4f8ef58c10bfe5f86a643c7c8331b37e69e3dae1 ]

find_one_sb_stid() skips stids whose sc_status is non-zero, but the
SC_TYPE_LAYOUT case in nfsd4_revoke_states() never sets sc_status
before calling nfsd4_close_layout(). The retry loop therefore finds
the same layout stid on every iteration, hanging the revoker
indefinitely.

Fixes: 1e33e1414bec ("nfsd: allow layout state to be admin-revoked.")
Reported-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index cb8096e94f518..a9e95df2fdb68 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1848,6 +1848,13 @@ void nfsd4_revoke_states(struct nfsd_net *nn, struct super_block *sb)
 					break;
 				case SC_TYPE_LAYOUT:
 					ls = layoutstateid(stid);
+					spin_lock(&clp->cl_lock);
+					if (stid->sc_status == 0) {
+						stid->sc_status |=
+							SC_STATUS_ADMIN_REVOKED;
+						atomic_inc(&clp->cl_admin_revoked);
+					}
+					spin_unlock(&clp->cl_lock);
 					nfsd4_close_layout(ls);
 					break;
 				}
-- 
2.53.0



