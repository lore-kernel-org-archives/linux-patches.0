Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033CB246762;
	Fri, 21 Nov 2025 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731693; cv=none; b=XVJ9PQIikfn89FAsnkeCsEVpozHj/IE5l/45aYaBNe/gdAYODgVf9w5Z4Da8qxk/BJXA+PjrKDcdSlA+YyjxtK6H+I/YlCyUCaOXjjDuVTS9HiAce5BdURNXeo+Xpr3B9sNvHvYvFWx6egEng0hT1sxd8qtSeBxt9+lICvpkcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731693; c=relaxed/simple;
	bh=IBkD4e6EMaJ97t1sLnk4GIOBE1w4pu4hjXZFGL1ESgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INzEWhMTunhN+8zVXOFISv3gTenxqAjht6riT3I1MUZ0xpMdAaU9MVplTd9mCGsdm/rzmkCPfu7LSDrX/MTLGzIDMLNc6hTdFe5in8QvAuU4DB1zhGI02DY3oDuibTaY00UFRC0Z7Zk1/nuOWDOSDEleqHVdBrS+cbYPdXwY5pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3+7/X6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3+7/X6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E53C4CEF1;
	Fri, 21 Nov 2025 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731690;
	bh=IBkD4e6EMaJ97t1sLnk4GIOBE1w4pu4hjXZFGL1ESgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3+7/X6AGvKt8ZZxsnbcX/oZH1NqK/lh6i93oNYnrEL4mQLxAJ5Id8nbSvIya/um9
	 9KnwImkpibhifwhAtZYUDHDRvaDLMl02cEX3V/8aEDFTrgvG/zrEnGvhPZPlTUOjBg
	 fZjdBYqWnR9aJFAcrgvvptFNd3QqbHq/yqdGRHwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/185] net/handshake: Fix memory leak in tls_handshake_accept()
Date: Fri, 21 Nov 2025 14:11:13 +0100
Message-ID: <20251121130145.541523526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 3072f00bba764082fa41b3c3a2a7b013335353d2 ]

In tls_handshake_accept(), a netlink message is allocated using
genlmsg_new(). In the error handling path, genlmsg_cancel() is called
to cancel the message construction, but the message itself is not freed.
This leads to a memory leak.

Fix this by calling nlmsg_free() in the error path after genlmsg_cancel()
to release the allocated memory.

Fixes: 2fd5532044a89 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20251106144511.3859535-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/tlshd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index d6f52839827ea..822507b87447c 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -253,6 +253,7 @@ static int tls_handshake_accept(struct handshake_req *req,
 
 out_cancel:
 	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
 out:
 	return ret;
 }
-- 
2.51.0



