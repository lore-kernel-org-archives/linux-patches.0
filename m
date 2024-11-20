Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F0E1BDA87;
	Wed, 20 Nov 2024 13:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107690; cv=none; b=hb2WsRa92yFIxAVnf5pZ0apg0QrVFAqwv1MOFX/eR5EziHOQo/lh0vWfbu3JqMJ1WuHXuhvPH54XPvVR/oyt3Dwf8k09F7+4rC+EGoc23UzigpvE3cgVTugvPEVDccMNHMZe/kOOq/h7gOCoXpcaSnIN/x+60pkGEPS7/GM/DUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107690; c=relaxed/simple;
	bh=utZjvb1gmv5a9BMosHchIZYvr8gIKOw0V1ZvoUNj9gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWSqiws9EIynQWle//SkJVvP2YZXy4der4Sm3akZIXahlQIHGfQp1auoDzl8UDn++wyGQt6Zf0fEX9LTUNvs1/BOzlGMliHrC9QRou0hrwdYduWS+QflP93I4CaLGzVo4lkI6i42eyTc9rQzl/Tt+AiPZWzzsdQF/GfuGl8r0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5H53QZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5H53QZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CADC4CECD;
	Wed, 20 Nov 2024 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107690;
	bh=utZjvb1gmv5a9BMosHchIZYvr8gIKOw0V1ZvoUNj9gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5H53QZ/SSSd2aQRFJef/q4rsbmlLu+Lg30D0q9Vy5355MmI2oI6xH316W3mn7EAQ
	 kvWOwMFLsjKX3wfozKuoYhNau8dU5vdcsVobzwkaXXx0pnDWok4SavUscvHfwzdc9t
	 IYIBQLBpHBNlDNx/fihnFAk8hEVxPATpQGyWW+II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 49/73] mptcp: update local address flags when setting it
Date: Wed, 20 Nov 2024 13:58:35 +0100
Message-ID: <20241120125810.790648705@linuxfoundation.org>
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
@@ -565,6 +565,7 @@ int mptcp_userspace_pm_set_flags(struct
 				 struct mptcp_pm_addr_entry *loc,
 				 struct mptcp_pm_addr_entry *rem, u8 bkup)
 {
+	struct mptcp_pm_addr_entry *entry;
 	struct mptcp_sock *msk;
 	int ret = -EINVAL;
 	struct sock *sk;
@@ -585,6 +586,17 @@ int mptcp_userspace_pm_set_flags(struct
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


