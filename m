Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9097A708;
	Wed, 21 Feb 2024 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525763; cv=none; b=u57Zbz9PrOLDJAXYgBLjpmt2lN1DLUaVJxt3zfZJYcGnu8tMY2QXlCo67bxCQT4PDILnnQHkkqg26uI6RBFIiKP/jhxgcJENTYMe4zBxJiVrcKNYE2NDvtXod4lxBgynk8F4YZ/rOHpKkkite4VIrVnQcGJ6lEwRV7dB9tYNFk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525763; c=relaxed/simple;
	bh=+hHomsUPq8mp9cQA4GbGSqokdDKOCnmknHPfQ2M6XKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQW535nvz2XLqpTw9vmQKD8w/oOdJZtvlNctQEr4ovm3WKAtVA/qmXCeWyiXNMuhzFej7hGCx73hKuTFsI3Nv5y74zZBZZYHD3acGdX45Y5Y3/UazplZeKDsbM1Vx78cz+8+NV1fRzwKpdbxinWmJ9tgBOVKrgNL0popT8tF3qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgZtz5QU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgZtz5QU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D848C433F1;
	Wed, 21 Feb 2024 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525762;
	bh=+hHomsUPq8mp9cQA4GbGSqokdDKOCnmknHPfQ2M6XKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgZtz5QU1GZ4AbSrtBeiEfmK/AOLTMaRAQgun9wdBfT6RjeqF7Wo4TL1yWHS+dfbv
	 nnDQ8a07olAeRfquKDFAI2OOt7k6EHp1B0XqRXEX0d9X720tP5nvVqQnSU+8zIxKWL
	 vQJ6h8SM1P127esMw3j6a2cpZgJ8Pic2dt1iaFFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 5.4 228/267] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Wed, 21 Feb 2024 14:09:29 +0100
Message-ID: <20240221125947.407317443@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1401,7 +1401,7 @@ static int fastrpc_cb_remove(struct plat
 	int i;
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	for (i = 1; i < FASTRPC_MAX_SESSIONS; i++) {
+	for (i = 0; i < FASTRPC_MAX_SESSIONS; i++) {
 		if (cctx->session[i].sid == sess->sid) {
 			cctx->session[i].valid = false;
 			cctx->sesscount--;


