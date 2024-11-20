Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B83519F41C;
	Wed, 20 Nov 2024 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107616; cv=none; b=NxWP0LUQ5Mq3JZphlF8iuAXWBHgrtEPm6yPCiLAbDmezc3LDAr7HU8W3e0OPusFcqaUrbbdC5YmKNkLKhPKXQQNTsNjibc4vnzevOqdmpCjVCJPiEzdutO2AYY6X5FxSoSl6hL0Anj76qOWg8esPlLj8mkhqqcqRPaGpgTvUKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107616; c=relaxed/simple;
	bh=fZ5HJFSTKxPhG7wUJxa9oucxN1UYVj3AT6c7z/IZbMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gz7ZmmPQRv6O9H1tjuIgtE3C0ahCOtIaV3khNiXW0Et0Wq2U7MlVSC/rn3ASDpPiSZCJLGXZSKpeVGQnb+/nCYXr5pWR5GpekODM7KMftGf8qld1oO2TNoBa7YS29/cwPYO4r5Q7r4W7Ug+/E/7M3jjW+AMsrJ+opQ5VuCCNkCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KQKW4At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KQKW4At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51283C4CECD;
	Wed, 20 Nov 2024 13:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107616;
	bh=fZ5HJFSTKxPhG7wUJxa9oucxN1UYVj3AT6c7z/IZbMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KQKW4AtRG5sT5UCK0AfnaeL2P0WddD9Mv+J1VRea3YsauAN+tEHpQ5YHK0rGl8WP
	 jfMoswg+/9MAa8Mx/rJit3whwi4PDl5UbOKAKz9qncfWCf+UpL+n8SZuD6VXkI3gaN
	 gusSBh4/aZ4crkQmpsUrWKrDXDaUMZJza57vvtkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 68/82] mptcp: update local address flags when setting it
Date: Wed, 20 Nov 2024 13:57:18 +0100
Message-ID: <20241120125631.143031954@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit e0266319413d5d687ba7b6df7ca99e4b9724a4f2 upstream.

Just like in-kernel pm, when userspace pm does set_flags, it needs to send
out MP_PRIO signal, and also modify the flags of the corresponding address
entry in the local address list. This patch implements the missing logic.

Traverse all address entries on userspace_pm_local_addr_list to find the
local address entry, if bkup is true, set the flags of this entry with
FLAG_BACKUP, otherwise, clear FLAG_BACKUP.

Fixes: 892f396c8e68 ("mptcp: netlink: issue MP_PRIO signals from userspace PMs")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241112-net-mptcp-misc-6-12-pm-v1-1-b835580cefa8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_userspace.c, because commit 6a42477fe449 ("mptcp:
  update set_flags interfaces"), is not in this version, and causes too
  many conflicts when backporting it. The same code can still be added
  at the same place, before sending the ACK. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -563,6 +563,7 @@ int mptcp_userspace_pm_set_flags(struct
 				 struct mptcp_pm_addr_entry *loc,
 				 struct mptcp_pm_addr_entry *rem, u8 bkup)
 {
+	struct mptcp_pm_addr_entry *entry;
 	struct mptcp_sock *msk;
 	int ret = -EINVAL;
 	struct sock *sk;
@@ -583,6 +584,17 @@ int mptcp_userspace_pm_set_flags(struct
 	    rem->addr.family == AF_UNSPEC)
 		goto set_flags_err;
 
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (mptcp_addresses_equal(&entry->addr, &loc->addr, false)) {
+			if (bkup)
+				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+			else
+				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+		}
+	}
+	spin_unlock_bh(&msk->pm.lock);
+
 	lock_sock(sk);
 	ret = mptcp_pm_nl_mp_prio_send_ack(msk, &loc->addr, &rem->addr, bkup);
 	release_sock(sk);


