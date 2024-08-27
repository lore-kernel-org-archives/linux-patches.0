Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FB1DDC1;
	Tue, 27 Aug 2024 14:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770735; cv=none; b=p7AxKz4fo933RRhqxjeGdbPwZPCBFHmfFnLlJqz5BR22kFz+YnYXU+8AVK6ShB19Gz1kzIT+FsNeBMB8Iws+rkpuwgbdHKBV4Is0gYH1Ee7N5BJMZfVxJMxXNUoj1JzlodFRHtrCtvhBK79xZHk3g1S+ndjgzmqnuVLUNkkB7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770735; c=relaxed/simple;
	bh=ajwQheiqwf64DL0lTS1Xq454k6eq24uKu7ayDmJkv/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWGlN5cg1tPdpI9Ikpyt4I2qEip6B6ZbKCGuQi+qWJzj/dBCc1f5xHo0Yjy5vrUYbywoBDc1MfcvtzxUZKn6rVahsOvdOrn0jSZKDf2g8V2izlbV1UFa6RG5SHLCkjm/94JKSKP7PijZmRF4pSQpgxmjzHn2uHD4rILqLteuHBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WsiS7kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WsiS7kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28346C4AF1B;
	Tue, 27 Aug 2024 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770735;
	bh=ajwQheiqwf64DL0lTS1Xq454k6eq24uKu7ayDmJkv/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WsiS7kTAy7gqnL1Dg1P8fuGIwHH/yZwwuSinWIkPdX4Ajq69PXw6xuIiNvNNX/ve
	 +LqSqHN60wBru95wVdOyWP5ygUAP78wkOLUwRawJBCjVgZC8FqEiQUijR10FtaOV/Y
	 wjGcOGntFUSFlGfpRWoRmb/r4Dllpwo9szHbChDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 317/341] mptcp: pm: only in-kernel cannot have entries with ID 0
Date: Tue, 27 Aug 2024 16:39:08 +0200
Message-ID: <20240827143855.458737138@linuxfoundation.org>
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

commit ca6e55a703ca2894611bb5c5bca8bfd2290fd91e upstream.

The ID 0 is specific per MPTCP connections. The per netns entries cannot
have this special ID 0 then.

But that's different for the userspace PM where the entries are per
connection, they can then use this special ID 0.

Fixes: f40be0db0b76 ("mptcp: unify pm get_flags_and_ifindex_by_id")
Cc: stable@vger.kernel.org
Acked-by: Geliang Tang <geliang@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-11-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c         |    3 ---
 net/mptcp/pm_netlink.c |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -435,9 +435,6 @@ int mptcp_pm_get_flags_and_ifindex_by_id
 	*flags = 0;
 	*ifindex = 0;
 
-	if (!id)
-		return 0;
-
 	if (mptcp_pm_is_userspace(msk))
 		return mptcp_userspace_pm_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
 	return mptcp_pm_nl_get_flags_and_ifindex_by_id(msk, id, flags, ifindex);
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1426,6 +1426,10 @@ int mptcp_pm_nl_get_flags_and_ifindex_by
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 
+	/* No entries with ID 0 */
+	if (id == 0)
+		return 0;
+
 	rcu_read_lock();
 	entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
 	if (entry) {


