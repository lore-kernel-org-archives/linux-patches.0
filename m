Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2FD2153CB;
	Mon,  2 Jun 2025 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875025; cv=none; b=EUr3IOGT0IvXlg4V3zB3yCjRhT1AbMUPdPKgsHLZxEiPjLpN/hOJUlvIRxHiBe1VWZaNPgXVu+4SYH3gEeSDeHirLMCsmR6QqdKcrl4Y9PGpkoL9ZPhYK8R/cbsM4tbQvYzMvqywtXK3RTLSCATe3K+KShAx3OBmRRDZO9y19c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875025; c=relaxed/simple;
	bh=1SBbtmrBH8CrOX6IyOsUcXB1g/t24wt/g7XI+r9ij9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VV3eECv+AVXLWYsjK5bKG9D5ElQ28KtAXyzelGZomX15koBxDhSlA4RKl8cyWMtrlBjIr6HaNxukUTFXPNY/dQ8NtJJyBbsGreK5Piww2Bw8nz9yZ7GW/Y1wbKKfcVLd1qwukC3m+uFbGLDgNAJ/yGtUGtdj5foA/WgDn0nZJVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbdGzXut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbdGzXut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023C4C4CEEB;
	Mon,  2 Jun 2025 14:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875025;
	bh=1SBbtmrBH8CrOX6IyOsUcXB1g/t24wt/g7XI+r9ij9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbdGzXutyWsI8sjMziPLaF1Y9okDLdkaROcAKCEQl7Y4qzpwfs6AUrBy6MDqX8JUE
	 ObFo9sANmzOGu4CyQodDJqHrgKeFellcLQQUVL+g+p7ji4dnPw+eppbU/6DrA3w1DO
	 noNQGedVWjdwCxiWrDcapK+5VSGwu1EWf0pVixlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 179/204] llc: fix data loss when reading from a socket in llc_ui_recvmsg()
Date: Mon,  2 Jun 2025 15:48:32 +0200
Message-ID: <20250602134302.683035413@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

commit 239af1970bcb039a1551d2c438d113df0010c149 upstream.

For SOCK_STREAM sockets, if user buffer size (len) is less
than skb size (skb->len), the remaining data from skb
will be lost after calling kfree_skb().

To fix this, move the statement for partial reading
above skb deletion.

Found by InfoTeCS on behalf of Linux Verification Center (linuxtesting.org)

Fixes: 30a584d944fb ("[LLX]: SOCK_DGRAM interface fixes")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -885,15 +885,15 @@ static int llc_ui_recvmsg(struct socket
 		if (sk->sk_type != SOCK_STREAM)
 			goto copy_uaddr;
 
+		/* Partial read */
+		if (used + offset < skb_len)
+			continue;
+
 		if (!(flags & MSG_PEEK)) {
 			skb_unlink(skb, &sk->sk_receive_queue);
 			kfree_skb(skb);
 			*seq = 0;
 		}
-
-		/* Partial read */
-		if (used + offset < skb_len)
-			continue;
 	} while (len > 0);
 
 out:


