Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8B1F8AD7;
	Tue, 17 Dec 2024 17:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456310; cv=none; b=bsIesZQ9NfDC/Y8QAA2CCfZZgujd9dNgJuhI3r8Uz4oXx28I5GMxtcRwoA+8pKTNycYacDXk3EQ/BYD1rcuWbwGJ3Ce7ikLdq/aCmiXC7S6/hVKpkSMvvdOKFHOOD0F9aR5o0RkrUFbYLHClJ2CtrVl0cAUMyW7jnYs5BeK7hmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456310; c=relaxed/simple;
	bh=RcVmwwCq/Gf3IJiNk6Wq1d8EEqT4PXEMBIN7d1OU9L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtLyxr6+Jm2WDTq7TvwzerkM9WqLhVgl+NR/JE+KNI6LCzs3EiC5AncrXCDfI4NGxi6W+dbZ0+am/BsdlposnDg9m6yGpf8nSpQcOpTzDSeqKlItWVbVBLlm3k9ipWid4+UFgydWDtGgPaGi6fXqE/OTNGtoFgh8a0QxtUPY9TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUqXXE2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUqXXE2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15742C4CED7;
	Tue, 17 Dec 2024 17:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456310;
	bh=RcVmwwCq/Gf3IJiNk6Wq1d8EEqT4PXEMBIN7d1OU9L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUqXXE2TZzTtTilks4QUAupmZh16yGtUr4YTk49aECsHyqhPYcHW/5p6sD/ogdKq/
	 L9yczFkStQ12rB+uBArrYNueLsg97B3tTid1yx2WMAJrYrbhD5IP9HzLgYV77xPfUB
	 sGtsMsHdrVaTxnxPwRUpnVTHlbVvZpwoRVaA5c1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MoYuanhao <moyuanhao3676@163.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 009/172] tcp: check space before adding MPTCP SYN options
Date: Tue, 17 Dec 2024 18:06:05 +0100
Message-ID: <20241217170546.632815079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MoYuanhao <moyuanhao3676@163.com>

commit 06d64ab46f19ac12f59a1d2aa8cd196b2e4edb5b upstream.

Ensure there is enough space before adding MPTCP options in
tcp_syn_options().

Without this check, 'remaining' could underflow, and causes issues. If
there is not enough space, MPTCP should not be used.

Signed-off-by: MoYuanhao <moyuanhao3676@163.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Cc: stable@vger.kernel.org
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
[ Matt: Add Fixes, cc Stable, update Description ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241209-net-mptcp-check-space-syn-v1-1-2da992bb6f74@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -883,8 +883,10 @@ static unsigned int tcp_syn_options(stru
 		unsigned int size;
 
 		if (mptcp_syn_options(sk, skb, &size, &opts->mptcp)) {
-			opts->options |= OPTION_MPTCP;
-			remaining -= size;
+			if (remaining >= size) {
+				opts->options |= OPTION_MPTCP;
+				remaining -= size;
+			}
 		}
 	}
 


