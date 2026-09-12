Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9D5416844;
	Sat, 12 Sep 2026 08:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202333; cv=none; b=P/3uZ8wJXg0jsPpW85lRJ4c2+Q7rTORiNqMIvUq/vdOqRCpBcPCvd1mAAiWBsBzWQnsPQyyNS5KbqfWjMC2BxgfBp+G0YxIZ2pTVSUPDd4PPY07xcj+MrIpRFVB3cBSfT8YW837WeehNTc51wnFWgG/boGbkNcAdNQHo3ScloNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202333; c=relaxed/simple;
	bh=yOshIVW4UYUPCGzCvK1O/yA/F3ZpbVeOG3DN2Mh9fic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXlys+Jjo7dHmQMmvllTJ/YOQt8UI+fw/fVnDGBKqz5UBUFUknC5PzM25fyT/Eyy1SjUPQyVox5NtcZt8/l1uFBeHmBeodfiEC2KxYRj9J4RgS1oq+u+Igsvy4bvu8dwEQQ7W+jlHXXr73hkbmSJFkUKoArgLY/M7JVQwmh5SSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyqiYlIX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyqiYlIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201711F000FF;
	Sat, 12 Sep 2026 08:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202332;
	bh=PlPiAm8P7fpGK4dy7d8oMLs6Ql/WsjSGTbY3T1Z7iCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyqiYlIX9d4ZjQzVkDU8/T8NwSYwsRyEPzi7uh7CxFMh2WH4JOxoMg9OLx8hcYZ68
	 bmxnGgtcWDNAUp+33XvZiYsd+D7YnJMI/Qba9CeVguS458K2RcIWATi8k1i0jgt4GS
	 6gh0qq+gL4Z52FhASo3hU6kC2/SJTSIc9nnWMSRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1144/1815] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat, 12 Sep 2026 08:48:14 +0200
Message-ID: <20260912065715.872272855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ Upstream commit a9394971825933074032794a5feee5211509c774 ]

siw_accept() looks up the QP supplied by userspace. If that QP is
already in RTS, the function jumps to error cleanup before associating
the incoming CEP with it.

The cleanup tests whether qp->cep is non-NULL and assumes the current
call installed the association. However, qp->cep can point to the CEP
of an existing connection. The cleanup then drops a reference from the
incoming cep, not qp->cep. Once the incoming endpoint loses its
remaining references, this can free it before the subsequent cep->qp
store, causing a use-after-free. It also clears the existing QP
association.

Only release the association reference when qp->cep is the incoming
CEP. This preserves an existing association and avoids accessing the
freed endpoint.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260801213632.1086548-1-shuangpeng.kernel@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 87c79527ac090..0245b25e72718 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1751,7 +1751,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.53.0



