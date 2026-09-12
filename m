Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3F8390990;
	Sat, 12 Sep 2026 19:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243085; cv=none; b=JMNJditbaAGshmWvQ830odxwZsfgyrT1UBSVJqitsDK8rtd2msaUFuj3i8d5tatnea7BDp3S2lIiLl9t9yjb5D3LdRr6SxObLU7f5aVievS4hH6+/GzD0hmMgWPu+BGKD/4iLp6xBQi5CpNVudlwwKGiIwJjoZrwE5RiQvV2C58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243085; c=relaxed/simple;
	bh=TLCEdAc4BC+KqYx0DW3Z3GMZifcXoWvhS98BxifOIjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuY8SFiCi7thyffoHKfICJ9bkP7wx313+7TcpbCB3iuPEXiJDeuBAnzwHio30tl0UBXkc10RqhUNM2iinb+wMW7S+6HKX5IM6I0pLIHZEaGzks8zWmiQqM9omKlqZB/46/Y1eq2K7VonfOV2xo4XACACRH92MkNLclTAV06VgNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJUeFYea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJUeFYea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6701F000FF;
	Sat, 12 Sep 2026 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243083;
	bh=28BRVP9IIUrz1LeVWo92Xr2wFSFJFcFSSL7IrFcfqKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJUeFYeaLlNYnwvrZqkfEIsX2T4MBNcFaJl03pCxZB7iH6tvDBvy1VF4Jnx6mr2rB
	 wMxRFQSBsFqqcVo3s+rrVNLiRGEO1Mo5UKI96b1x9L7ZhEbM+RhF1qMo8eR1aGtByE
	 HBhMt1YIfFt4GPyYZRbzLzteDq3lMRLkQmBaDNi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 631/798] RDMA/siw: Fix use-after-free in siw_accept()
Date: Sat, 12 Sep 2026 09:04:19 +0200
Message-ID: <20260912065531.587363589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7b2d3c39b4fc3..dfe9077ee168d 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1706,7 +1706,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 	cep->state = SIW_EPSTATE_CLOSED;
 
 	siw_free_cm_id(cep);
-	if (qp->cep) {
+	if (qp->cep == cep) {
 		siw_cep_put(cep);
 		qp->cep = NULL;
 	}
-- 
2.53.0



