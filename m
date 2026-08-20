Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E2D37A83C;
	Thu, 20 Aug 2026 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243864; cv=none; b=R7CKUQRf++flUUHUA3xUhap+RG3Vr3hGf99PVPjpWDCH6/veqAPLl0RHzGzSEFEuozTtZ7+QP+ulBxk79OD4W2xpSKgaNIxg/s54k/riP7PGK9jkfbyHsKTazpwvyQNHwOUl0zlodzR0GJA3TMSUgjcKng8A+SzZycBm9J1RPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243864; c=relaxed/simple;
	bh=fNw/cPVjYoe1uBTVWerUomSF0rB8u0xbaDIw5B2B6Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBnqHPssx9fK7pC+qu2HnrCZn2DwR4NsdTKewpduXJYDwAYPqz7/UV4YwWPWF619LkA+lIx96QIfhiTcqMy/uUn6Yrmlfjh5E90789kre/x5bL3mf/TsOiBzKX3t+mfVGhUed4QyLH5Z0FeyDx4xLWlODdRT6fFgHUZR8bMMgu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EX0k+MnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EX0k+MnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D438A1F000E9;
	Thu, 20 Aug 2026 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243863;
	bh=WJORZX+WdMlvYwZUyLRVVkJCk+AuzVVbSlJWJQWdEFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX0k+MnM9d8uJ+mAkel7CguC7RKUsxIlzDpzLWssRmqKaVNFpCBJZjvYhv8QBNfc9
	 TZ+hJhImvU+4H433+Xrt9KYpLjpuoFg/cg/viOKPuWJlac2esYol/z1zpVkyg8mjve
	 pGzNBvz/c7ztY600dDb5PdXHipkGU7TMPj61gAw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/272] mptcp: fix subflow accounting on close
Date: Thu, 20 Aug 2026 16:56:27 +0200
Message-ID: <20260820145237.573145276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 95d686517884a403412b000361cee2b08b2ed1e6 ]

If the PM closes a fully established MPJ subflow or the subflow
creation errors out in it's early stage the subflows counter is
not bumped accordingly.

This change adds the missing accounting, additionally taking care
of updating accordingly the 'accept_subflow' flag.

Fixes: a88c9e496937 ("mptcp: do not block subflows creation on errors")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f3ca0ee2cc30 ("mptcp: decrement subflows counter on failed passive join")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |   14 ++++++++++++++
 net/mptcp/subflow.c  |   12 +++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -839,6 +839,20 @@ unsigned int mptcp_pm_get_add_addr_accep
 unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_local_addr_max(const struct mptcp_sock *msk);
 
+/* called under PM lock */
+static inline void __mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	if (--msk->pm.subflows < mptcp_pm_get_subflows_max(msk))
+		WRITE_ONCE(msk->pm.accept_subflow, true);
+}
+
+static inline void mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	spin_lock_bh(&msk->pm.lock);
+	__mptcp_pm_close_subflow(msk);
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 static inline bool mptcp_pm_add_addr_c_flag_case(struct mptcp_sock *msk)
 {
 	return READ_ONCE(msk->pm.remote_deny_join_id0) &&
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1434,20 +1434,20 @@ int __mptcp_subflow_connect(struct sock
 	struct sockaddr_storage addr;
 	int remote_id = remote->id;
 	int local_id = loc->id;
+	int err = -ENOTCONN;
 	struct socket *sf;
 	struct sock *ssk;
 	u32 remote_token;
 	int addrlen;
 	int ifindex;
 	u8 flags;
-	int err;
 
 	if (!mptcp_is_fully_established(sk))
-		return -ENOTCONN;
+		goto err_out;
 
 	err = mptcp_subflow_create_socket(sk, &sf);
 	if (err)
-		return err;
+		goto err_out;
 
 	ssk = sf->sk;
 	subflow = mptcp_subflow_ctx(ssk);
@@ -1510,6 +1510,12 @@ failed_unlink:
 failed:
 	subflow->disposable = 1;
 	sock_release(sf);
+
+err_out:
+	/* we account subflows before the creation, and this failures will not
+	 * be caught by sk_state_change()
+	 */
+	mptcp_pm_close_subflow(msk);
 	return err;
 }
 


