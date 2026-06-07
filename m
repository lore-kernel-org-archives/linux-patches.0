Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D0B2AD00;
	Sun,  7 Jun 2026 10:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827492; cv=none; b=T5ggQOhgmU86NjUQ3cevvohe83JVCG7SflNgmE0pKK9c3a3FOBQuePJDK6ZyN2T0OC8a2dVNctqcPpY3EY603MJOCdGfwauzJtk3Isz4Ryp4c5RFrzWnzHesmSHw5NOHWGWAEEQ8Kh27DGU56z1dYSX2y0wS3T6ifbp97/7Mot8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827492; c=relaxed/simple;
	bh=Gb4ycSgy6xQ6SwVviEre2BeVmVgY2bjPc/QGXbRRaHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJAz/gEb1w5pKewli13QtgxfTcZOZDsJNoahQYMuasXRsMeNr64rWIqFPb/XwNpLdRtpJimcals7cgiXf2Z84WzqnOBSDklcZ8EralCuGT22+a2afntLTgTdpfgouT3gUjtBkbOtze3MmztrHinEyoST+33rwK6u4iWJwx+f4vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekuZ3pe7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekuZ3pe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E31F00893;
	Sun,  7 Jun 2026 10:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827491;
	bh=kZZGD0ZqjqbbXZr4F5Nc2BUh6rwH2PvojxFxz9ad4lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekuZ3pe7SsbXGLx8sG9XlugYLz9hCLCG29OlkZTqNCHZXvQ2V6BQQXOv7BjxiEEPL
	 wJU782cmJbgKzcVypArcF3ONrxxlJGTU89FvPiCj1/o+pXzNroJ8+1bSZvjZBupe2B
	 HIU8jnPWtDVmmEgLS95QHr+O8Uy1bECfTWDoycEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Hannes Reinecke <hare@kernel.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/315] nvme-tcp: store negative errno in queue->tls_err
Date: Sun,  7 Jun 2026 11:57:45 +0200
Message-ID: <20260607095730.481366944@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
index 9a96df1a511c02..afdbcff3d4821e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1687,7 +1687,7 @@ static void nvme_tcp_tls_done(void *data, int status, key_serial_t pskid)
 		qid, pskid, status);
 
 	if (status) {
-		queue->tls_err = -status;
+		queue->tls_err = status;
 		goto out_complete;
 	}
 
-- 
2.53.0



