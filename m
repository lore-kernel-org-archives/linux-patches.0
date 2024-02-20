Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7C1509BF;
	Tue, 20 Feb 2024 21:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462981; cv=none; b=jmVZGYk6z8HWO4K5A2a7OzohoN3odMcPXNV8ZTYopoqHVmlZfQiTnxu+sRP2JLjts6HQ+15MGKl2q8fYhKK7/SaybKL2cHbV94m/2gu0YUlFAFxvvId9biQaRgtlJMZV2+2960iGxWHx7q/War70mCuI/2fMeUmJWBw4kbYi9mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462981; c=relaxed/simple;
	bh=a9izCY7BJ+qeFEZrlA3u7MwF70fejnGxkVGXxKwpfXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JglIXMwDeezFUfHF3TzHGJKQTAzEU3kjOZTzAbJHjQoA+I3quAK9qyIOHQcJs8pg08Zg1fj6AmpJyopaHRzXg6ARuLMKdZqnQjE2nRB94sbP4rRHu0cqQ9CwwcFDcBp9EEFd4G4xKPP9NHYtPtLUoGxyZon+ZoYokWVQ9M26PPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkzjfCG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkzjfCG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CD0C433F1;
	Tue, 20 Feb 2024 21:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462981;
	bh=a9izCY7BJ+qeFEZrlA3u7MwF70fejnGxkVGXxKwpfXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkzjfCG6ojg5W6owq3qhOWUiixsUrW1PdmTuAn61nxP9YzTX+rFFPZ+LKEy0kSYaB
	 ol8b2Ae8h+8UkAm7pjZa7Jbirqo9L6iROC7744b23xCPPQV4N/MA7JSaBBRilQCQig
	 oOh29iPe1E8Fvw1ma8fDtxLJxBDkDfgmBNBLrtSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>
Subject: [PATCH 6.1 097/197] misc: fastrpc: Mark all sessions as invalid in cb_remove
Date: Tue, 20 Feb 2024 21:50:56 +0100
Message-ID: <20240220204843.987122382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1990,7 +1990,7 @@ static int fastrpc_cb_remove(struct plat
 	int i;
 
 	spin_lock_irqsave(&cctx->lock, flags);
-	for (i = 1; i < FASTRPC_MAX_SESSIONS; i++) {
+	for (i = 0; i < FASTRPC_MAX_SESSIONS; i++) {
 		if (cctx->session[i].sid == sess->sid) {
 			cctx->session[i].valid = false;
 			cctx->sesscount--;


