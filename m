Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF093B0AE2;
	Mon, 23 Mar 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274320; cv=none; b=mwfKNhgljOt7deALWEWLGiCMxcWsE/GKYY8Okr6znnGUTq16j0Q32UB7kmvlNNda8ALENsxF3c+xJw93GsEXnk+XGvw9sBb6pEojryRVUxQxht6hz7mkHy+PPVIH3TIv32pG8+0ly0sO2R8Nq5n9j//wKhI/EdOB1h+O5wOwyFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274320; c=relaxed/simple;
	bh=CZrXkwPq0tHTpjl4cK0QUgN4ke9pv4XgUPVNPRC5UMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4BaqQ9TpUxGclX+5Wj58MdHbso8NtuqEEcdIbUnoF2uEIWZ/nZbY1xKEmz5F0Te79HWjicJ98VR/Urd49EZiIKmPWtd6o7P+2aGnJhVsML75UHgTob5CX8WF05omMOBPQNTqtbhcTRYDsvFhf4R/2f7jpWg05C855ELt6Z55kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbiwqyG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbiwqyG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9535EC2BCB1;
	Mon, 23 Mar 2026 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274320;
	bh=CZrXkwPq0tHTpjl4cK0QUgN4ke9pv4XgUPVNPRC5UMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbiwqyG8mvnM1LJeIyzVUlNzNVbvq90lkl1+Z6ZhhvsxNg9pVk7mP8AFYOcCvQnqN
	 zlyRObPHmO6UvxAn+NAHAXZquWZdex+r3VWObiov52pgiMPXEJ9f8zm01GtiaunQaK
	 furPahqtvPke6YopNp3aCtVVSAK5+Qoxc3OLtBt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 181/220] MPTCP: fix lock class name family in pm_nl_create_listen_socket
Date: Mon, 23 Mar 2026 14:45:58 +0100
Message-ID: <20260323134510.293776309@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Xiasong <lixiasong1@huawei.com>

[ Upstream commit 7ab4a7c5d969642782b8a5b608da0dd02aa9f229 ]

In mptcp_pm_nl_create_listen_socket(), use entry->addr.family
instead of sk->sk_family for lock class setup. The 'sk' parameter
is a netlink socket, not the MPTCP subflow socket being created.

Fixes: cee4034a3db1 ("mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()")
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260319112159.3118874-1-lixiasong1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_kernel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_kernel.c b/net/mptcp/pm_kernel.c
index 0ef43993e15ad..17eb50276e778 100644
--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -838,7 +838,7 @@ static struct lock_class_key mptcp_keys[2];
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
-	bool is_ipv6 = sk->sk_family == AF_INET6;
+	bool is_ipv6 = entry->addr.family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct sock *newsk, *ssk;
-- 
2.51.0



