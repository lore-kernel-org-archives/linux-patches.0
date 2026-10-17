Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCC277026;
	Sat, 17 Oct 2026 16:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256066; cv=none; b=pUUVbEJuzsda7DItWCVBt+j7Alqa9hC7LC1YueJLLCAvvWRCrdUoR6ws23s54CTNzjxT9ElJEOxC8DRSsgVLDop6fSl5nP/U60ZB7yIRy6zY7e+fku5S/EqOAcn7h1thwFw7BNZ5G9EN9exvatTULjMxLFlhr9Taq++fvZiGwEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256066; c=relaxed/simple;
	bh=+JX6pPXs5WyZ89LnMUc1QVGA0rSRO+9xzYFrrzbw8JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krKxgLpNpjygcvZ5mgrQCvGV6QqCGk7a1uIPa87/RFCdWjd/SoVBWfoDwpXnU1NBEecqDx6puy2VxVBokBWQREMCKV8uB1qwVfWBFJMS2rkEGPwqfqonsuouVC2gIiaVfTCfv9g2IdqdDYF9AmT/b/OaspwCzCo8S3l+nJzdayE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoNrSy3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoNrSy3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB08E1F000C4;
	Sat, 17 Oct 2026 16:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256065;
	bh=0L6Fh7Og/n8BEeKdU8fxLy4UrvilFkxUOZ42zgOZRSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoNrSy3U1lGmOpSjuazLBdfcUJXWF/yUNueUKKQb2JqgT0FfgKGQGDcU3F0ltgQhc
	 ukZQxmVTQu/y+CPqHg0lNhGlg4MLrXHa7U506MukPlg4/jetpzgiJLQM97Jgfphc64
	 bdfbKaXjcCY41j0fZ+iTdqHggRObrpUtBQjcDe5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0111/1674] mptcp: use sock_kmemdup for address entry
Date: Sat, 17 Oct 2026 17:39:43 +0200
Message-ID: <20261017160433.999483280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 52f83c0b5f857dbe24f66fc9a7f035523e9ffbc9 ]

Instead of using sock_kmalloc() to allocate an address
entry "e" and then immediately duplicate the input "entry"
to it, the newly added sock_kmemdup() helper can be used in
mptcp_userspace_pm_append_new_local_addr() to simplify the code.

More importantly, the code "*e = *entry;" that assigns "entry"
to "e" is not easy to implemented in BPF if we use the same code
to implement an append_new_local_addr() helper of a BFP path
manager. This patch avoids this type of memory assignment
operation.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/3e5a307aed213038a87e44ff93b5793229b16279.1740735165.git.tanggeliang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index bfcef17fe9dda..493a4511a5398 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -67,13 +67,12 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
-		e = sock_kmalloc(sk, sizeof(*e), GFP_ATOMIC);
+		e = sock_kmemdup(sk, entry, sizeof(*entry), GFP_ATOMIC);
 		if (!e) {
 			ret = -ENOMEM;
 			goto append_err;
 		}
 
-		*e = *entry;
 		if (!e->addr.id && needs_id)
 			e->addr.id = find_next_zero_bit(id_bitmap,
 							MPTCP_PM_MAX_ADDR_ID + 1,
-- 
2.53.0



