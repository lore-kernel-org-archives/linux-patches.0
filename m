Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2CB2E7368;
	Sun,  7 Jun 2026 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827721; cv=none; b=BedbM+vTOYogJ4zzCfMuiMqrNGzeIcaMYbMrlqGhCsnTwJlD1oCH7mGnJCmBazerYc5ZYs2WrX8iRdNgcmXNr0ZQsbFbkZsDLv6gHqWBHswB/DeYQy9RMbmTQxXTdP739/qkR+0QMbFWvm8qwOaU8glP44lY6EEISm0XXmCf9hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827721; c=relaxed/simple;
	bh=TAfEUHQ0Xf0JaEyeR7kxQl2x2ZiTVWmulnz+gqYQVbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNUsE2MdQri30JYFVOMv0pzvbNm//KOxj/g+6bWGyBRkZQaYR0rSoEsXPAxgoK3qmbMkNo7XJXZMAfSi2CJtqdkFbXOvkEaxAZUxRz5BGwcyoZjZRZ1V6l2ttTmtOxO6LlXNhVrjeGle2BcFZ5xczWqfEznfpUiIbZS6esZpvv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPYIZgri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPYIZgri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3E01F00893;
	Sun,  7 Jun 2026 10:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827720;
	bh=h1gES4LvaVSt4TcsBysO7iAn2a4972wy2Yorz2xH4IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPYIZgriguK4HFbTVzBI1dYuw8VkvBguy6yFU6U4Ll/G/080bIsMATfjC6xUei5Oi
	 dYl2sOU+RFTyXxHqUw4CH5AINoBVhY+7c+VwktRJL9lzbEJNxKQUqHdb4HAJ4lsZNV
	 w0EW/KH9VfNSQS20/V+XJH/clrUOv7BlKZ1HQOIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/307] nvme-tcp: store negative errno in queue->tls_err
Date: Sun,  7 Jun 2026 11:57:58 +0200
Message-ID: <20260607095730.748831594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9015985b5eb1a90eb86caf5bce1dfcf1aa38f8ad ]

nvme_tcp_tls_done() assigns queue->tls_err in three branches.  The
ENOKEY lookup failure and the EOPNOTSUPP initializer both store
negative errnos.  The third branch, reached when the handshake
layer reports a non-zero status, stores -status.

The handshake layer delivers status to the consumer callback as a
negative errno; the other in-tree consumers --
xs_tls_handshake_done() and the nvmet target callback -- treat
their status argument that way.  The extra negation in
nvme_tcp_tls_done() flips the sign, leaving tls_err as a positive
value (for instance, +EIO), which nvme_tcp_start_tls() then
returns to its caller.

Drop the extra negation so queue->tls_err uniformly carries a
negative errno on failure.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-2-66c616906ead@oracle.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 77df3432dfb78e..31406438e3ff2d 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1719,7 +1719,7 @@ static void nvme_tcp_tls_done(void *data, int status, key_serial_t pskid)
 		qid, pskid, status);
 
 	if (status) {
-		queue->tls_err = -status;
+		queue->tls_err = status;
 		goto out_complete;
 	}
 
-- 
2.53.0



