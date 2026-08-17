Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DEF3F7A9B;
	Mon, 17 Aug 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977715; cv=none; b=LJ4BDSf9EtcpEk6PYPapyQQqKqTqhdh2GpTCWVQtlrhbj5DMVnurmVM1fpb+1AlkVyeEx7EnCYkV1j3H1JvYxDx3In56YVWXcvP4w8+cVUSYBYqXuScSijp6nHQUuEIWtvVwYstiPktH1YGnVqxJI23D1RMwU9Rm2kBaerxJNCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977715; c=relaxed/simple;
	bh=h7Oji/hppW4ToUN93TmyKQkwn/X+iyvAlEcTIdfOYh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUBB2dJrC0eL/B/QVhXZBUFab9zxzOtxX7U18tw4dJKo6E7p8O1qaX5hsA+xY9oDi0BA/QW0Glofwbm2IZp86hSYemBlLKjwH4VstCWOdrqZfYr38yd9Fd3UPEzzgA8BGZG9liXbBy9d9phYebGVX9gtHM54hudeuOkOvy8z8pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0bWcRek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0bWcRek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EF61F000E9;
	Mon, 17 Aug 2026 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977713;
	bh=LdQBoZaG6YX8ff4y6LfkpDxnd4mIpVT5Xyh2fe+1GDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0bWcRekVZ+Vlu+x714zONzUZZktWXFpW5utzcRBlGklRIChKJlZnYT6Xz2b44Ca1
	 s0LB+8Q2ylTbWzGqFoc/Jfj2OxgO6BcQQEH7gueyax25wmoaW+ipx0kFqg8maXPlvS
	 V8J6KOyoGUoBmnNaju+T/xKhIKjUbcXdJey2EBSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/456] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:33:07 +0200
Message-ID: <20260817132554.892369434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>

[ Upstream commit af0e5cdd031f4f4a8f6d4160bfbda4f36872b0ed ]

When a signal interrupts a blocking send, tls_tx_records() treats the
resulting -ERESTARTSYS as a transmission failure and marks the socket
errored via tls_err_abort() with the raw error code. Later syscalls
return the kernel-internal errno 512 (ERESTARTSYS) to userspace, as the
signal it stems from is no longer pending during syscall exit and thus
never translated.

An interrupted send is not a connection error: the partially sent record
stays queued and is resent later. Interrupt error codes are therefore
excluded from the abort in the same way as -EAGAIN.

Fixes: b341ca51d267 ("tls: Fix tls_sw_sendmsg error handling")
Signed-off-by: Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Link: https://patch.msgid.link/20260805063109.1772314-1-maxbr@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0cdc9131aff22..012ff6a496697 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -455,7 +455,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN && rc != -EINTR && rc != -ERESTARTSYS)
 		tls_err_abort(sk, rc);
 
 	return rc;
-- 
2.53.0



