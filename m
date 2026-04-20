Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC932E696;
	Mon, 20 Apr 2026 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699817; cv=none; b=PZhZzQ5LhFShNmMFcw2WttwDMwU229mISKIJC1H17AmUi8dtff0jRp7/onvgpDAz8fCx9IqrmOkLHAGerR1zxhdpcE5EZaDXwJ9lEJZuBdfuHBVIhO8MYddnFVEPlvj/wGJLwfVhIYFjqDrPiYV1EhDwV775XJVQwRwKKO08UHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699817; c=relaxed/simple;
	bh=vTR3OZkIeUD0ZxJEq/o9y7577APdV+4kyrlaRmxbIfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id9C8fO7OCV5a6WZOH7Y9Nz2v0t58s4RKALSkyJi8km38DmQZmnkLzSIDI9016vd3Q49WLzcX/vQfxxgzyyJxWLMI8ADaQEGW/3L1H0dCU2WfoKwidSYJMHVGEWnkh5khMDcNs4jnYBQn7ZygFImgWFq6rp/yB5y2fm6kuyMAzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4rji99f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4rji99f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D74C19425;
	Mon, 20 Apr 2026 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699816;
	bh=vTR3OZkIeUD0ZxJEq/o9y7577APdV+4kyrlaRmxbIfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4rji99fHozg46JTtPt8m6PvqsAO1FPp1ZoRV+sPfkEpiHJK2pXzng6xJCBsS1S4l
	 6zbSpLxgR1QNdYdrStOOXgjsm2fhcwpudGf8hlsguxnfluWYq+eFxtGgvbVgywK2YI
	 GhK087ZcvdSXvTp6HQt5ULGFQH92tTuNrNXIvZVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 01/76] nfc: llcp: add missing return after LLCP_CLOSED checks
Date: Mon, 20 Apr 2026 17:41:12 +0200
Message-ID: <20260420153910.868092406@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxi Qian <qjx1298677004@gmail.com>

commit 2b5dd4632966c39da6ba74dbc8689b309065e82c upstream.

In nfc_llcp_recv_hdlc() and nfc_llcp_recv_disc(), when the socket
state is LLCP_CLOSED, the code correctly calls release_sock() and
nfc_llcp_sock_put() but fails to return. Execution falls through to
the remainder of the function, which calls release_sock() and
nfc_llcp_sock_put() again. This results in a double release_sock()
and a refcount underflow via double nfc_llcp_sock_put(), leading to
a use-after-free.

Add the missing return statements after the LLCP_CLOSED branches
in both functions to prevent the fall-through.

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260408081006.3723-1-qjx1298677004@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1091,6 +1091,7 @@ static void nfc_llcp_recv_hdlc(struct nf
 	if (sk->sk_state == LLCP_CLOSED) {
 		release_sock(sk);
 		nfc_llcp_sock_put(llcp_sock);
+		return;
 	}
 
 	/* Pass the payload upstream */
@@ -1182,6 +1183,7 @@ static void nfc_llcp_recv_disc(struct nf
 	if (sk->sk_state == LLCP_CLOSED) {
 		release_sock(sk);
 		nfc_llcp_sock_put(llcp_sock);
+		return;
 	}
 
 	if (sk->sk_state == LLCP_CONNECTED) {


