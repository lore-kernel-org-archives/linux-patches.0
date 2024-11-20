Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A801AA1DC;
	Wed, 20 Nov 2024 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107691; cv=none; b=XhPANeKF/Lc8N17sgS1WFaRVREaX+v8op9jWRVNEiIe4wOYixjCExVq5b8Az0Tnt8C/W0lNKN3VxJIeUcml626mhVzniexqvsfahg8c1ay0w4piPhbdyX5h7/6znYIPqJaeiQ3cCZ8cAPPkhDdbquBrIroTeEPyQzYcivg1ULMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107691; c=relaxed/simple;
	bh=4mODUVgCTt3sp2CnGYhO8f83bPXuUVgJvz3p41lrs0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLSTkAoIAKXSECgQ6X8X74laeh1Biy0uyPQbw8ggaqT/yPT//b0Wzy4BMWhdTavyrh3hrvysEP3jXEMKX8gXXGgMcdTVKnlADvGHo5ttc+YW9yDjm5DkfoO4SjeQH8LzwSemxGss/q1BTPhdmucj9tpISGjoO2Nv1MXM2pff1JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hy1op0ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hy1op0ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87768C4CECD;
	Wed, 20 Nov 2024 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107691;
	bh=4mODUVgCTt3sp2CnGYhO8f83bPXuUVgJvz3p41lrs0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hy1op0akjUbx2C478NWtdzHArZ5xqyYu+68H1sCs7ZAo9bJZ3/7VHtr0jEXqEYagj
	 cUwxQj2m3/3L5tUOp9ZpvKBZ0j6AhoJApc/stUeZl+P7rGhI3g5TCcJee1uo5sBJsu
	 WX8vlHeON4bSxm4MYNDZPC1zstSqu+Pv1CPyNRwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 50/73] mptcp: hold pm lock when deleting entry
Date: Wed, 20 Nov 2024 13:58:36 +0100
Message-ID: <20241120125810.814943163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit f642c5c4d528d11bd78b6c6f84f541cd3c0bea86 upstream.

When traversing userspace_pm_local_addr_list and deleting an entry from
it in mptcp_pm_nl_remove_doit(), msk->pm.lock should be held.

This patch holds this lock before mptcp_userspace_pm_lookup_addr_by_id()
and releases it after list_move() in mptcp_pm_nl_remove_doit().

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241112-net-mptcp-misc-6-12-pm-v1-2-b835580cefa8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -326,14 +326,17 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 
 	lock_sock(sk);
 
+	spin_lock_bh(&msk->pm.lock);
 	match = mptcp_userspace_pm_lookup_addr_by_id(msk, id_val);
 	if (!match) {
 		GENL_SET_ERR_MSG(info, "address with specified id not found");
+		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 		goto remove_err;
 	}
 
 	list_move(&match->list, &free_list);
+	spin_unlock_bh(&msk->pm.lock);
 
 	mptcp_pm_remove_addrs(msk, &free_list);
 


