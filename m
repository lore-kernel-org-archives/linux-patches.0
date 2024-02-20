Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE404151CD8;
	Tue, 20 Feb 2024 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463768; cv=none; b=Y0vJDTYwOjmlfrqtb62PJC5Ltw4zpfUHJ3V/gFxJBwBQHg23q/KZfZNCmCO6TPVOzQxHdC0phfwNcNySk8AjhRIXuBxoPvSetgWG/W2tZ2qv1ZpJPoonfzVwWIA8KgDFe8hXEsLJDClctE6kiGQDArumZwCjE8u8GoItH6ochJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463768; c=relaxed/simple;
	bh=JzkvkzSS4KihQCUHm8KQbcHJiLuseqVbihO8LZeFPo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deiOCJFj1vw1HbMcUEiLvHoonjVW5cruuOIB/GT6XrkK1IQOUm798cuKVfVsmpcUzEIjkheef6mAF/Qz1DluPQgY6oyOu84O722T5XOXSrU4SaPkZjZqoGsWwD+sC25fSoSdZZuUVHWI4TGSgYQx6v0ntGJwPtRS8TZG4LCzsgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgZXfYmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgZXfYmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452BDC433F1;
	Tue, 20 Feb 2024 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463768;
	bh=JzkvkzSS4KihQCUHm8KQbcHJiLuseqVbihO8LZeFPo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgZXfYmz+upeI9h4qj6kKSOiAZFsqt47QvM5WJlVsSDu8GbFl//oWPqBUDv40CbyT
	 SoQ7UW7gWgmUabRHaobIz7WCwsPtg95wvLLLrH5hsx54g4O8cQRswvdcOxjL9Fhcy3
	 evgPbJZDsAG9vI3ZQOd7CF/U5N6IuNopyWr0T2DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 6.6 145/331] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Tue, 20 Feb 2024 21:54:21 +0100
Message-ID: <20240220205642.101935831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit a4e61de63e34860c36a71d1a364edba16fb6203b upstream.

In remoteproc shutdown sequence, rpmsg_remove will get called which
would depopulate all the child nodes that have been created during
rpmsg_probe. This would result in cb_remove call for all the context
banks for the remoteproc. In cb_remove function, session 0 is
getting skipped which is not correct as session 0 will never become
available again. Add changes to mark session 0 also as invalid.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Link: https://lore.kernel.org/r/20240108114833.20480-1-quic_ekangupt@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -2191,7 +2191,7 @@ static int fastrpc_cb_remove(struct plat
 	int i;
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	for (i = 1; i < FASTRPC_MAX_SESSIONS; i++) {
+	for (i = 0; i < FASTRPC_MAX_SESSIONS; i++) {
 		if (cctx->session[i].sid == sess->sid) {
 			cctx->session[i].valid = false;
 			cctx->sesscount--;


