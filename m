Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8087C427F84;
	Mon, 17 Aug 2026 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974939; cv=none; b=CGgpapSJeNslfEBYean3a36Hc9RRf/Db8rbLz+0e7pvlipEVBEBav/p/6j37E9UkO1LRFxseQNmsq8qAJJNv9meAA4fYmMm5eHsIofPqApnVI5WJmCCdC58zxVF0mTZgm0Es+eGm3b55L3Wb+OBu5ONBICQ5hFNNA8QRogZ5+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974939; c=relaxed/simple;
	bh=nv1G6TXVo1YX5F49mhmoDQO5K7ieNtAlUWbw59R06sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUFZqNiuOZXxwKy/hJFEZwSNzZvZlzvPYTvhiq4lmjYOjzi/RpKfmOYlos472uFmfjBq3eEttUgyewXsGyXmO+XzHGTKqPuQwR/poZVKyXHJNf0wQEt86lji0LdasS0BZZFuQlz5KDl6cENTcy+Z6n/SgQZleHfO7HkGGtMiDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k75PKo+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k75PKo+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D441A1F00A3F;
	Mon, 17 Aug 2026 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974932;
	bh=fcciespyxniXtiQrCSu68d30oojsD7X7M6pwvfnNnVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k75PKo+LFCGhaWziymR9oPVqthXEXI3gfA2HPZnOr0j9LZoTi/bFWGZQlPdEZAuUT
	 gQbJPp5uhoa7S3VLFSwuqTavP5mlRFUyyN+x5H0q55vDHNxDdq/k/6uwb9L2D6Vxqd
	 /uaK8E3IPRHW1E/giWSHzkxmv+ZufVdywcJEGdIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 103/250] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:31:04 +0200
Message-ID: <20260817132540.742142307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f19b504efa5d0..0bb710c5fa601 100644
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



