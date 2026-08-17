Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935751D435F;
	Mon, 17 Aug 2026 13:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974173; cv=none; b=P8XYopsre9OgXk2TZaU1zPy1AQnq2V72H+J4w6we5eAcuHYgZjRu4F+oSooUpZBmx4rz9/7ZhhxceGtkSj6vkP30XWRFmEKotFHZDnumegt9Wx6byl4nfi8C0UplNMwQP3f2SxRyIOkECPwPwsiuIth3KCLcxrruB3QTeKC10hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974173; c=relaxed/simple;
	bh=mBXNoB5oGfDrPe2bQoCdGpkWZod/jdzd8Dq4prczsEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmFl/K0QbOVzIT6ute4PEKLhghsJX5lLaTnBbByrZwz8gkpq9qV3/X4ikYUgIioCRnhbyQ/4mehRmxdvOull8utMQqHeboOWxcKPX/nHEGhiVw3XJjhMlkoSUZBGVNn5H96SC1b1cR91tzUTCYNnqFG9f2XHAtRlYsTBLPmhuwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRQHo8J1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRQHo8J1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE46B1F000E9;
	Mon, 17 Aug 2026 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974172;
	bh=ZPE9wmDZFcCX5mT1+VGN9hDvkIhAW79mx8MghDAybUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DRQHo8J1JRHiimO1kwCo/ue3GMxYcu3K8UKNLa23F2XstveWe19OmJvqnp3j/FnKG
	 OSdFk5TrKQhtr+nL9pkM8ih6D5pLcZe92/TVzv03ovNt1k4uOXucmYRMyjUqeQU/oZ
	 fcHpUzAjYApCzYgLqicTUUCwfESqeaHcwQfPlq9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 113/271] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:30:38 +0200
Message-ID: <20260817132541.536891062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba95f9d927a35..a8c3adc0fad0a 100644
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



