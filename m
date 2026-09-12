Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC331FBEA6;
	Sat, 12 Sep 2026 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230936; cv=none; b=RGufk3OvYUtWiNcR72N+Cl320tAxq9jvmEieEl+DcokCXzcJH9gpjiQpn4QqlEQsh0BmPfSiXAWnP+Xf+PZP6DHAFBXgJ30f+VCrgvN+d7JoIlUBPXs3pggjvt+L9mvhlqULd7NgGU91hrWu8xNJwTCjfpKDDRyhtg6eIU0ZpoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230936; c=relaxed/simple;
	bh=cFX8z+b/YtF1GPr3j1UazmBFHrlKI+O14urz1i0VOYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC7P1befepz6du1N42difMsrFFv5ez0Lg+hNkVDiKa8jbqSZsytFyKPl21RqpuTPZKskIgpOsOva/5CuvdgTh9zdZ6TC+AoP2k6epsaI8NZiieHTZoP++6OJBObga7gantTWhz7XNKIvZ86Iw90ABm3cD1rcRhFhm4xjl+gXuZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReXzxF6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReXzxF6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B88E1F000FF;
	Sat, 12 Sep 2026 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230935;
	bh=ygLNIQQdNaI7wpNaWTqfjibPIC/kLP8MZ9dLosPyJ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ReXzxF6ANm0Szk24jG7tuN4fkJW6pBNQXn6Jfglz6vucfc6szmyV8FRrXfgjsuzGi
	 6PNplScSezMse5CNFngMGCkFMpbIXJ1ODLdiqhnZRklEqzxiCkdmOo4s6eEaTBP1YX
	 OHMAyoFxX6070YbzcKF5VIgfMkH+QxsSKcfH9A7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0896/1191] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat, 12 Sep 2026 09:00:24 +0200
Message-ID: <20260912065608.362495849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c665e134c9b1b..32cefc30d6cd6 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1712,7 +1712,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.53.0



