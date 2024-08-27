Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227CA1C6F57;
	Tue, 27 Aug 2024 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771665; cv=none; b=ErL4r6NDlHkYlNEgLzSu1HXKgPbOh7/6Nd5omizkwCwPInUMvC0mQByRxyYT0rDduONt2R/fWSUO8oZFa7gaKI5MPnk6fxx5UbRZK4UHyuJe4Y7VhacFIxwQC5XnxMgiVgV3Lfh56g2IRK2bL+Er1hknci81XbkdKr5qp6GolOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771665; c=relaxed/simple;
	bh=sGcqRDSPzhj6ux9RGOCMlg9kQJW0EA4GWuP2bj9UUGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZrpPDakWgvmG+8EK6XUeI1qaBGMKlIoWGxEmm600byUXkpiqOzXsNiqlj79IvZxz1HlNsg/jvfDyCRCY9gHH24G9lD/spN/7gy5lZtP4Dl7/NmR5l+KxdwjGo38vfKDHiQgFD4UOIyOz1xmPbHQJvcd25xLsoAefpeOdKbELy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtLoCkWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtLoCkWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4081C61064;
	Tue, 27 Aug 2024 15:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771663;
	bh=sGcqRDSPzhj6ux9RGOCMlg9kQJW0EA4GWuP2bj9UUGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtLoCkWCBHsGLqqoLm8fnPhZFlnx7tXRvLx1ExjnNYwuWkWE2JHq7OaU5XW195tQx
	 mpESnL/T65kBI6IUa3LzODF4kYxq7xfURJmAMfgu8zxyqhxeYx3Px0FWbrbxLM6NjA
	 HpykDsxU84zjZAL/Mu58xLDQyVNWb0fKGjxX6GcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 256/273] mptcp: pm: re-using ID of unused removed subflows
Date: Tue, 27 Aug 2024 16:39:40 +0200
Message-ID: <20240827143843.142246747@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1469,8 +1469,17 @@ static int mptcp_nl_remove_subflow_and_s
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


