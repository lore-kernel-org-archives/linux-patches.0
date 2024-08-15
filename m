Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF41A08DD;
	Thu, 15 Aug 2024 14:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730719; cv=none; b=l2Ht0rFIOOyXXPa6+Y/MDrORaFSgXxY0wchj+zqS2s6vr2yp7ogSh2CzD8PBwz8sq1Rehh7H2UiUV7ZYnU3ugtHdSOT+AnGi/HXwYhjwjFJAqip8VjZ3fsiuwZIcXijMX8mFD3NakEojMHBXc1/1YY9qas4Rym64J+AAsY/ecLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730719; c=relaxed/simple;
	bh=9cEtTATly220fqMeRG/NqlAkNYEuC1p1ODhJltaT1UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTuRmNINA/zU47gWFhNXR5k+fe0W83ioPmBH86xUI8dogyPtfxC1/5q+MlEwoj5xzp2xvywWk064FOJ6z95aqp+zMsusDvY+I/TeBqm6vEq1sPZa23M4ocWlc4Bz8cmq+qr86lxRfe3/ZgKEtSTFhq2K7hVLx/IE4NDCMSjotDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0i2mbOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0i2mbOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6828C32786;
	Thu, 15 Aug 2024 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730719;
	bh=9cEtTATly220fqMeRG/NqlAkNYEuC1p1ODhJltaT1UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0i2mbOtgTFvuEoLYg8uTKdB/d/xhK7ZXixjN3C+mcMuFwt66R2Gwr29dRPCXLT38
	 mnAz5E5Jmq1KvA3iJe2UBZ7Pa0M7TTHI8TEKSH5bcVoxLEa0xXv+0r35+tPhRWi9PD
	 lhfS7k4Wyqj4S8FmpU0zfFXs2GuWsd0QEQV6R6eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 03/38] mptcp: pm: dont try to create sf if alloc failed
Date: Thu, 15 Aug 2024 15:25:37 +0200
Message-ID: <20240815131833.084805074@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit cd7c957f936f8cb80d03e5152f4013aae65bd986 upstream.

It sounds better to avoid wasting cycles and / or put extreme memory
pressure on the system by trying to create new subflows if it was not
possible to add a new item in the announce list.

While at it, a warning is now printed if the entry was already in the
list as it should not happen with the in-kernel path-manager. With this
PM, mptcp_pm_alloc_anno_list() should only fail in case of memory
pressure.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-4-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -363,7 +363,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 	add_entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
 
 	if (add_entry) {
-		if (mptcp_pm_is_kernel(msk))
+		if (WARN_ON_ONCE(mptcp_pm_is_kernel(msk)))
 			return false;
 
 		sk_reset_timer(sk, &add_entry->add_timer,
@@ -567,8 +567,6 @@ static void mptcp_pm_create_subflow_or_s
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
-		local = select_signal_address(pernet, msk);
-
 		/* due to racing events on both ends we can reach here while
 		 * previous add address is still running: if we invoke now
 		 * mptcp_pm_announce_addr(), that will fail and the
@@ -579,11 +577,15 @@ static void mptcp_pm_create_subflow_or_s
 		if (msk->pm.addr_signal & BIT(MPTCP_ADD_ADDR_SIGNAL))
 			return;
 
+		local = select_signal_address(pernet, msk);
 		if (!local)
 			goto subflow;
 
+		/* If the alloc fails, we are on memory pressure, not worth
+		 * continuing, and trying to create subflows.
+		 */
 		if (!mptcp_pm_alloc_anno_list(msk, &local->addr))
-			goto subflow;
+			return;
 
 		__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 		msk->pm.add_addr_signaled++;


