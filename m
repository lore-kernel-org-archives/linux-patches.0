Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7151377A03;
	Wed, 21 Feb 2024 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523305; cv=none; b=W+trKwqTrM4f4KqdUIsiLLKmO5eb2oTf/jTPvk05+JTorpGsAxB0kc3WNVgt+XJ9EhKTcTHQM12XYuJqUKw/YShb4TpKBNy4jfbhGf99qnop3QaQ8C3AnqpWnj2Zky8QXqgTeJY1I9OgDOok7VMViH1KPHB/vJeAxaCLCHgcQq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523305; c=relaxed/simple;
	bh=knEsCc4GWtUgFMXcJApjir04yMu3mxes7hRiCF+Lc3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRmL4RsYzDsJAinffDti+RcJCeifH5b5V4DxReKyWkZz3zFW1oUPDq0kWYTx0gx+0liSIWX526A3abXjFdlK08RiVau4GIcq3ghYGl/iff51/0IXEsM5+Uo8PGu/owKlzq1Q1zQrQOGBgNpROVQ9VjUa89Ml0BkwFeP1+iZWa08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKLtYhdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKLtYhdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D668FC433F1;
	Wed, 21 Feb 2024 13:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523305;
	bh=knEsCc4GWtUgFMXcJApjir04yMu3mxes7hRiCF+Lc3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKLtYhdkCnnitvUbpz9bweVUjM5WWbKh0CW47ctiPUkWc2u9NC1OgwRDBy6FRk/3t
	 gd4o+eoOSQFsPjGJ30u3m3sIH2RoLbmg+dMinQtl0F80CIpZaHDE4jGp9GQw7N4pbH
	 FfKTfk8YXDtq5D6vh2FYz0RP8OY3RCPUq25uwT/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 5.15 388/476] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Wed, 21 Feb 2024 14:07:19 +0100
Message-ID: <20240221130022.383696412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1594,7 +1594,7 @@ static int fastrpc_cb_remove(struct plat
 	int i;
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	for (i = 1; i < FASTRPC_MAX_SESSIONS; i++) {
+	for (i = 0; i < FASTRPC_MAX_SESSIONS; i++) {
 		if (cctx->session[i].sid == sess->sid) {
 			cctx->session[i].valid = false;
 			cctx->sesscount--;


