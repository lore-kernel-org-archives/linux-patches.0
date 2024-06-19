Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A63A12FB27;
	Wed, 19 Jun 2024 13:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803196; cv=none; b=ejfcbmUsueF2FmT+ttZX5tlCon8V47JKwJ7wE25TEEvl3DdspwGeo8djXD7wgbLW7xwAueb+hqJmhWYfCR6sy9PO16OQ3FWEH9594MIRcI/CVYZhwRNLJpU2961fWkM71Z0jArZn6UD4Qlpf4Rnv12Tkpu7Ix3PynmF89Ol2Pao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803196; c=relaxed/simple;
	bh=9tYsadIpAZisQqtsdnlRNafilU1vDEwbhCFyzmNZjHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZw6f4hU0iigBVAo9Vgr0T/aUR9r/tX31RZFVP16P54flkgdR2eXkDUa4GnEmKEGjPzx6WYpSz4Ds6ilYLk2yu8GdGNimuOhPWQnnwVRkWZW9S6JFmDwxLk3WnFAie9nCnnXDYFnBdrktVB5mZ++4wu+Jt/3wJ5cIBJljmwLwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ap90bL3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ap90bL3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6130C2BBFC;
	Wed, 19 Jun 2024 13:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803196;
	bh=9tYsadIpAZisQqtsdnlRNafilU1vDEwbhCFyzmNZjHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ap90bL3uflnW4rIfaUrIJi2bbocNLAd85C3xOQN4mOUHfMgGYD2IJ3R2EsNSq6tDS
	 SThQDBOWmH+tKvFh2UzUe5MLk+U4rY2syVCyKG0Kl9s1T2/FlB207jXyd+B3MuF6jd
	 bMPg9BTNvQ2VVzh3+LkEIemXryngpIB8dvEz2r/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 186/281] bnxt_en: Adjust logging of firmware messages in case of released token in __hwrm_send()
Date: Wed, 19 Jun 2024 14:55:45 +0200
Message-ID: <20240619125616.994014238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit a9b9741854a9fe9df948af49ca5514e0ed0429df ]

In case of token is released due to token->state == BNXT_HWRM_DEFERRED,
released token (set to NULL) is used in log messages. This issue is
expected to be prevented by HWRM_ERR_CODE_PF_UNAVAILABLE error code. But
this error code is returned by recent firmware. So some firmware may not
return it. This may lead to NULL pointer dereference.
Adjust this issue by adding token pointer check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8fa4219dba8e ("bnxt_en: add dynamic debug support for HWRM messages")
Suggested-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240611082547.12178-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 1df3d56cc4b51..d2fd2d04ed474 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -680,7 +680,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 			    req_type);
 	else if (rc && rc != HWRM_ERR_CODE_PF_UNAVAILABLE)
 		hwrm_err(bp, ctx, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			 req_type, token->seq_id, rc);
+			 req_type, le16_to_cpu(ctx->req->seq_id), rc);
 	rc = __hwrm_to_stderr(rc);
 exit:
 	if (token)
-- 
2.43.0



