Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892C346C85E;
	Sat, 12 Sep 2026 10:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210158; cv=none; b=rP4tadw8UQOPdA+/s+ZU5OxhzHDA47bvrislnYl6U7zqqCvrkv3y4qFUEBYaUdBcoo/HjCGGju8qbP9qdkWWK5fPmMHRZpa7SBo0JRzG0UYQswuDDiM5K2Ugh0gmdstKcZFOsxdaeFgDhJI/8OueUfQqkT6/o/UAd0Guwt0Pq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210158; c=relaxed/simple;
	bh=AqlORXm8XFzb3H34SjeJuXTLfPbfsdRzP5CpHvYC2Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEdDIonLpf0Lguef2Nx6iKNK+nkOdZk2pAkcodzrUjg6g1SjCyQVA/oxnW37Uz1m7CzwkvpeTrO0IOZTM7HFWEorbNqnepYVdwNttr47VbhlJ9NsrTkiR9Hbllzx8oVapZaYtSRJmcfVbarv9W7AJgC+1XmFJud1XXB8Url+FPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p53+qigG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p53+qigG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0DB1F000FF;
	Sat, 12 Sep 2026 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210153;
	bh=UxcvqD3rNCuBQQOX+Z85eXCvrZVue2ak+fHXJqJ9VRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p53+qigGXAYAJXTujZGfegzAJPR4Pe+UL1i+VsLMLMpeZPrMlqz+zRi6QF5jamUWL
	 GEAkNXKqnm5ot41ryEu0/j/ELCdfxuqmtzkXVUJ83ml7Qn5bA5P2pFoG0bWaDRZhco
	 kp7OwdxmJIZVwccIgnOTWmz6/9lnOX/LMAhCb8eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0925/1518] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat, 12 Sep 2026 08:51:34 +0200
Message-ID: <20260912065644.374383055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 49ff121f77fe4..bb7d909639071 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1701,7 +1701,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.53.0



