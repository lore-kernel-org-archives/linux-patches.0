Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8950F282F29;
	Mon, 17 Aug 2026 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979201; cv=none; b=QW8IF12o8segucKxI0aFxwEquxwO6slegxTDs6ih4iznHp6LluIa+U3GYhmXiSMMJroX34IgpWYSCXubxmpjcQteFSETTYkmWh6nfdtwwNUDwiK/AotaCYWPKOw6OQamW8eVt2a4CndqThLr27j+xY4mQeT689xFeacbpAgkUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979201; c=relaxed/simple;
	bh=v+ywl1dgpAUq5S07+BEpX8baGmN0xnErs1Dx6VK6nAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhJJszPbZGvpnbJvx0GYQ6gj99YW6QTl/nAs3qdI+9LeSoV6X/Q9f9YnVwIfGKMOipBMlE+h9KwZ6HaGXKTAWcCPurv7LUAPYg4EvXAqRwx8nvNf/p65TYOqOy0Ho+vmVlxFZ8KCAFFPNkmAqpCQ5EBpsOhcqnAOwQ/W8dne+3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPTY4xI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPTY4xI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F051F000E9;
	Mon, 17 Aug 2026 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979200;
	bh=Z7e45+lRMAnG40syTrR4rLFUqLnhAg4uqg/ckJiq2nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPTY4xI7PY+7Bftng0fYLO/KxvjkESnlj5NRk6s0m3g10EgA2jPd5dV0vrKxctRWU
	 O7ArqwYV8vD0ptpNvUQTzRLpDTfol+33v/acXgI90fg00e2LJ/RVvMG6S+WOY9kvJl
	 pajmg3SDtbDKoyeIsDOLqczIH5dhIoBA6jz9aE1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+85d0bec020d805014a3a@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/609] tipc: fix infinite loop in __tipc_nl_compat_dumpit
Date: Mon, 17 Aug 2026 15:27:18 +0200
Message-ID: <20260817132548.750514857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helen Koike <koike@igalia.com>

[ Upstream commit 22f8aa35964e8f2ab026578f45befc9605fd1b28 ]

cmd->dumpit callback can return a negative errno, causing an infinite
loop due to the while(len) condition. As the loop never terminates,
genl_mutex is never released, and other tasks waiting on it starve in D
state.

Check dumpit's return value, propagate it and jump to err_out on error.

Reported-by: syzbot+85d0bec020d805014a3a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=85d0bec020d805014a3a
Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
Signed-off-by: Helen Koike <koike@igalia.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260713204940.647668-1-koike@igalia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 9eb7cab6b2f60f..5a722a8fa36d1b 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -226,6 +226,10 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		int rem;
 
 		len = (*cmd->dumpit)(buf, &cb);
+		if (len < 0) {
+			err = len;
+			goto err_out;
+		}
 
 		nlmsg_for_each_msg(nlmsg, nlmsg_hdr(buf), len, rem) {
 			err = nlmsg_parse_deprecated(nlmsg, GENL_HDRLEN,
-- 
2.53.0



