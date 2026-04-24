Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4A819A288;
	Fri, 24 Apr 2026 13:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038274; cv=none; b=lY+ZltQwNcWCWtTvjRA/zCE/G9TAXug/yuQbdGBaPGKXuh3W7sthWG5zxmL5SIA0wVggcpuNZLpO6+ioUW2rSM36lKvyeULgBe6k6gJuXJhSCppDf6yqBsCZAxOU7HoorUiTuHjuVhyZuSDUN/UfuqFcsXCQEtq4Eru/2+XuWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038274; c=relaxed/simple;
	bh=ZO2C9Z8P1y0yHQa+O4HPZVbu82DbvNiZuwc5oGbkU64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7I+uO4JO3N5GkW8M4PY9rPe73cSHmZvjpZHauyZOfFV8Qz1IiBlfIsoPYmGhfe0LRfapPmzM4DdVoTzC4h9+akongVSXpM259VuOaAf0kPbUaqvBMIS8QuzpPd7BQjO9YAQVDu+4DleDeDJytP9GNK6TBVCCBaifcisZ2ca33c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs84LW9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs84LW9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136D5C19425;
	Fri, 24 Apr 2026 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038274;
	bh=ZO2C9Z8P1y0yHQa+O4HPZVbu82DbvNiZuwc5oGbkU64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs84LW9ifn7jMeM4mg68aJStD0XWwYKYK/oe032Dr0g5XHGuDfmjDtCfA8pfXKXOW
	 TSS1bTRcwT7ODM+z80ie9NQSJfyzwkpd8ph2t6D6PSqZHuEYmE+6THYhjzRqv3C0Ko
	 PPw/FUhwAbVdm1p9KKAjT54jTmYYhvbrjVcLGjXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anderson Nascimento <anderson@allelesecurity.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 35/35] rxrpc: Fix missing validation of ticket length in non-XDR key preparsing
Date: Fri, 24 Apr 2026 15:31:42 +0200
Message-ID: <20260424132419.118980502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

From: Anderson Nascimento <anderson@allelesecurity.com>

commit ac33733b10b484d666f97688561670afd5861383 upstream.

In rxrpc_preparse(), there are two paths for parsing key payloads: the
XDR path (for large payloads) and the non-XDR path (for payloads <= 28
bytes). While the XDR path (rxrpc_preparse_xdr_rxkad()) correctly
validates the ticket length against AFSTOKEN_RK_TIX_MAX, the non-XDR
path fails to do so.

This allows an unprivileged user to provide a very large ticket length.
When this key is later read via rxrpc_read(), the total
token size (toksize) calculation results in a value that exceeds
AFSTOKEN_LENGTH_MAX, triggering a WARN_ON().

[ 2001.302904] WARNING: CPU: 2 PID: 2108 at net/rxrpc/key.c:778 rxrpc_read+0x109/0x5c0 [rxrpc]

Fix this by adding a check in the non-XDR parsing path of rxrpc_preparse()
to ensure the ticket length does not exceed AFSTOKEN_RK_TIX_MAX,
bringing it into parity with the XDR parsing logic.

Fixes: 8a7a3eb4ddbe ("KEYS: RxRPC: Use key preparsing")
Fixes: 84924aac08a4 ("rxrpc: Fix checker warning")
Reported-by: Anderson Nascimento <anderson@allelesecurity.com>
Signed-off-by: Anderson Nascimento <anderson@allelesecurity.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-7-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/key.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -340,6 +340,10 @@ static int rxrpc_preparse(struct key_pre
 	if (v1->security_index != RXRPC_SECURITY_RXKAD)
 		goto error;
 
+	ret = -EKEYREJECTED;
+	if (v1->ticket_length > AFSTOKEN_RK_TIX_MAX)
+		goto error;
+
 	plen = sizeof(*token->kad) + v1->ticket_length;
 	prep->quotalen += plen + sizeof(*token);
 


