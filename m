Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60EE1A072D;
	Tue, 27 Aug 2024 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771687; cv=none; b=XNtMAPwD9CYbCzg9GWv0IJSIEQURMAJb/yjlV+Z/+edtnsil/8kfFlJ66YGXvYV2KKwUT82Pd8qbVEGJyEWlxmy1iPOorSSZyKLMhIqbI0ryWdz3Lfwr43RASUTaBOGVEd6DuPMDLvTeBmoIcd/bPALZrVlOGVd5mU1TanNXelo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771687; c=relaxed/simple;
	bh=O1fd0EcFmG7917xB5crjGjGErFw6kMCoZwGS0Qh0cXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xlo3naoBJKVXc4TTXFR1SDF4wuLmjlf3zFOkjlNXCzzlKYwfAPeMSU4qafusTCNQLsp39CCPgEwPbP5xEraW6g3T8dNmFTvqBqdgolez3m5NQIx9+arDN2tL5zwaT3L771NztL5zhc5jfhxuh2TwM5volwVIVbVRBlDnvsWWsxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nt52RJUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nt52RJUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3BBC61064;
	Tue, 27 Aug 2024 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771686;
	bh=O1fd0EcFmG7917xB5crjGjGErFw6kMCoZwGS0Qh0cXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nt52RJUCwpar4v3DsMoRN19bu/wU0wyQh3IsamH48h9WGHZxMQ/0Mk1DBF2DJ5L36
	 lhP1OUv5q2nfJ86ZakfWFV5VquPevcvZxWvast2Umkb6cfYL7JgapAt1N4rHziaV+A
	 Har0xCiihWeee3vKQUrRXtbu1WSBLMTKyAgiJbU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 262/273] mptcp: pm: only in-kernel cannot have entries with ID 0
Date: Tue, 27 Aug 2024 16:39:46 +0200
Message-ID: <20240827143843.368541435@linuxfoundation.org>
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
@@ -434,9 +434,6 @@ int mptcp_pm_get_flags_and_ifindex_by_id
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
@@ -1395,6 +1395,10 @@ int mptcp_pm_nl_get_flags_and_ifindex_by
 	struct sock *sk = (struct sock *)msk;
 	struct net *net = sock_net(sk);
 
+	/* No entries with ID 0 */
+	if (id == 0)
+		return 0;
+
 	rcu_read_lock();
 	entry = __lookup_addr_by_id(pm_nl_get_pernet(net), id);
 	if (entry) {


