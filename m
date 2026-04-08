Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973F22641FC;
	Wed,  8 Apr 2026 18:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674141; cv=none; b=bRQ8RkeKjEaFIiMs9UNMNQkmkba0s4ax6R8+DX1hCOH7yt4LVM3ucXk3jmCLO7Nhl2GquaZAZmNyARGibcECb9t604BKS2nmV9cCQtnLbufvHYdW4DbVbdqka15PWytInen1dIDmEOQx2qZJXMeFgNJ12nv39FoP9CrgHv33Tec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674141; c=relaxed/simple;
	bh=QxXaAwfYPPv7A+QAti+zb5mkN3YRX1frSHz7uB5BzhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgxkqqR9QrS4r7t+EO9c4KQynYgMzN/xEHAQhYDOsGRudWWUsHm5kK0+f8u0XGA8I7HjcCWJOKD0vmgOghqAOl7ymDNN/ME8um+4Us9xPxhJrklg2/4YpZV+9uHltkup1L8R/6Jdw3j1yUwWv4/B8NPDk4Tl54FNAYIEqzKsBso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJUuA+RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJUuA+RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032D0C2BC9E;
	Wed,  8 Apr 2026 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674141;
	bh=QxXaAwfYPPv7A+QAti+zb5mkN3YRX1frSHz7uB5BzhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJUuA+RTRCrrcrFDHmda8loiiWyTJc3WTWOuTjf3f3HlCXeZL5JCowLcfWSD1cy5D
	 rzGwhBO5R1JJA3HvDtNwH8/3raqtLDfztJe2JT3HTYPeU0S0VxxyEFSXFTPFt6PPHq
	 51dYrdzeec/5gbkwchhxwQiPrJtSuIgYqZLLHT+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 225/242] MPTCP: fix lock class name family in pm_nl_create_listen_socket
Date: Wed,  8 Apr 2026 20:04:25 +0200
Message-ID: <20260408175935.515881692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Xiasong <lixiasong1@huawei.com>

commit 7ab4a7c5d969642782b8a5b608da0dd02aa9f229 upstream.

In mptcp_pm_nl_create_listen_socket(), use entry->addr.family
instead of sk->sk_family for lock class setup. The 'sk' parameter
is a netlink socket, not the MPTCP subflow socket being created.

Fixes: cee4034a3db1 ("mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()")
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260319112159.3118874-1-lixiasong1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in pm_kernel.c, because commit 8617e85e04bd ("mptcp: pm:
  split in-kernel PM specific code") is not in this version, and moves
  code from pm_netlink.c to pm_kernel.c. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1186,7 +1186,7 @@ static struct lock_class_key mptcp_keys[
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
-	bool is_ipv6 = sk->sk_family == AF_INET6;
+	bool is_ipv6 = entry->addr.family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct sock *newsk, *ssk;


