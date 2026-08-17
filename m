Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FFE21CC5C;
	Mon, 17 Aug 2026 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978500; cv=none; b=fKWxKdKpDa6y0/wfaIjQLz8mSQKrQe5Zyn+/cWCfVblR7BgT5wEd9oXH0J8Lspww1MdvtTpmxLVR3cB9PfL6y43YfyT44kRnSgfCFSqHjV+/bnTaOVjYYWUxpNEOwMzWsHKjPaPJ6TobbUOcChKzDi66SL/5WWExhHKCjcG6tUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978500; c=relaxed/simple;
	bh=u6mBylACHKr0rCpUmP9Dev1icGtTiwAHNvdd/P5DAEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQp7zdCbkJjmfp9kphkXxWssD0tX1PxGwJ8S25pQSjqSlP4Hmy/MjDkccn3PuAKulJMYENV7rtdU8pDjlQCvP/otFuwncsfPKN/cFjYnS7LkYZg/2cB3oHe3rPyLXQPGX12o6ctdc7+aJXcX6otdVx+MziddkNz7p7tvdFbC2hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aJ/0Eh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aJ/0Eh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC351F000E9;
	Mon, 17 Aug 2026 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978499;
	bh=2Qx/h53nNV4v8xVhfXDFkDYML/4+MfiYi0SIgzv7lic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aJ/0Eh/LQmM4Dq4Z38WwbN8efUC132GqapRmMnmnmj9hPc65XawuGBkEX9973Phe
	 vIM9hfSCJ6/ZTMss++zQwBeCZipIER0ozfopKSOljsvtgwgaGgm6ft5LmSKiEj57Lv
	 Dziiff0P6CYgQ00cEkaqdlnPi7O9YuC8T0RZXnHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/156] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:33:12 +0200
Message-ID: <20260817132536.858775275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
index 39021fab3c596..719cc70b26505 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -458,7 +458,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN && rc != -EINTR && rc != -ERESTARTSYS)
 		tls_err_abort(sk, rc);
 
 	return rc;
-- 
2.53.0



