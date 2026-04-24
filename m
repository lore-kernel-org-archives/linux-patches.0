Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56E73D5241;
	Fri, 24 Apr 2026 13:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037782; cv=none; b=kop8QB8gFF6UE/MQ6hVT3ZnLdIJ50TBR4N0DpUYIyCC4+NurnoWsEMLlSCEC1SVQmmVBl1/ODeekvdbzBL3E12MYNSjtoXMrXn+LmKvnjBF1u0/DJe/ea1fMUTEA6/mn28fJFNhgJ9+4/5LcLPHahhAySFN+JhOWuTS6Gi1SqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037782; c=relaxed/simple;
	bh=VkrAaVG2GtiZ7XscxBe32fLf6co/mjLlLK9FKLWS+aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nttVdFuCkve3i0b+b/osjK4DWThq15LKDlR6FPb0ElxYWHOFkZfQ0OXAU91TjsezQ3ZJjkfob4n3kJ20dptVDXP3dBGLGLa7NXzanHNtOL0TXDN4bru96ZGUjnA394n69aqlEogCki9P/ufg7vzNpqMM46CJUtTOI92quCn/haw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQiUmTY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQiUmTY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB7FC19425;
	Fri, 24 Apr 2026 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037782;
	bh=VkrAaVG2GtiZ7XscxBe32fLf6co/mjLlLK9FKLWS+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQiUmTY2E+SK+CZ31VtSPFjoDk8fcm4KP/+8Zu5X9O4lkDEGRAKduA+KVTxJCeEY0
	 K60mR138RdEqTIX90nQYQkPBbeG/+HVphAF3O3UmlNSz8vFMeQ0OHsFl4bvyQtFFsf
	 mDRU/Qd/3MlpDtbXZLe55JjPtVrw20KlpRYmyVsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxi Qian <qjx1298677004@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 067/166] nfc: llcp: add missing return after LLCP_CLOSED checks
Date: Fri, 24 Apr 2026 15:29:41 +0200
Message-ID: <20260424132546.807072682@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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
@@ -1089,6 +1089,7 @@ static void nfc_llcp_recv_hdlc(struct nf
 	if (sk->sk_state == LLCP_CLOSED) {
 		release_sock(sk);
 		nfc_llcp_sock_put(llcp_sock);
+		return;
 	}
 
 	/* Pass the payload upstream */
@@ -1180,6 +1181,7 @@ static void nfc_llcp_recv_disc(struct nf
 	if (sk->sk_state == LLCP_CLOSED) {
 		release_sock(sk);
 		nfc_llcp_sock_put(llcp_sock);
+		return;
 	}
 
 	if (sk->sk_state == LLCP_CONNECTED) {


