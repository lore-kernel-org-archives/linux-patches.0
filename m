Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C836541D635;
	Mon, 17 Aug 2026 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976343; cv=none; b=rdBK+GL2hjIUi+C1xxob4NO0RwoIRKtZDp2frj0TkrQToIQUyXJp7CJPGnszrnZ5HawiDJkM9lWyZUx8+iXVDLC3yAv+WoiDiPCWTA0wL538oObYunMmJUJjPc8j/JhWd7yJk06+MLgn7btyes54NWGx45AJ3DGFM33U2P2WkRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976343; c=relaxed/simple;
	bh=pZ84aDsXSDBqg07MD5xBUTCNfju/MfaoF9QOEAmeIe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wvfhc8SlkR69ucF0WiXzbhjQsXr/qh/yVL9T86d7rpqL43qf8+pRS5cYMUzEkT22CkgUDfisOAJTVHAmJpDrZfAvAxE8tmcKXzykenPoeN7N7HmqabuiF+cVANMKGMf7AuZtdWMexImNomVI3Epli1ndHwpXHJ0nvg2Y5ctcETo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPbGX34p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPbGX34p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D069A1F000E9;
	Mon, 17 Aug 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976342;
	bh=xNH1FFIARinPmBEiCoio4angnu8UTDAKBGKcEQDNPCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPbGX34pE/gH/FEBmYl7pjzYtKA+/qJYXYPRI0TEL7mk64d+m3RgYnEoCojD4vcnY
	 i7GT1ifqAJnfYwWm5N3/SjpYSNT3tbcCS3sB8PPj5y0ELLxfI4IFo3LoewtGfhA0B1
	 WMB/7abEWjQ83SBQjp30WQ3r7VRtGcYjLT9AFPCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/389] tls: dont abort the connection on signal-interrupted sends
Date: Mon, 17 Aug 2026 15:32:59 +0200
Message-ID: <20260817132552.101528215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 29650fa546664..c2344a46dddda 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -430,7 +430,7 @@ int tls_tx_records(struct sock *sk, int flags)
 	}
 
 tx_err:
-	if (rc < 0 && rc != -EAGAIN)
+	if (rc < 0 && rc != -EAGAIN && rc != -EINTR && rc != -ERESTARTSYS)
 		tls_err_abort(sk, rc);
 
 	return rc;
-- 
2.53.0



