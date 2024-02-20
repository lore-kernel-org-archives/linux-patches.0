Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDD114F9C8;
	Tue, 20 Feb 2024 21:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464878; cv=none; b=X83ykcsD0QltZthh+V9DSoWYgZ1IUx8DeBhjUrYL40RLq/HpBEKvbrpV1MlPYZ0h+nPhBRr5RGeZVHsPuScSoyhrpDlnkHKb/zW+H3CgXVIpXm6dk0lNRrP0GsAiVCR4gfEqMaaSxUCzh55nJWcb3vD2i1J6niTr869JRWTZkS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464878; c=relaxed/simple;
	bh=8trzZtZeeH9fWDi01MWhGUtxYPshUb0fLVWR2bcQinY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrWJo1mNbLr7vCg9+R2XiiQGoL9UWyd30EnT6vOpTJZwhpNhW+hsS0v3JuRPSOVsxZAHQ5H258iQRz0PRAsKbSuSRvz9wxXj/aQ21/b7TTPDbUbIRZBoY527aCBFk0IBq5kv0gdak4vKxcxG65FduXBreu7rBG+NktTCFeHzd9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2ENfEVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2ENfEVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FF8C433C7;
	Tue, 20 Feb 2024 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464878;
	bh=8trzZtZeeH9fWDi01MWhGUtxYPshUb0fLVWR2bcQinY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2ENfEVTiYfm3Y1nVOGNTLiYx/MlhBBPCwY8fdp/MAYqCQuawP03npOqk38cWMzwR
	 JPwg4hSd/IYjJbRi5vH2XDy2JVnsMWg91WLBOQ8amyamXo5WA+O//1N6uzkKhSOifd
	 aqbM5cDZky9lNUtij6xGpZpOJUlNrN3JaVJUOabE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 6.7 158/309] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Tue, 20 Feb 2024 21:55:17 +0100
Message-ID: <20240220205638.111654776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


