Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1240632B116;
	Thu, 30 Jul 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423465; cv=none; b=C3DFC4l49LuqWATDgm+EA8o4B3y3kudL0QVfryPaDJjUOkA/KplCwyklOMwNNiRyFCwI1V692spnkCSiPW+Gu9V2UPFyx/JzsOmJ34oshZxFKLibTNnWkQ2s1ANoukTLs9bW4voKV87CuLXy31zVnCY0qpPM7jJa8/Wxpx0cmWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423465; c=relaxed/simple;
	bh=9dFClyUt0KlaS9cSpqFKGVVVTdqaXfHkjmlpGkdrB24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIy88qvHURMNzeqDywUikTpD10CjRHLq0AvrnCTiM8pc46S08Ox2iMoFCkQCp3Mg1nPd3VGUs0KbwtECIREQnJaJ32MiAziFF+EvmuaWMyJLJvZ9Z3HIoEYP3dUF752iF8iH1mKedldRl7pwPjGiwWPZg2w3PwScRLQ+ryH/JP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ4pW086; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ4pW086"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA791F000E9;
	Thu, 30 Jul 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423464;
	bh=Adh4jJkUfT5NongmjzujmGNclTUA35lrlBeCmAxwWEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQ4pW086YXKwzjEBjtY6lSNoeBfXNiLiNJOZcPoNv5zW3jSKeVzvbL2cRgqKZz7dT
	 OPRott7mZ/qaxYVmkbw7NVwv1HUBJjus0xIUXol7ByuORoIvkTGxsF4d3LJEbtLchk
	 U2ymfDWnBVaXPQZaMMOlziiPL/ktijEoF3/Q1Gs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	David Hu <xuehaohu@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/675] RDMA/irdma: Prevent user-triggered null deref on QP create
Date: Thu, 30 Jul 2026 16:06:23 +0200
Message-ID: <20260730141446.245536233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit b9b0889071569d43623c260074e159cd8f26adb1 ]

Previously, the user QP creation path would only attempt to
populate iwqp->iwpbl if the user-provided req.user_wqe_bufs
field was non-zero. The problem is that iwqp->iwpbl is
unconditionally dereferenced later on in irdma_setup_virt_qp.

While there was a check for iwqp->iwpbl != NULL, this check
would only occur if req.user_wqe_bufs was non-zero. The end
result is that a user could send a zero user_wqe_bufs value
and trigger a null ptr deref.

Fix this by unconditionally calling irdma_get_pbl and bailing
if it fails, similar to the CQ and SRQ paths.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/r/20260617164013.280790-1-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Reviewed-by: David Hu <xuehaohu@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index dfd5f0caabb878..5f5b79109d5471 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -631,17 +631,16 @@ static int irdma_setup_umode_qp(struct ib_udata *udata,
 
 	iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
 	iwqp->user_mode = 1;
-	if (req.user_wqe_bufs) {
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
-					    &ucontext->qp_reg_mem_list);
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
 
-		if (!iwqp->iwpbl) {
-			ret = -ENODATA;
-			ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
-			return ret;
-		}
+	spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
+	iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
+				    &ucontext->qp_reg_mem_list);
+	spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+
+	if (!iwqp->iwpbl) {
+		ret = -ENODATA;
+		ibdev_dbg(&iwdev->ibdev, "VERBS: no pbl info\n");
+		return ret;
 	}
 
 	if (!ucontext->use_raw_attrs) {
-- 
2.53.0



