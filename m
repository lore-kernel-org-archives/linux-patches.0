Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215088;
	b=NmiO6ME0Yxwo9vVHNe1q5WofGPWLE1qH4wFM5coS9D5XtszvbgzXv/28xe/8SKCvqmpR
	 xBB6mCAyiMAECzezPJ05ZwU3/36QYDzzYUeCG3pbDG+C4Az8V8LQ2D353RO7kxPjYvlW/
	 Fwa+ukzD56v/WMysRoZG4+eU9g6EG/dhp8A/oDgDAcQFAef9aBSeJsVpmD8fS30qayNgq
	 pS3foOIQnqlsrgp38aAmlt/LlT7OBy0zJACdVTes7/8PoZYTWUtnzEYdLyeIT8EMRGr3q
	 sqpyPUKmZG7eh+Qf0Sdj/D/gSDI8JGG8Kv4l27M1ERCUchwLlXN6ehiSWMkjQjtziPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kD0xUqb5ZLyP5mKzSao69lzbimXBsfgQRiSMt4RgyDQ=;
	b=5Ie3F4+PjI//CIiTa+10y7p+mg7PWmV/yxCHF6v7BR7xmpTg84V7lKCm9KheXfJJBt2f
	 IlaDvuQ6O2WjiXDJYJIYmb9Yb/ktYwtVb2fDgHawzJ9ZR5ixXSOI+DxJMKbLVWsG9Oj6K
	 vJVWbwuAr194P4BRlUC0bUQmo7ExCGvrYJPgyOB2xCDi7Qzf68uL99iiYFNOexG02VnJs
	 Wlc/aupkLCj1N/v9mgcaxIA5yty3Fx1oRRKVov08+7XXfRU4Qj/8QNxYaJ0p6PYoPxtAI
	 RXZoUEFdZ4ahcZ+6usGF4C7bHUtd2eh3tvr0MN8pXyqmXbWVCY8qwjuca1LavtttPrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYgDDnyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB76606A31C;
	Wed, 28 Oct 2026 19:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYgDDnyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2E91F01825;
	Wed, 28 Oct 2026 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215088;
	bh=kD0xUqb5ZLyP5mKzSao69lzbimXBsfgQRiSMt4RgyDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYgDDnyi6j9VrzjXGikTLQb5kP6D5+VgHMvYLLPzskiUNm8UxSjc0zxJfG/xMab3E
	 svpGD8cov7nENaCkxmXCgFynwChIMU2rTHBd/wzeBY11fcZvIP1a+4lhp+9edIqmBh
	 kBO9EqRE3yQcjzaCuy1jSMjyJaGyqpLa0utZWK8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1044/1887] rxrpc: Fix memory leaks in rxkad_verify_response()
Date: Wed, 28 Oct 2026 17:52:20 +0100
Message-ID: <20261028170523.169820150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 34f61a07e0cdefaecd3ec03bb5fb22215643678f ]

Fix rxkad_verify_response() to free the ticket and the server key under all
circumstances by initialising the ticket pointer to NULL and then making
all paths through the function after the first allocation has been done go
through a single common epilogue that just releases everything - where all
the releases skip on a NULL pointer.

Fixes: 57af281e5389 ("rxrpc: Tidy up abort generation infrastructure")
Fixes: ec832bd06d6f ("rxrpc: Don't retain the server key in the connection")
Closes: https://sashiko.dev/#/patchset/20260408121252.2249051-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260422161438.2593376-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxkad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 038c4f2e8cef8..262b0df1e447b 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1311,6 +1311,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	kfree(ticket);
 	kfree(response);
+	key_put(server_key);
 	_leave(" = 0");
 	return 0;
 
-- 
2.53.0



