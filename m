Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F321AA793;
	Wed, 20 Nov 2024 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107533; cv=none; b=j+vNGc+L8fQhgDbIEIlvTbnvYT9SWlPQsCWKpum6Zfw+lXgbKVkxtYLiyVBhcXegZuMi2QaM3BNc915cxXxCJgrtxjhzDudbodyk2LxuGdmMnyDtnH4ICQY84hwJfxSQFBQy273fpS3G9aaqX7EFtF15s9ZjLh+ExWOzHcFMqJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107533; c=relaxed/simple;
	bh=RqyhxQNGxs5JKI9m/fNrCHdAiGn00kv7XNtcsp+m/Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BboLbjT810yUyljdZbVy9DokFaDcmx7YXVMCHgSeCNBPNldyQJXdU5VKMHiBdEm3vQHbrPoITK7+9X5MU4WpuoHY+6i3qcTzUyJu4JTA0TUxR/ngqfD2D2shvkoyv6cWa4EB1pmOLPQAoGO5UHVwboHwCMgBNaYyFxo0bPdpA5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zg4FSLYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zg4FSLYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6370C4CECD;
	Wed, 20 Nov 2024 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107532;
	bh=RqyhxQNGxs5JKI9m/fNrCHdAiGn00kv7XNtcsp+m/Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zg4FSLYmUrASqxyUv+oAqTRcthAbrX1lllAngDscnE70g34c05SEB9PRocWDwo7z0
	 4yj4u8wXjwDc4qo0y1efhl7Y4bEBNmqWimilU/CqSfFUYPrsjJrFSYbTrPSgPqTJLs
	 h9mTDiePUkH+7IgGA2kVdfXsI5j9IqBIOW9mSxDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 065/107] mptcp: update local address flags when setting it
Date: Wed, 20 Nov 2024 13:56:40 +0100
Message-ID: <20241120125631.142893484@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -574,6 +574,7 @@ int mptcp_userspace_pm_set_flags(struct
 	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
 	struct net *net = sock_net(skb->sk);
+	struct mptcp_pm_addr_entry *entry;
 	struct mptcp_sock *msk;
 	int ret = -EINVAL;
 	struct sock *sk;
@@ -615,6 +616,17 @@ int mptcp_userspace_pm_set_flags(struct
 	if (loc.flags & MPTCP_PM_ADDR_FLAG_BACKUP)
 		bkup = 1;
 
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (mptcp_addresses_equal(&entry->addr, &loc.addr, false)) {
+			if (bkup)
+				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+			else
+				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
+		}
+	}
+	spin_unlock_bh(&msk->pm.lock);
+
 	lock_sock(sk);
 	ret = mptcp_pm_nl_mp_prio_send_ack(msk, &loc.addr, &rem.addr, bkup);
 	release_sock(sk);


