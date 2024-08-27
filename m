Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40E11BC097;
	Tue, 27 Aug 2024 14:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770712; cv=none; b=J5pAUC5P1uPwazGlZFUBEY/Fp2aSnMdnq/RO680vG6nPFV1nsEz+/AlaGK2Zx9om5+nIRsQyQQnlwGzuXvcFnahCDs5CnPwksO7sCBU5SJm47ig3ZlHFJFwvJ2zD7S70I6wwfJKWV81mbaHRgkixb3cu7kWbc5C8y5+eG9JgdcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770712; c=relaxed/simple;
	bh=O4MU7uFW9Dsdq1ZNZ2jThDH1w+l1EgJhE6uC+xlqObM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSvcks6vSD4+PvG272uu+P4RHt1T/gP65pgZKVJ7pdWf47CDX0a6YAb6/ZDQBunAaxpCsF0ZzvnEGs/9NX8dnXfv7/TFYWpdyF+xud1zUZKxqaQENNRtl6byYmEU6gMJ2/JTAkvCewTYNxrI8LuCbvMKMR1pa6mHm8OqhH3sY+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6YZWIDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6YZWIDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196AAC61044;
	Tue, 27 Aug 2024 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770712;
	bh=O4MU7uFW9Dsdq1ZNZ2jThDH1w+l1EgJhE6uC+xlqObM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6YZWIDBaXVAK3YBT5BbK3oclstj7aMIHTzV3QslJvPm0fBJHsNt/wDu/ZDS0Zu/r
	 brVdXC2a13VIO4jRrnyMcVqyv6yKDk+IkAgMql3uhbbRkiNk1nuUNnyQKLpMtknCsy
	 pDFdVsQ3kcFjnHgKWX15L2fNp7caxSkFIKdRxQbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 311/341] mptcp: pm: re-using ID of unused removed subflows
Date: Tue, 27 Aug 2024 16:39:02 +0200
Message-ID: <20240827143855.221161197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1500,8 +1500,17 @@ static int mptcp_nl_remove_subflow_and_s
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


