Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB8B1D172D;
	Tue, 27 Aug 2024 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772752; cv=none; b=VYkKAa5GQrXWjG2q4dbqJ9xun5nEJ2jgofqIQf0RsV5Pb+gZsOx0i6JWTup5rM8T2rkztq1MDQg9ZPipoRZtMq6qx6s6CwgXKH9y/dg+RjEYbkU00ND7PSS7t9LyjcLW4JE1mO7+o+SADwfNFexIbnV0YyXFI9nTtvIb1/7WbRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772752; c=relaxed/simple;
	bh=9CgJaaozRZ13kfMliEyyXJnMjb+ofMixjFH6Y3WpJYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnGFlHrtRpzkH6HmFg8mAusPbgCgtVnZQc/dEnlEeadscD7V+3IPZqWnOw8q/kqHI3ZU6nry6Mzht5etK1Q66dFTrfHoYHvwuJimDcgx2FMqa6RkmKmesEVMHT3aeHuqfhqBX7Hu8H2Tb+qI81YG6V8Y0UHJWiqeQ2L+12m3Jb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2N9MhLkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N9MhLkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A44C61043;
	Tue, 27 Aug 2024 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772752;
	bh=9CgJaaozRZ13kfMliEyyXJnMjb+ofMixjFH6Y3WpJYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2N9MhLkB1iZ8V5wAwVGk8CPehGK83iy9Zefg/x1OrPQUfM1ADeDSFD3b4gxb6h7UR
	 lDCfzuOEt9xgiFwWcXeytlgqVfEEtKjnewUrc4spfJ36FxvS2PEk8WoWo/6FDjsuVg
	 CXmEGcFgnD9nxpLLWMqO77J/vIJtVH/72xn3lDUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 277/321] mptcp: pm: re-using ID of unused removed subflows
Date: Tue, 27 Aug 2024 16:39:45 +0200
Message-ID: <20240827143848.795163153@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit edd8b5d868a4d459f3065493001e293901af758d upstream.

If no subflow is attached to the 'subflow' endpoint that is being
removed, the addr ID will not be marked as available again.

Mark the linked ID as available when removing the 'subflow' endpoint if
no subflow is attached to it.

While at it, the local_addr_used counter is decremented if the ID was
marked as being used to reflect the reality, but also to allow adding
new endpoints after that.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-3-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1512,8 +1512,17 @@ static int mptcp_nl_remove_subflow_and_s
 		remove_subflow = lookup_subflow_by_saddr(&msk->conn_list, addr);
 		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow &&
 					  !(entry->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT));
-		if (remove_subflow)
+
+		if (remove_subflow) {
 			mptcp_pm_remove_subflow(msk, &list);
+		} else if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
+			/* If the subflow has been used, but now closed */
+			spin_lock_bh(&msk->pm.lock);
+			if (!__test_and_set_bit(entry->addr.id, msk->pm.id_avail_bitmap))
+				msk->pm.local_addr_used--;
+			spin_unlock_bh(&msk->pm.lock);
+		}
+
 		release_sock(sk);
 
 next:


