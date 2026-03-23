Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9ACC145;
	Mon, 23 Mar 2026 14:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274973; cv=none; b=dVGRHSu40ewCGPM6rwHBX+pk2HM6JzxCfxWgO82BCAUHNU6wrXsQI3qMeeT8QHUVp06ng/66MXJGxpWJLrFwJMPKBYCzeFvQVwuqYixyKUJhxa/W1sx4rYc8jStY+9kmeeHieBTToT1T71fEQwd71xELaXC/Y+futzC7P9DvQGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274973; c=relaxed/simple;
	bh=7Ky+ilP1e6ndnsHlqH2+FcFRAs/Ku9Bu5Y5673oAG9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzHPOuS2wSXEZqMtFDcBUxVay81FNYt5RHuEkRFX6Cywhv1aeeOUe1UTvparN6ns6y38647fVjw5JVONbhE9oq0niyosjwQ5qtDqNeD2Uq+vgyFKBsb1Bj63k2DlKO1w5RXl1quGavb6APE67pqSMqaMFKN+B3YKhx8mvUm4A1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNjVX0QM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNjVX0QM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449F1C4CEF7;
	Mon, 23 Mar 2026 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274973;
	bh=7Ky+ilP1e6ndnsHlqH2+FcFRAs/Ku9Bu5Y5673oAG9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNjVX0QM9ZLYiM3IW+5zQmb4Ua7AS5yrZZ/DmvuQKkoncOMveeE1W94uMkrNikAQs
	 c2QK/8L5NAOACZ7wafjoceaBeFo8FoJpxWfBbZfMcUSt4hjoXtfCbS9KGuxhPJp3aa
	 MMADnZeXfJH5HgYX0nRx5CMV3sNu57Q8jJbJ5Vxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/212] MPTCP: fix lock class name family in pm_nl_create_listen_socket
Date: Mon, 23 Mar 2026 14:46:40 +0100
Message-ID: <20260323134509.413545145@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6fd393f451bf4..52d15df12f588 100644
--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -824,7 +824,7 @@ static struct lock_class_key mptcp_keys[2];
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



