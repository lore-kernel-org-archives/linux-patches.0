Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0DE1C6F71;
	Tue, 27 Aug 2024 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771667; cv=none; b=ROEKnth65b+5thvevMSQsTmEkuWh5tWZLuVQMBNcJDv3B7zgijSKFxXwPtXlnQ5dp7jnkHp7AqOmWoms94R4ZG1p7ByoJHTFnIWdS7zAybdWejBqbxzYp6yebGFsIJBGfiSWnAWIhHGHfpphtqVPoYj/dOQpVyZT9cmfK0XiQ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771667; c=relaxed/simple;
	bh=UEV6iAq+oNtyUZzBj3+UEQBDukdcuWgloWXg5t9lvX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHXw9LPJftJdx0LYF3SDBAJGkTFZOeukxJCE0iOF3SlYfq1M8W69A2WpiL6/gaNzI8nnH0j2k2cViG5GEG/GlbtpRjC/jM04qSaueMa9iertb/9KnLCYMKT5dSBbF/+VnC9wOryUeEwVWanZjZmZrqP9HZqThpCzy4YsvRvn1ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AA2zUjWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AA2zUjWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E52C61064;
	Tue, 27 Aug 2024 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771666;
	bh=UEV6iAq+oNtyUZzBj3+UEQBDukdcuWgloWXg5t9lvX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AA2zUjWe0ba9tNunItEfvIpWs5AsqzEH+WuqnpS12uENRKnKNbV5xJ62KxvIjtUBN
	 aNFDF4HSTpxj5uiViJJU9xHvHCvmsDYq4WUX1Kp5kzyH+f5Fzxdl8tFBF87ii/QoaQ
	 eq8Ko+ZfOE7met5p7159+iOfY81PDNM5LbKK9Ea0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 257/273] mptcp: pm: re-using ID of unused flushed subflows
Date: Tue, 27 Aug 2024 16:39:41 +0200
Message-ID: <20240827143843.179603128@linuxfoundation.org>
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

commit ef34a6ea0cab1800f4b3c9c3c2cefd5091e03379 upstream.

If no subflows are attached to the 'subflow' endpoints that are being
flushed, the corresponding addr IDs will not be marked as available
again.

Mark all ID as being available when flushing all the 'subflow'
endpoints, and reset local_addr_used counter to cover these cases.

Note that mptcp_pm_remove_addrs_and_subflows() helper is only called for
flushing operations, not to remove a specific set of addresses and
subflows.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-5-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1623,8 +1623,15 @@ static void mptcp_pm_remove_addrs_and_su
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}
+
 	if (slist.nr)
 		mptcp_pm_remove_subflow(msk, &slist);
+
+	/* Reset counters: maybe some subflows have been removed before */
+	spin_lock_bh(&msk->pm.lock);
+	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
+	msk->pm.local_addr_used = 0;
+	spin_unlock_bh(&msk->pm.lock);
 }
 
 static void mptcp_nl_remove_addrs_list(struct net *net,


